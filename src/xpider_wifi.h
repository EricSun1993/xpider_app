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
