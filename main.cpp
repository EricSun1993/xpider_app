/**
 * Author: Yunpeng Song <413740951@qq.com>
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
