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

#ifndef XPIDER_WIFI_H
#define XPIDER_WIFI_H

#include <QObject>
#include <QtNetwork>

class XpiderWIFI : public QObject
{
  Q_OBJECT
public:
  static const QString kReuqestUrl;

  static const QString kUserName;
  static const QString kUserPassword;

  static const QString kWifiPassword;
private:
  QNetworkAccessManager *network_manager_;

  bool get_reply;
public:
  explicit XpiderWIFI(QObject *parent = nullptr);

  bool SetSSID(QString);

private slots:
  void NetReply(QNetworkReply*);
  void AuthReply(QNetworkReply*, QAuthenticator*);
};

#endif // XPIDER_WIFI_H
