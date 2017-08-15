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
#include <QSize>
#include <QDebug>
#include <QPixmap>

#include "xpider_camera.h"

XpiderCamera::XpiderCamera(QObject *parent) : QObject(parent) {
  videoFrame_ = new QVideoFrame(IMAGE_HEIGHT*IMAGE_WIDTH*3/2, QSize(IMAGE_WIDTH,IMAGE_HEIGHT),
                                IMAGE_WIDTH, QVideoFrame::PixelFormat::Format_YUV420P);

  if(!videoFrame_->isMapped())
    videoFrame_->map(QAbstractVideoBuffer::ReadOnly);

  rak_camera_.moveToThread(&rak_thread_);
  rak_camera_.Initialize(&mutex_, "rtsp://admin:admin@192.168.100.1:554/cam1/h264");

  connect(&rak_camera_, &RakCamera::connectionResult, this, &XpiderCamera::connectionResultGet);
  connect(&rak_camera_, &RakCamera::error, this, &XpiderCamera::errorGet);
  connect(&rak_camera_, &RakCamera::imageReady, this, &XpiderCamera::imageReceived);
  connect(this, &XpiderCamera::startRakVideo, &rak_camera_, &RakCamera::doWork);
  // connect(&rak_thread_, &QThread::finished, &rak_camera_, &RakCamera::deleteLater);

  is_opened_ = false;
}

XpiderCamera::~XpiderCamera(){
  stopVideo();
}

QAbstractVideoSurface* XpiderCamera::getVideoSurface() const
{
  return videoSurface_;
}

void XpiderCamera::setVideoSurface(QAbstractVideoSurface* surface)
{
  if(videoSurface_ != surface){
    videoSurface_ = surface;
  }
  // qDebug() << "setVideoSurface";
}

bool XpiderCamera::startVideo() {
  rak_thread_.start();
  emit startRakVideo();

  if(videoSurface_) {
    if(videoSurface_->isActive()) {
      videoSurface_->stop();
    }
    if(!videoSurface_->start(QVideoSurfaceFormat(QSize(IMAGE_WIDTH, IMAGE_HEIGHT), QVideoFrame::PixelFormat::Format_YUV420P))) {
      qDebug() << "Could not start QAbstractVideoSurface, error:" << videoSurface_->error();
      return false;
    }
  }

  return true;
}

bool XpiderCamera::stopVideo() {
  rak_camera_.stopCamera();

  while(rak_camera_.is_running()) {
    QThread::yieldCurrentThread();
  }

  rak_thread_.terminate();
  rak_thread_.wait();

  if(videoSurface_) {
    if(videoSurface_->isActive()) {
      videoSurface_->stop();
    }
  }

  is_opened_ = false;

  return true;
}

void XpiderCamera::imageReceived(uint8_t* data, uint8_t* data1, uint8_t* data2) {
  memcpy(videoFrame_->bits(), data, IMAGE_WIDTH*IMAGE_HEIGHT);
  memcpy(videoFrame_->bits()+IMAGE_HEIGHT*IMAGE_WIDTH, data1, IMAGE_WIDTH*IMAGE_HEIGHT/4);
  memcpy(videoFrame_->bits()+IMAGE_WIDTH*IMAGE_HEIGHT*5/4, data2, IMAGE_WIDTH*IMAGE_HEIGHT/4);

  if(videoSurface_->isActive()) {
    if(!videoSurface_->present(*videoFrame_)) {
      qDebug() << "Could not present QVideoFrame to QAbstractVideoSurface, error:" << videoSurface_->error();
    }
  }
}

void XpiderCamera::errorGet(int error_code) {
  emit cameraError(error_code);
  qDebug() << "Camera Error: " << error_code;
}

void XpiderCamera::connectionResultGet(int result_code) {
  if(result_code == 0) {
    is_opened_ = true;
  } else {
    is_opened_ = false;
  }

  emit connectionResult(result_code);
}
