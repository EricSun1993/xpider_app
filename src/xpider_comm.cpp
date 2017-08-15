/**
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

#include "xpider_comm.h"

const QByteArray XpiderComm::kDataHeader = QByteArray::fromHex("0155");
const quint16 XpiderComm::kConnectTimeout = 5000;
const quint16 XpiderComm::kHeartbeatInterval = 1000;

XpiderComm::XpiderComm(QObject *parent): QObject(parent) {
  connected_ = false;

  hdlc_ =HDLC_qt::instance();
  connect(hdlc_, &HDLC_qt::hdlcValidFrameReceived, this, &XpiderComm::GetFrame);
  connect(hdlc_, SIGNAL(hdlcTransmitByte(QByteArray)), this, SLOT(Send(QByteArray)));
}

XpiderComm::~XpiderComm() {
  Disconnect();
}

void XpiderComm::Connect(const QString &host_name, const quint16 &host_port) {
  is_connecting_ = true;

  host_name_ = host_name;
  host_port_ = host_port;

  if(socket_ == NULL) {
    qDebug() << "(XpiderComm) Create new tcp socket";
    socket_ = new QTcpSocket(this);
  }

  connect(socket_, &QIODevice::readyRead, this, &XpiderComm::ReadyRead);
  connect(socket_, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(ErrorHandler(QAbstractSocket::SocketError)));
  connect(socket_, &QTcpSocket::connected, this, &XpiderComm::SocketConnectedHanlder);
  connect(socket_, &QTcpSocket::disconnected, this, &XpiderComm::SocketDisconnectedHandler);

  while(true) {
    socket_->connectToHost(host_name_, host_port_);
    if(socket_->waitForConnected(kConnectTimeout)) {
        break;
    }
    socket_->abort();
    qWarning() << "(XpiderComm) Can not connect xpider, try again";
    QThread::yieldCurrentThread();
  }

  is_connecting_ = false;
}

void XpiderComm::Disconnect() {
  if(connected_) {
    socket_->disconnectFromHost();
    // socket_->waitForDisconnected(kConnectTimeout);
    // disconnect(socket_, &QIODevice::readyRead, 0, 0);
    // disconnect(socket_, SIGNAL(error(QAbstractSocket::SocketError)), 0, 0);
  }
}

void XpiderComm::SocketConnectedHanlder() {
  connected_ = true;

  if(heartbeat_timer_ == NULL) {
    heartbeat_timer_ = new QTimer(this);
    connect(heartbeat_timer_, &QTimer::timeout, this, &XpiderComm::HeartBeat);
  }

  heartbeat_timer_->start(kHeartbeatInterval);
  emit connected();

  qDebug() << "(XpiderComm) Socket connected";
}

void XpiderComm::SocketDisconnectedHandler() {
  connected_ = false;
  heartbeat_timer_->stop();
  emit disconnected();

  qDebug() << "(XpiderComm) Socket disconnect";
}

void XpiderComm::ReadyRead() {
  QByteArray raw_data;
  raw_data = socket_->readAll();
  hdlc_->charReceiver(raw_data);

  // qDebug() << "(XpiderComm) Receive raw data: " << raw_data.toHex();
  // qDebug() << "(XpiderComm) Receive raw string: " << QString(raw_data);
}

void XpiderComm::GetFrame(QByteArray data, quint16 data_length) {
  // Cut off useless data
  data.remove(data_length, data.length()-data_length);

  emit newFrame(data);

  // qDebug() << "(XpiderComm) Receive frame: " << data.toHex() << ", length" << data.length();
}

void XpiderComm::ErrorHandler(QAbstractSocket::SocketError socket_error) {
  emit error(socket_->errorString());
  qDebug() << "(XpiderComm) Error: " << socket_error << ", " << socket_->errorString();
}

void XpiderComm::HeartBeat() {
  if(!heartbeat_) {
    SendFrame(QByteArray::fromHex("FFFFFFFF"));
    heartbeat_ = true;
  } else {
    heartbeat_ = false;
  }
}

void XpiderComm::SendFrame(const QByteArray &data) {
  /*
   * hdlc send will use signal
   * to trigger send function
   */
  hdlc_->frameDecode(data, data.length());

  // qDebug() << "(XpiderComm) Send raw: " << data.toHex();
}

void XpiderComm::Send(QByteArray data) {
  qint64 send_result;

  /* Add special data header for rakvideo */
  data.insert(0, kDataHeader);
  send_result = socket_->write(data);
  if(send_result != -1) {
    heartbeat_ = true;
  }

  // qDebug() << "(XpiderComm) Send data: " << data.toHex() << ", result: " << send_result;
}
