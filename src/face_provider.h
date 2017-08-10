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

#ifndef FACE_PROVIDER_H_
#define FACE_PROVIDER_H_

#include <QImage>
#include <QObject>
#include <QQuickImageProvider>

class FaceProvider: public QObject, public QQuickImageProvider {
  Q_OBJECT
public:
  explicit FaceProvider(QObject *parent = 0);

  Q_INVOKABLE void updateImage(int index, QImage image);

  QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
private:
  QImage face_list_[5];
};

#endif // FACE_PROVIDER_H_
