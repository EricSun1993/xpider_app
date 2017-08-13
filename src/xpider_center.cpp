/**
 * Author: Yunpeng Song <413740951@qq.com>
 * Author: Ye Tian <flymaxty@foxmail.com>
 * Copyright (c) 2016 Maker Collider Corporation.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 */

#define _USE_MATH_DEFINES

#include "xpider_center.h"

#include <math.h>

#include <QThread>
#include <QTime>
#include <QColor>

#include "xpider_wifi.h"

const quint16 XpiderCenter::kXpiderPort = 80;
const QString XpiderCenter::kXpiderHost = QString::fromStdString("192.168.100.1");

const quint16 XpiderCenter::kSendInterval = 20;
const quint16 XpiderCenter::kConnectInterval = 5000;
const quint16 XpiderCenter::kCommWatchdogInterval = 3000;

XpiderCenter::XpiderCenter(QObject *parent) : QObject(parent) {
  connected_ = false;
  is_active_ = false;
  last_step_counter_ = 0;
  start_autopilot_ = false;

  xpider_protocol_.Initialize(&xpider_info_);

  connect(&send_timer_, SIGNAL(timeout()), this, SLOT(SendBuffer()));
  connect(&comm_watchdog_, SIGNAL(timeout()), this, SLOT(CommWatchdog()));

  global_map_ = new GMap::GridMap(6000, 6000);
  global_map_->AddLayer("Obstacle", XPIDER_STEP_PIXEL*4);
  global_map_->AddLayer("Step", XPIDER_STEP_PIXEL);
  xpider_location_ = global_map_->GetCenter();

  memset(groupExist, false, MAX_GROUP_NUM);

  neuron_engine_ = new NeuronEngine(0, NeuronEngine::MODE_RBF);

  xpider_comm_.moveToThread(&comm_thread_);
  connect(&comm_thread_, &QThread::finished, &xpider_comm_, &QObject::deleteLater);
  connect(this, &XpiderCenter::connectDevice, &xpider_comm_, &XpiderComm::Connect);
  connect(this, &XpiderCenter::disconnectDevice, &xpider_comm_, &XpiderComm::Disconnect);
  connect(&xpider_comm_, &XpiderComm::error, this, &XpiderCenter::CommErrorHandler);
  connect(&xpider_comm_, &XpiderComm::newFrame, this, &XpiderCenter::NewFrameHandler);
  connect(&xpider_comm_, &XpiderComm::connected, this, &XpiderCenter::deviceConnectedHandler);
  connect(&xpider_comm_, &XpiderComm::disconnected, this, &XpiderCenter::deviceDisconnectedHandler);
  comm_thread_.start();
}

void XpiderCenter::connectXpider() {
  if(connected_ == false && xpider_comm_.is_connecting() == false) {
    emit connectDevice(kXpiderHost, kXpiderPort);
    qDebug() << "(XpiderCenter) connectXpider";
  } else {
    qDebug() << "(XpiderCenter) xpider connected or connecting...";
  }
}

void XpiderCenter::disconnectXpider() {
  send_timer_.stop();
  comm_watchdog_.stop();
  xpider_comm_.Disconnect();
}

void XpiderCenter::deviceConnectedHandler() {
  connected_ = true;
  is_active_ = true;

  if(!send_timer_.isActive()) {
    send_buffer_array_.clear();
    send_timer_.start(kSendInterval);
  }

  if(!comm_watchdog_.isActive()) {
    comm_watchdog_.start(kCommWatchdogInterval);
  }

  emit deviceConnected();
  qDebug() << "(XpiderCenter) device connected";
}

void XpiderCenter::deviceDisconnectedHandler() {
  send_timer_.stop();
  comm_watchdog_.stop();

  connected_ = false;
  emit deviceDisconnected();
  qDebug() << "(XpiderCenter) device disconnected";
}

void XpiderCenter::CommErrorHandler(const QString &message) {
  qDebug() << "(XpiderCenter) Error:" << message;
}

void XpiderCenter::CommWatchdog() {
  if(is_active_ == false) {
    emit disconnectDevice();
    qDebug() << "(XpiderCenter) Xpider comm watchdog triggered";
  } else {
    is_active_ = false;
  }
}

void XpiderCenter::PushSendBuffer(const QByteArray &data) {
  if(connected_) {
    send_buffer_array_.enqueue(data);
  } else {
    emit deviceDisconnected();
  }
}

void XpiderCenter::SendBuffer() {
  /* TODO: Check network status */
  if(!send_buffer_array_.empty()) {
    xpider_comm_.SendFrame(send_buffer_array_.dequeue());
  }
}

void XpiderCenter::UpdateObstacleLocation() {
  latest_obstacle_.x = sin(xpider_info_.yaw_pitch_roll[0]) * xpider_info_.obstacle_distance / 10.0f + xpider_location_.x;
  latest_obstacle_.y = cos(xpider_info_.yaw_pitch_roll[0]) * xpider_info_.obstacle_distance / 10.0f + xpider_location_.y;

  // qDebug() << "Obstacle x: " << obstacle_point.x << ", y: " << obstacle_point.y;
  // qDebug() << "Add Obstacle: x " << obstacle_point.x << ", y " << obstacle_point.y;
}

void XpiderCenter::UpdateTargetLocation() {

}

void XpiderCenter::UpdateXpiderLocation() {
  uint16_t step_delta;

  // qDebug() << "last: " << last_step_counter_ << ", current: " << xpider_protocol_.step_counter;

  step_delta = xpider_info_.step_counter - last_step_counter_;
  xpider_location_.x += sin(xpider_info_.yaw_pitch_roll[0]) * step_delta * XPIDER_STEP_PIXEL;
  xpider_location_.y += cos(xpider_info_.yaw_pitch_roll[0]) * step_delta * XPIDER_STEP_PIXEL;

  // *x_delta = xpider_location_.x - global_map_->GetCenter().x;
  // *y_delta = xpider_location_.y - global_map_->GetCenter().y;

  last_step_counter_ = xpider_info_.step_counter;

  // qDebug() << "x_delta: " << x_delta << ", y_delta: " << y_delta;
  // qDebug() << "Xpider location: " << xpider_location_.x << " " << xpider_location_.y;
}

void XpiderCenter::NewFrameHandler(QByteArray data) {
  is_active_ = true;

  const char* buffer_head = data.data();

  // qDebug() << "buffer_type: " << static_cast<int>(buffer_head[0]);

  xpider_protocol_.GetMessage(reinterpret_cast<const uint8_t*>(buffer_head), data.length());

  if(buffer_head[0] == XpiderProtocol::kRegisterResponse) {
    EmitInfoUpdated(buffer_head);
  }

  QPointF temp_point;
  map_object_list_.clear();

  UpdateXpiderLocation();
  temp_point.setX(xpider_location_.x);
  temp_point.setY(xpider_location_.y);
  map_object_list_.push_back(QVariant::fromValue(temp_point));

  if(start_autopilot_) {
    UpdateAutopilot();
  }
  temp_point.setX(target_location_.x);
  temp_point.setY(target_location_.y);
  map_object_list_.push_back(QVariant::fromValue(temp_point));

  UpdateObstacleLocation();
  temp_point.setX(latest_obstacle_.x);
  temp_point.setY(latest_obstacle_.y);
  map_object_list_.push_back(QVariant::fromValue(temp_point));

  emit voltageUpdated(xpider_info_.voltage);
  emit distanceUpdated(xpider_info_.obstacle_distance);
  emit soundLevelUpdated(xpider_info_.sound_level);
  emit mapUpdated(xpider_info_.autopilot_enable, xpider_info_.yaw_pitch_roll[0], map_object_list_);

//  qDebug() << QString("Heart message: step_counter %1, obstacle_distance %2, voltage %3, heading %4, sound %5")\
//                     .arg(xpider_info_.step_counter).arg(xpider_info_.obstacle_distance)\
//                     .arg(xpider_info_.voltage).arg(xpider_info_.yaw_pitch_roll[0]).arg(xpider_info_.sound_level);
}

void XpiderCenter::EmitInfoUpdated(const char* buffer) {
  const char* value_string;
  QString value_qstring;

  // qDebug() << "emit info type: " << static_cast<int>(buffer[1]);

  switch(buffer[1]) {
    case XpiderProtocol::kRegName: {
      value_string = xpider_info_.custom_data_.name;
      value_qstring = QString(value_string);

      emit nameUpdated(value_qstring);
      qDebug() << "Get Register(Name): " << value_qstring;
      break;
    }
    case XpiderProtocol::kRegUUID: {
      value_qstring = QString::number(static_cast<long>(xpider_info_.custom_data_.uuid));
      emit uuidUpdated(value_qstring);
      qDebug() << "Get Register(UUID): " << value_qstring;
      break;
    }
    case XpiderProtocol::kRegHardwareVersion: {
      value_string = xpider_info_.custom_data_.hardware_version;
      value_qstring = QString(value_string);
      emit versionUpdated(value_qstring);
      qDebug() << "Get Register(Version): " << value_qstring;
      break;
    }
    case XpiderProtocol::kRegFirmwareVersion: {
      value_string = xpider_info_.firmware_version;
      value_qstring = QString(value_string);
      emit firmwareUpdated(value_qstring);
      qDebug() << "Get Register(Firmware): " << value_qstring;
      break;
    }
    case XpiderProtocol::kRegControllerVersion: {
      value_string = xpider_info_.controller_version;
      value_qstring = QString(value_string);
      qDebug() << "Get Register(Controller): " << value_qstring;
      emit controllerUpdated(value_qstring);
      break;
    }
  }
}

void XpiderCenter::getXpiderInfo() {
  uint8_t *buffer;
  uint16_t length;

  QByteArray temp;

  xpider_protocol_.GetRegister(XpiderProtocol::kRegName, &buffer, &length);
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);

  xpider_protocol_.GetRegister(XpiderProtocol::kRegUUID, &buffer, &length);
  temp.clear();
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);

  xpider_protocol_.GetRegister(XpiderProtocol::kRegHardwareVersion, &buffer, &length);
  temp.clear();
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);

  xpider_protocol_.GetRegister(XpiderProtocol::kRegFirmwareVersion, &buffer, &length);
  temp.clear();
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);

  xpider_protocol_.GetRegister(XpiderProtocol::kRegControllerVersion, &buffer, &length);
  temp.clear();
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);
}

void XpiderCenter::updateName(QString name) {
  uint8_t *buffer;
  uint16_t length;

  strcpy(xpider_info_.custom_data_.name, name.toStdString().c_str());
  xpider_protocol_.UpdateRegister(XpiderProtocol::kRegName, &buffer, &length);

  QByteArray temp;
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);

  if(connected_) {
    bool ssid_status = xpider_wifi_.SetSSID(name);
    qDebug() << "(XpiderCenter) Change SSID" << ssid_status;
  }
}

void XpiderCenter::emergencyStop() {
  QByteArray temp_info;
  temp_info.append(XpiderProtocol::kEmergencyStop);
  temp_info.append(QByteArray::fromHex("FFFFFF"));

  PushSendBuffer(temp_info);
}

void XpiderCenter::setMove(int move, int rotate) {
  // qDebug() << "move: " << move << " rotate: " << rotate;
  if(abs(move) > 100 || abs(rotate) > 100) {
    qDebug() << "Invaild move & rotate value";
  } else {
    uint8_t *buffer;
    uint16_t length;
    xpider_info_.move = move;
    xpider_info_.rotate = rotate;
    xpider_protocol_.GetBuffer(xpider_protocol_.kMove, &buffer, &length);

    QByteArray temp;
    temp.append(reinterpret_cast<char*>(buffer), length);
    PushSendBuffer(temp);

    // qDebug() << "Setmove: " << temp.toHex() << ",length: " << temp.length();
  }
}

void XpiderCenter::setEyePower(bool power) {
  uint8_t *buffer;
  uint16_t length;

  xpider_info_.eye_power = power;
  xpider_protocol_.GetBuffer(xpider_protocol_.kEye, &buffer, &length);

  QByteArray temp;
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);
}

void XpiderCenter::setEyeAngle(int angle) {
  uint8_t *buffer;
  uint16_t length;

  xpider_info_.eye_angle = angle;
  xpider_protocol_.GetBuffer(xpider_protocol_.kEye, &buffer, &length);

  QByteArray temp;
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);
}

void XpiderCenter::setEyeMove(int move_value) {
  uint8_t *buffer;
  uint16_t length;

  if(move_value != 0) {
    if(move_value < 0) {
      xpider_info_.eye_angle = (xpider_info_.eye_angle-4)<15 ? 15 : (xpider_info_.eye_angle-4);
    } else {
      xpider_info_.eye_angle = (xpider_info_.eye_angle+4)>65 ? 65 : (xpider_info_.eye_angle+4);
    }

    xpider_protocol_.GetBuffer(xpider_protocol_.kEye, &buffer, &length);
    QByteArray temp;
    temp.append(reinterpret_cast<char*>(buffer), length);
    PushSendBuffer(temp);
    // qDebug() << "setEyeMove buffer" << QByteArray::fromRawData(reinterpret_cast<char*>(buffer), length).toHex();
  }

   // qDebug() << "setEyeMove: " << xpider_info_.eye_angle;
}

void XpiderCenter::setFrontLedsByHSV(int left_h, int left_s, int left_v,
                                     int right_h, int right_s, int right_v) {
  /* QColor s,v value is 0-255, standard hsv value is 0-360, 0-100, 0-100 */
  QColor left_color = QColor::fromHsv(left_h, left_s/100*255, left_v/100*255);
  QColor right_color = QColor::fromHsv(right_h, right_s/100*255, right_v/100*255);

  setFrontLeds(left_color.red(), left_color.green(), left_color.blue(),
               right_color.red(), right_color.green(), right_color.blue());
}

void XpiderCenter::setFrontLeds(int left_r, int left_g, int left_b,
                                int right_r, int right_g, int right_b) {
  uint8_t *buffer;
  uint16_t length;

  xpider_info_.left_led_rgb[0] = left_r;
  xpider_info_.left_led_rgb[1] = left_g;
  xpider_info_.left_led_rgb[2] = left_b;
  xpider_info_.right_led_rgb[0] = right_r;
  xpider_info_.right_led_rgb[1] = right_g;
  xpider_info_.right_led_rgb[2] = right_b;

  xpider_protocol_.GetBuffer(xpider_protocol_.kFrontLeds, &buffer, &length);

  QByteArray temp;
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);
}

void XpiderCenter::setAutopilotTarget(float target_relative_x, float target_relative_y) {
  if(connected_ == true) {
    target_location_.x = target_relative_x + xpider_location_.x;
    target_location_.y = target_relative_y + xpider_location_.y;

    start_autopilot_ = true;
  } else {
    emit deviceDisconnected();
  }
}

void XpiderCenter::UpdateAutopilot() {
  float delta_x = target_location_.x - xpider_location_.x;
  float delta_y = target_location_.y - xpider_location_.y;
  float target_degree = M_PI_2 - atan2(delta_y, delta_x);

  /* Xpider use -PI to PI */
  target_degree = target_degree>M_PI ? target_degree-M_PI*2 : target_degree;

  if(fabs(delta_x) > 5 || fabs(delta_y) > 5) {
    uint8_t *buffer;
    uint16_t length;

    xpider_info_.autopilot_enable = true;
    xpider_info_.autopilot_heading = target_degree;
    xpider_protocol_.GetBuffer(xpider_protocol_.kAutoPilot, &buffer, &length);

    QByteArray temp;
    temp.append(reinterpret_cast<char*>(buffer), length);
    PushSendBuffer(temp);
  } else {
    stopAutopilot();
  }

  // qDebug() << "t_x: " << target_location_.x;
  // qDebug() << "t_y: " << target_location_.y;
  // qDebug() << "x_x: " << xpider_location_.x;
  // qDebug() << "x_y: " << xpider_location_.y;
  // qDebug() << "t_d: " << target_degree;
}

void XpiderCenter::stopAutopilot() {
  uint8_t *buffer;
  uint16_t length;

  start_autopilot_ = false;
  xpider_info_.autopilot_enable = false;
  xpider_protocol_.GetBuffer(xpider_protocol_.kAutoPilot, &buffer, &length);

  QByteArray temp;
  temp.append(reinterpret_cast<char*>(buffer), length);
  PushSendBuffer(temp);
}

bool XpiderCenter::learn(int group_index, QVariantList sensor_list) {
  uint8_t remap_value = 0;
  if(groupExist[group_index] == true) {
    QByteArray temp_info;
    // qDebug()<<"obstacle_distance:"<<xpider_info_.obstacle_distance;
    for(int i=0; i<sensor_list.length(); i++) {
      if(sensor_list.at(i).toInt() == 1) {
        remap_value = (xpider_info_.obstacle_distance - 40) * (255 - 0) / (500 - 40) + 0;
        temp_info.append(remap_value);
        qDebug() << "Obstacle distance:" << xpider_info_.obstacle_distance << "remap:" << remap_value;
      } else if(sensor_list.at(i).toInt() == 2) {
        temp_info.append(static_cast<char>(xpider_info_.sound_level));
        qDebug() << "Sound level: " << xpider_info_.sound_level << "remap:" << xpider_info_.sound_level;
      } else if(sensor_list.at(i).toInt() == 3) {
        for(uint8_t i=0; i<3; i++) {
          remap_value = (xpider_info_.yaw_pitch_roll[i] - (-3.14)) * (255 - 0) / (3.14 - (-3.14)) + 0;
          temp_info.append(remap_value);
        }
        qDebug() << "YAW data:" << xpider_info_.yaw_pitch_roll[0] << "," << xpider_info_.yaw_pitch_roll[1] << "," << xpider_info_.yaw_pitch_roll[2] \
                 << "remap:" << temp_info[temp_info.length()-3] << "," << temp_info[temp_info.length()-2] << "," << temp_info[temp_info.length()-1];
      }
    }
    
    int neuron_number = neuron_engine_->Learn(group_index, reinterpret_cast<uint8_t*>(temp_info.data()), temp_info.length());
    int classify_check = neuron_engine_->Classify(reinterpret_cast<uint8_t*>(temp_info.data()), temp_info.length());
    qDebug() << "Learn Group" << group_index << ", data:" << temp_info.toHex().toUpper();
    qDebug() << "Neuron number: " << neuron_number << ", Classify check: " << classify_check;
    return neuron_number;
  } else {
    qDebug() << "Group " << group_index << " does not exist!";
    return false;
  }
  return true;
}

int XpiderCenter::classify(int _vec, int _len) {
  uint8_t *vec = (uint8_t*)(&_vec);
  int len = _len;
  return neuron_engine_->Classify(vec, len);
}

bool XpiderCenter::saveGroupData(QByteArray list)
{
  QVector<uint8_t> temp_group;
  qDebug()<<"list length is: "<<list.length();
  qDebug()<<list;
  QJsonObject oneGroupData = QJsonDocument::fromJson(list).object();
  groupDataInfo[oneGroupData.value("id").toInt()] = oneGroupData.value("action").toArray();
  groupExist[oneGroupData.value("id").toInt()] = true;
  
  for(int j = 0; j <MAX_GROUP_NUM; j++) {
    //qDebug()<<"Group "<< oneGroupData.value("id").toInt() << " has " << groupDataInfo[oneGroupData.value("id").toInt()].size() << "actions";
    if(groupExist[j] == true) {
      qDebug() << "Group " << j << " has " << groupDataInfo[j].size() << "actions";
      for(int i=0; i<groupDataInfo[j].size(); i++) {
        qDebug()<<groupDataInfo[j][i].toObject().value("type");
      }
    }
  }
  return true;
}

int XpiderCenter::clearData() {
  memset(groupExist, false, MAX_GROUP_NUM);
  return 0;
}

int XpiderCenter::deleteGroup(int id) {
  groupExist[id] = false;
  return 0;
}

int XpiderCenter::getGroupNum() {
  int count = 0;
  for(int i = 0; i<MAX_GROUP_NUM; i++) {
    if(groupExist[i] == true) {
      count++;
    }
  }
  
  return count;
}

int XpiderCenter::sendLearnInfo(QVariantList data) {
  QByteArray temp_whole_info;

  temp_whole_info.append(XpiderProtocol::kNNInfo); // 1功能位
  temp_whole_info.append(0x02); // 2版本号

  temp_whole_info.append(static_cast<char>(data.length()));
  for(int i=0; i< data.length(); i++) {
    temp_whole_info.append(data[i].toInt());
    qDebug() << "Sensor data" << data[i].toInt();
  }
  qDebug() << "Sensor length" << data.length();

  int n = neuron_engine_->NeuronCount();
  int realSize = 0;
  //筛选有效的神经元
  for(int j=0; j<n; j++ ) {
    // 每个神经元信息
    const Neuron *myNeuron = neuron_engine_->ReadNeuron(j);
    if(groupExist[myNeuron->Cat()] == true) {
      realSize++; // 只有没有删掉的组对应的神经元信息才有用，才能发送给Curie
    } else {
      qDebug() << "group of cat " << myNeuron->Cat() << " not exist";
    }
  }

  qDebug() << "Neuron Size:" << neuron_engine_->NeuronCount() << "," << realSize << "available";

  temp_whole_info.append(realSize);//  神经元个数 9

  /* Send Neurons */
  uint8_t *buffer;
  for(int j=0; j<n; j++) {
    const Neuron *myNeuron = neuron_engine_->ReadNeuron(j);

    if(groupExist[myNeuron->Cat()] == true) {
      buffer = new uint8_t(myNeuron->NeuronMemLength());
      myNeuron->ReadNeuronMem(buffer);
      temp_whole_info.append(myNeuron->NeuronMemLength());                                    /* Add length */
      temp_whole_info.append(reinterpret_cast<char*>(buffer), myNeuron->NeuronMemLength());   /* Add data */
      temp_whole_info.append(myNeuron->Cat());                                                /* Add cat */

      qDebug() << "Neuron" << j << ": data length" << myNeuron->NeuronMemLength() << ", cat" << myNeuron->Cat() \
      << ", data:" << QByteArray(reinterpret_cast<char*>(buffer), myNeuron->NeuronMemLength()).toHex();
      delete buffer;
    }
  }
  
  uint16_t temp_len = (uint16_t)(temp_whole_info.length()+3);// 长度重新赋值
  uint8_t  low_data = 0x00ff & temp_len;
  // uint8_t  high_data = 0xff00 & temp_len;
  uint8_t high_data = temp_len >> 8;
  temp_whole_info.insert(2,low_data);   //3 长度低
  temp_whole_info.insert(3,high_data);  //4 长度高
  
  //CRC_SUM
  uint8_t crc_sum = 0;
  int  crc_sum_int=0;
  //qDebug()<<"len:"<<temp_whole_info.length();
  for(int m=0; m<temp_whole_info.length(); m++) {
    //qDebug()<<(int)temp_whole_info.at(m);
    crc_sum_int += (int)temp_whole_info.at(m);
  }
  crc_sum = 0x00ff & crc_sum_int;
  temp_whole_info.append(crc_sum);//最后一位 crc
  
  qDebug() << "All NN data:" << temp_whole_info.toHex();
  
  QByteArray temp_20_info;
  for (int n=0; n<temp_whole_info.count(); n++) {
    //截成18长度 并且发送
    temp_20_info.append(temp_whole_info.at(n));
    
    if(n!=0 && (n%12)==0) {
      PushSendBuffer(temp_20_info);
      
      // for(int i =0 ; i<temp_20_info.length();i++ ) {
      //     qDebug()<<"buffer_18"<<i<<":"<<(int)temp_20_info.at(i);//打印
      // }
      // qDebug()<<"-------------------------";
      
      temp_20_info.clear();
      temp_20_info.append(0x06);
    }
  }
  PushSendBuffer(temp_20_info);
  
  // for(int i =0 ; i<temp_20_info.length();i++ ) {
  //    qDebug()<<"buffer_18"<<i<<":"<<(int)temp_20_info.at(i);//打印
  // }
  return 1;
}

int XpiderCenter::sendGroupInfo()
{
  //QVector(QVector(1, 1, 100, 7, 208), QVector(2, 1, 100, 7, 208, 2, 100, 7, 208), QVector(2, 1, 100, 7, 208, 2, 100, 7, 208))
  QVector<uint8_t> temp_whole_info;
  //int all_group_len = 0;
  
  temp_whole_info.append(XpiderProtocol::kGroupInfo);
  temp_whole_info.append(0x01);
  //all_group_len +=2;
  
  for(uint8_t i=0; i<MAX_GROUP_NUM; i++) {
    if(groupExist[i] == true) {
      //只发送有效地组信息
      temp_whole_info.append(i);                                                                                  // 添加组ID
      temp_whole_info.append((uint8_t)groupDataInfo[i].size());                                                   // 添加组内动作数
      for(uint8_t j = 0; j < groupDataInfo[i].size(); j++) {
        if(groupDataInfo[i][j].toObject().value("type") == "walk") {
          temp_whole_info.append(0);                                                                            // 添加walk的动作ID
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("speed").toInt());               // 添加walk参数值
          temp_whole_info.append(0);
          temp_whole_info.append((uint8_t)(0x000000ff & groupDataInfo[i][j].toObject().value("time").toInt())); // 时间参数低8位
          temp_whole_info.append((uint8_t)(groupDataInfo[i][j].toObject().value("time").toInt() >> 8));         // 时间高8位
        } else if(groupDataInfo[i][j].toObject().value("type") == "rotate") {
          temp_whole_info.append(1);                                                                            // 添加rotate的动作ID
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("speed").toInt());               // 添加rotate参数值
          temp_whole_info.append(0);
          temp_whole_info.append((uint8_t)(0x00ff & groupDataInfo[i][j].toObject().value("time").toInt()));     // 时间参数低8位
          temp_whole_info.append((uint8_t)(groupDataInfo[i][j].toObject().value("time").toInt() >> 8));         // 时间高8位
        } else if(groupDataInfo[i][j].toObject().value("type") == "led") {
          temp_whole_info.append(2);                                                                            // 添加led的动作ID
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("lr").toInt());                  // 添加led的左灯参数值
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("lg").toInt());
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("lb").toInt());
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("rr").toInt());                  // 添加led的右灯参数值
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("rg").toInt());
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("rb").toInt());
          temp_whole_info.append((uint8_t)(0x000000ff & groupDataInfo[i][j].toObject().value("time").toInt())); // 时间参数低8位
          temp_whole_info.append((uint8_t)(groupDataInfo[i][j].toObject().value("time").toInt() >> 8));         // 时间高8位
        } else if(groupDataInfo[i][j].toObject().value("type") == "eye") {
          temp_whole_info.append(3);                                                                            // 添加eye的动作ID
          temp_whole_info.append((uint8_t)groupDataInfo[i][j].toObject().value("angle").toInt());               // 添加eye参数值
          temp_whole_info.append(0);
          temp_whole_info.append((uint8_t)(0x000000ff & groupDataInfo[i][j].toObject().value("time").toInt())); // 时间参数低8位
          temp_whole_info.append((uint8_t)(groupDataInfo[i][j].toObject().value("time").toInt() >> 8));         // 时间高8位
        } else if(groupDataInfo[i][j].toObject().value("type") == "speaker") {
          temp_whole_info.append(4);                                                                            // 添加speaker的动作ID
          temp_whole_info.append(100);                                                                          // 添加speaker的参数值
          temp_whole_info.append(0);
          temp_whole_info.append(200);
          temp_whole_info.append(0);
        } else {
          qDebug() << "unkonwn action: " << groupDataInfo[i][j].toObject().value("type");
        }
      }
    }
  }
  //groupDataInfo[oneGroupData.value("id").toInt()] = oneGroupData.value("action").toArray();
  //groupExist[oneGroupData.value("id").toInt()] = true;
  
  //    QVector<uint8_t> tem_cell;
  //    for(int i=0; i<all_group_list.length();i++)
  //    {
  //        tem_cell = all_group_list.at(i);
  //        all_group_len += tem_cell.length();
  //    }
  
  //    uint16_t temp_len = ( uint16_t)(all_group_len+5);//
  qDebug() << "len without crc = " << temp_whole_info.length();
  qDebug() << "len before insert = " << temp_whole_info.length()+1;
  qDebug() << QByteArray(reinterpret_cast<char*>(temp_whole_info.data()), temp_whole_info.size()).toHex();

  uint8_t low_data = 0x000000ff & (temp_whole_info.length()+3); //加上crc和自己（长度）的总长度
  // uint8_t high_data = 0x0000ff00 & (temp_whole_info.length()+3);
  uint8_t high_data = (temp_whole_info.length()+3) >> 8;
  temp_whole_info.insert(2, low_data);    //2 长度低
  temp_whole_info.insert(3, high_data);   //3 长度高
  
  //    QVector<uint8_t> group_cell;
  //    for(int m=0; m<all_group_list.length();m++)
  //    {
  //        group_cell.clear();
  //        group_cell=all_group_list.at(m);
  //        //qDebug()<< "动作组"<<m+1<<":"<<group_cell.length();
  //        for(int n= 0; n<group_cell.length();n++)
  //        {
  //            temp_whole_info.append(group_cell.at(n));
  //            //qDebug()<< "group_cell"<<":"<<group_cell.at(n);
  //        }
  //    }
  /////////////////////CRC///////////////////////
  uint8_t crc_sum = 0;
  int crc_sum_int=0;
  
  for(int m=0; m<temp_whole_info.length(); m++) {
    //qDebug()<<(int)temp_whole_info.at(m);
    crc_sum_int += (int)temp_whole_info.at(m);
  }
  // qDebug()<<crc_sum_int;
  crc_sum = 0x00ff & crc_sum_int;
  qDebug() << "CRC = " << crc_sum;
  temp_whole_info.append(crc_sum);//最后一位 crc
  //temp_whole_info.append(all_group_list.length());//动作组长度
  qDebug() << "len:" << temp_whole_info.length();
  qDebug() << QByteArray(reinterpret_cast<char*>(temp_whole_info.data()), temp_whole_info.size()).toHex();

  QByteArray temp_20_info;
  for (int n=0; n<temp_whole_info.count(); n++) {
    //截成12长度 并且发送
    temp_20_info.append(temp_whole_info.at(n));
    
    if(n!=0 && ((n%12)==0)) {
      PushSendBuffer(temp_20_info);
      
      // for(int i =0 ; i<temp_20_info.length();i++ ) {
      //   qDebug()<<"buffer_13"<<i<<":"<<(int)temp_20_info.at(i);//打印
      // }
      // qDebug()<<"------";
      
      temp_20_info.clear();
      temp_20_info.append(0x05);
    }
  }
  
  // for(int i =0 ; i<temp_20_info.length();i++ ) {
  //     qDebug()<<"buffer_18"<<i<<":"<<(int)temp_20_info.at(i);//打印
  // }
  
  PushSendBuffer(temp_20_info);
  
  return 1;
}

int XpiderCenter::sendRunData() {
  QByteArray  temp_whole_info;
  temp_whole_info.append(XpiderProtocol::kRun);
  temp_whole_info.append("ttttt");
  PushSendBuffer(temp_whole_info);
  return 1;
}

int XpiderCenter::forget() {
  neuron_engine_->ResetEngine();
  return 1;
}
