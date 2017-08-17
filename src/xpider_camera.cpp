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
