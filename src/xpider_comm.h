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

#ifndef XPIDER_COMM_H_
#define XPIDER_COMM_H_

#include <QTimer>
#include <QObject>
#include <QThread>
#include <QTcpSocket>

#include "hdlc_qt.h"

class XpiderComm: public QObject {
  Q_OBJECT

public:
    static const QByteArray kDataHeader;
    static const quint16 kConnectTimeout;
    static const quint16 kHeartbeatInterval;

private:
    bool is_connecting_ = false;
    bool connected_;
    QString host_name_;
    quint16 host_port_;
    QTcpSocket *socket_ = NULL;

    HDLC_qt* hdlc_;

    bool heartbeat_;
    QTimer *heartbeat_timer_ = NULL;

public:
    XpiderComm(QObject *parent = 0);
    ~XpiderComm();

    bool is_connecting() { return is_connecting_; }

signals:
    void connected();
    void disconnected();
    void newFrame(const QByteArray &);
    void error(const QString &);

public slots:
    void Connect(const QString &host_name, const quint16 &host_port);
    void Disconnect();
    void SendFrame(const QByteArray &frame);

private slots:
    void HeartBeat();
    void ReadyRead();
    void SocketConnectedHanlder();
    void SocketDisconnectedHandler();
    void Send(QByteArray data);
    void GetFrame(QByteArray data, quint16 data_length);
    void ErrorHandler(QAbstractSocket::SocketError socket_error);
};

#endif // XPIDER_COMM_H_
