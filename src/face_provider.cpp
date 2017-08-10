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

#include "face_provider.h"

void FaceProvider::updateImage(int index, QImage image) {
  Q_UNUSED(index);
  face_list_[index] = image.copy();
}

FaceProvider::FaceProvider(QObject *parent): QObject(parent), QQuickImageProvider(QQuickImageProvider::Image){
}

QImage FaceProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize) {
  // Q_UNUSED(id);
  Q_UNUSED(size);
  Q_UNUSED(requestedSize);

  return face_list_[id.toInt()];
}
