#include "xpider_neural.h"

#include <QFile>

#include <QDebug>

#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

const QString XpiderNeural::kNNDataFileName = "nn_data.json";
const QString XpiderNeural::kGroupDataFileName = "group_data.json";

XpiderNeural::XpiderNeural(QObject *parent) : QObject(parent) {

}

void XpiderNeural::SetFilePath(QString file_path) {
  file_path_ = file_path;
  nn_file_path = file_path_ + "/" + kNNDataFileName;
  group_file_path = file_path_ + "/" + kGroupDataFileName;
}

bool XpiderNeural::LoadNNData() {
  return true;
}

bool XpiderNeural::SaveNNData() {
  return true;
}

QByteArray XpiderNeural::LoadGroupData() {
  QFile group_file(group_file_path);

  if(!group_file.open(QIODevice::ReadWrite)) {
    qDebug() << "(XpiderNeural) Can not open file" << group_file_path;
    return QByteArray("");
  }

  QByteArray data = group_file.readAll();

  group_file.close();

//  QJsonDocument json_doc = QJsonDocument::fromJson(data);
//  QJsonArray json_array = json_doc.array();

//  qDebug() << "json doc:" << json_doc;
//  qDebug() << "json doc:" << json_array;
  return data;
}

bool XpiderNeural::SaveGroupData(QByteArray json_data) {
  QFile group_file(group_file_path);

  if(!group_file.open(QIODevice::ReadWrite | QIODevice::Truncate)) {
    qDebug() << "(XpiderNeural) Can not open file" << group_file_path;
    return false;
  }

  QJsonDocument json_doc = QJsonDocument::fromJson(json_data);
  group_file.write(json_doc.toJson(QJsonDocument::Compact));

  group_file.close();
  return true;
}

/* TODO: Move NN function from xpider_center to here */
