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
