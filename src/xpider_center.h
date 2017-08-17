/*
 * Xpider APP software, running on both ios and android
 * Copyright (C) 2015-2017  Roboeve, MakerCollider
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef XPIDER_CENTER_H_
#define XPIDER_CENTER_H_

#include <QTimer>
#include <QMutex>
#include <QQueue>
#include <QPointF>
#include <QObject>

#include <vector>
#include <QVector>

#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

#include "xpider_wifi.h"
#include "xpider_info.h"
#include "xpider_comm.h"
#include "xpider_neural.h"
#include "xpider_protocol.h"

#include "grid_map.h"
#include "neuronengine.h"

#define XPIDER_STEP_PIXEL 3.25 // cm per step
#define SPIDER_AUTOPILOT_MIN_RADIUS 200

class XpiderCenter : public QObject {
  Q_OBJECT

public:
  static const QString kXpiderHost;                /* Xpider host address*/
  static const quint16 kXpiderPort;                /* Xpider port */

  static const quint16 kSendInterval;
  static const quint16 kConnectInterval;
  static const quint16 kCommWatchdogInterval;

private:
  QThread comm_thread_;
  XpiderWIFI xpider_wifi_;
  XpiderComm xpider_comm_;
  XpiderNeural xpider_neural_;

  XpiderInfo xpider_info_;
  XpiderProtocol xpider_protocol_;

  QTimer send_timer_;
  QTimer comm_watchdog_;
  QQueue<QByteArray> send_buffer_array_;

  bool start_autopilot_;
  bool connected_;
  bool is_active_;

  GMap::GridMap *global_map_;
  GMap::Point xpider_location_;
  GMap::Point latest_obstacle_;
  GMap::Point target_location_;
  std::vector<GMap::Cell> obstacle_list_;

  uint16_t last_step_counter_;

  // object list index:
  // 0 xpider_location
  // 1 target object
  // 2 latest_obstacle
  // obstacle_list(unavailable)
  QVariantList map_object_list_;


  NeuronEngine *neuron_engine_;
  QJsonArray groupDataInfo[MAX_GROUP_NUM];
  bool groupExist[MAX_GROUP_NUM];
  QStringList group_list;
  int neuron_count;
  QVector<QVector<uint8_t>>  all_group_list;

public:
  explicit XpiderCenter(QObject *parent = 0);

  Q_INVOKABLE bool connected() { return connected_; }

  Q_INVOKABLE void connectXpider();
  Q_INVOKABLE void disconnectXpider();
  Q_INVOKABLE void getXpiderInfo();
  Q_INVOKABLE void updateName(QString name);
  Q_INVOKABLE void emergencyStop();
  Q_INVOKABLE void setMove(int move, int rotate);
  Q_INVOKABLE void setEyePower(bool power);
  Q_INVOKABLE void setEyeAngle(int angle);
  Q_INVOKABLE void setEyeMove(int move_value);
  Q_INVOKABLE void stopAutopilot();
  Q_INVOKABLE void setAutopilotTarget(float target_relative_x, float target_relative_y);
  Q_INVOKABLE void setFrontLedsByHSV(int left_h, int left_s, int left_v,
                                     int right_h, int right_s, int right_v);
  Q_INVOKABLE void setFrontLeds(int left_r, int left_g, int left_b,
                                int right_r, int right_g, int right_b);

  // Q_INVOKABLE QVariantList getObstacleList(int x_max_delta, int y_max_delta);

  Q_INVOKABLE int classify(int _vec,int _len);
  Q_INVOKABLE int clearData();
  Q_INVOKABLE int getGroupNum();
  Q_INVOKABLE int deleteGroup(int id);
  
  Q_INVOKABLE int sendRunData();
  Q_INVOKABLE int sendGroupInfo();
  Q_INVOKABLE int sendLearnInfo(QVariantList data);
  
  Q_INVOKABLE int forget();
  Q_INVOKABLE bool saveGroupData(QByteArray list);
  Q_INVOKABLE bool learn(int group_index, QVariantList sensor_list);

  Q_INVOKABLE QByteArray loadGroupFile();
  Q_INVOKABLE bool saveGroupFile(QByteArray group_data);

private:
  void EmitInfoUpdated(const char* buffer);

  void PushSendBuffer(const QByteArray &data);

  void UpdateAutopilot();
  void UpdateXpiderLocation();
  void UpdateTargetLocation();
  void UpdateObstacleLocation();

signals:
  void connectDevice(const QString &host_name, const quint16 &host_port);
  void disconnectDevice();
  void deviceConnected();
  void deviceDisconnected();

  void obstacleUpdated();
  void voltageUpdated(float voltage);
  void distanceUpdated(float distance);
  void soundLevelUpdated(int sound_value);
  void mapUpdated(bool autopilot_enable, float heading, QVariantList map_object_list);

  void uuidUpdated(QString uuid);
  void nameUpdated(QString name);
  void versionUpdated(QString version);
  void firmwareUpdated(QString firmware);
  void controllerUpdated(QString controller);

public slots:
  void NewFrameHandler(QByteArray);

private slots:
  void SendBuffer();
  void CommErrorHandler(const QString &message);
  void CommWatchdog();

  void deviceConnectedHandler();
  void deviceDisconnectedHandler();

};

#endif // XPIDER_CENTER_H_
