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

#include "xpider_wifi.h"

const QString XpiderWIFI::kUserName = "admin";
const QString XpiderWIFI::kUserPassword = "admin";
const QString XpiderWIFI::kWifiPassword = "12345678";
const QString XpiderWIFI::kReuqestUrl = "http://192.168.100.1/param.cgi";

XpiderWIFI::XpiderWIFI(QObject *parent) : QObject(parent) {
  network_manager_ = new QNetworkAccessManager(this);

  connect(network_manager_, SIGNAL(finished(QNetworkReply*)), this, SLOT(NetReply(QNetworkReply*)));
  connect(network_manager_,SIGNAL(authenticationRequired(QNetworkReply*,QAuthenticator*)),
          this, SLOT(AuthReply(QNetworkReply*,QAuthenticator*)));
}

bool XpiderWIFI::SetSSID(QString ssid_name) {
  get_reply = false;

  QEventLoop event_loop;
  connect(network_manager_, SIGNAL(finished(QNetworkReply*)), &event_loop, SLOT(quit()));

  QUrlQuery parameter;
  parameter.addQueryItem("action", "update");
  parameter.addQueryItem("group", "wifi");
  parameter.addQueryItem("ap_auth_key", kWifiPassword);
  parameter.addQueryItem("ap_auth_mode", "WPA2PSK");
  parameter.addQueryItem("ap_encrypt_type", "AES");
  parameter.addQueryItem("ap_ssid", ssid_name+"%20%23=BRING"); /* TODO: need to know why add %20%23=BRING */

  QUrl url(kReuqestUrl);
  url.setQuery(parameter);
  qDebug() << "(XpiderWIFI) Request url:" << url.toDisplayString();

  QNetworkRequest request(url);
  QNetworkReply *reply = network_manager_->get(request);
  event_loop.exec();
  if(reply->error() != QNetworkReply::NoError) {
    qDebug() << "(XpiderWIFI) Error " << reply->errorString();
    return false;
  }

  return true;
}

void XpiderWIFI::NetReply(QNetworkReply *reply) {
  get_reply=true;
  qDebug() << "(XpiderWIFI) reply:" << reply->readAll();
}

void XpiderWIFI::AuthReply(QNetworkReply* reply, QAuthenticator* auth) {
  Q_UNUSED(reply);

  auth->setUser(kUserName);
  auth->setPassword(kUserPassword);

  qDebug() << "(XpiderWIFI) Auth request";
}
