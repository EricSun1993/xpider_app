#include "xpider_wifi.h"

const QString XpiderWIFI::kReuqestUrl = "http://192.168.100.1/param.cgi";
const QString XpiderWIFI::kUserName = "admin";
const QString XpiderWIFI::kUserPassword = "admin";
const QString XpiderWIFI::kWifiPassword = "12345678";

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
