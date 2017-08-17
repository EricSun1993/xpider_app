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

#include <QTime>
#include <QQuickWindow>
#include <QtNetwork>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QVariant>
#include <QDir>

#include "src/face_provider.h"
#include "src/xpider_center.h"
#include "src/face_detect_filter.h"
#include "src/xpider_camera.h"

void delay() {
  QTime t;
  t.start();
  while(t.elapsed()<2000) {
    QCoreApplication::processEvents();
  }
}

int main(int argc, char *argv[])
{
  QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;
  QQmlContext * ctx = engine.rootContext();

  QString storage_path = engine.offlineStoragePath();
  QDir dir(storage_path);
  if(!dir.exists()){
    dir.mkpath(storage_path);
  }

  XpiderCenter xpider_center;

  FaceProvider face_provider;

  engine.addImageProvider("face_provider",&face_provider);

  ctx->setContextProperty("xpider_center",&xpider_center);
  ctx->setContextProperty("face_provider", &face_provider);

  qmlRegisterType<XpiderCamera>("Xpider", 1, 0, "XCamera");
  qmlRegisterType<FaceDetectFilter>("Xpider", 1, 0, "FaceDetectFilter");

  // TODO: This is not a offical way to delay splash page
  //delay();

  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());
  window->showFullScreen();

  return app.exec();
}
