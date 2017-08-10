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

#include "face_detect_filter.h"

#include <QFile>
#include <QDebug>
#include <QThread>

#include <QQmlApplicationEngine>

FaceDetectRunnable::FaceDetectRunnable(FaceDetectFilter* filter) {
  filter_ = filter;
  recognize_flag_ = true;
  request_image_flag_ = false;
  face_recognize_available_ = false;
  face_sample_image_index_ = 0;

  face_sample_image_list_.resize(5);
  for(int i=0; i<5; i++) {
     face_sample_image_list_[i].create(100, 100, CV_8UC3);
  }

  init();
}

void FaceDetectRunnable::init() {
  QQmlApplicationEngine engine;
  storage_path_ = engine.offlineStoragePath();

  face_model_ = cv::face::createLBPHFaceRecognizer();
  QFile face_model_fileA(storage_path_ + "/faceRecognition.xml");
  QString full_path = storage_path_ + "/faceRecognition.xml";
  face_model_file_path_ = full_path.toStdString();
  if(face_model_fileA.exists()){
    face_model_->load(face_model_file_path_);
    face_recognize_available_ = true;
  } else {
    qDebug() << "face recognition file load failed";
  }

  QFile face_model_fileB(storage_path_ + "/haarcascade_frontalface_alt2.xml");
  if(!face_model_fileB.exists()) {
    QFile file(":face/haarcascade_frontalface_alt2.xml");
    file.copy(face_model_fileB.fileName());
  }
  if(!face_cascade_.load(face_model_fileB.fileName().toStdString())) {
    qDebug() << "haarcascade_frontalface_alt2 load failed";
  } else {
    qDebug() << "haarcascade_frontalface_alt2 loaded";
  }

  LoadUserName();
}

QVideoFrame FaceDetectRunnable::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags) {
  Q_UNUSED(flags);
  Q_UNUSED(surfaceFormat);

  //TODO: fix unused value define

  cv::Mat raw_image(input->height()*3/2, input->width(), CV_8UC1, input->bits());
  cv::Mat rgb_image, gray_image, eqhist_image;
  std::vector<cv::Rect> face_list;

  cv::cvtColor(raw_image, rgb_image, cv::COLOR_YUV420p2BGR);
  cv::cvtColor(raw_image, gray_image, cv::COLOR_YUV420p2GRAY);
  // cv::flip(rgb_image, rgb_image, -1);
  // cv::flip(gray_image, gray_image, -1);

  cv::equalizeHist(gray_image, eqhist_image);
  cv::resize(eqhist_image, eqhist_image, cv::Size(eqhist_image.cols/FACE_DETECT_SCALE, eqhist_image.rows/FACE_DETECT_SCALE));
  face_cascade_.detectMultiScale(eqhist_image, face_list, 1.3, 3, 0, cv::Size(30, 30));

  if(face_list.size() != 0) {
    int face_max_index = 0;
    QVariantList face_qlist;
    for(uint16_t i=0; i<face_list.size(); i++) {
      if(face_list[i].area() > face_list[face_max_index].area()) {
        face_max_index = i;
      }
      face_qlist.push_back(QVariant::fromValue(QRect(face_list[i].x*FACE_DETECT_SCALE,face_list[i].y*FACE_DETECT_SCALE,
                                                     face_list[i].width*FACE_DETECT_SCALE, face_list[i].height*FACE_DETECT_SCALE)));
    }

    if(request_image_flag_ == true) {
      cv::Rect rect(face_list[face_max_index].x*FACE_DETECT_SCALE,
                    face_list[face_max_index].y*FACE_DETECT_SCALE,
                    face_list[face_max_index].width*FACE_DETECT_SCALE,
                    face_list[face_max_index].height*FACE_DETECT_SCALE);
      cv::resize(rgb_image(rect), face_sample_image_list_[face_sample_image_index_], cv::Size(100, 100));
      emit filter_->faceImageGet(face_sample_image_index_, QImage(face_sample_image_list_[face_sample_image_index_].data,
                                                                  100,
                                                                  100,
                                                                  QImage::Format_RGB888));
      request_image_flag_ = false;
    }

    QString face_name = "Unkown";
    if(recognize_flag_==true && user_name_list_.size()!=0 && face_recognize_available_) {
      cv::Mat temp_face;
      cv::resize(eqhist_image(face_list[face_max_index]), temp_face, cv::Size(100, 100));
      int face_index = face_model_->predict(temp_face);
      
      face_name = user_name_list_[face_index];
      qDebug() << "Recognize: " << face_name << ", " << face_index;
      
      cv::putText(rgb_image,
                  face_name.toStdString(),
                  cv::Point(face_list[face_max_index].x*FACE_DETECT_SCALE,
                            face_list[face_max_index].y*FACE_DETECT_SCALE-20),
                  cv::FONT_HERSHEY_PLAIN,
                  3,
                  cv::Scalar(0, 255, 0),
                  3,
                  cv::LineTypes::LINE_AA);
    }
    
    cv::Rect face_rect(face_list[face_max_index].x*FACE_DETECT_SCALE,
                       face_list[face_max_index].y*FACE_DETECT_SCALE,
                       face_list[face_max_index].width*FACE_DETECT_SCALE,
                       face_list[face_max_index].height*FACE_DETECT_SCALE);
    
    cv::rectangle(rgb_image, face_rect, CvScalar(0, 255, 0), 4, cv::LINE_AA, 0);

    emit filter_->finished(face_qlist);
  }

  // cause the data struct difference between qvideoframe and mat
  // we use rgb2420p, though the rgb_image is bgr type
  // cv::flip(rgb_image, rgb_image, -1);
  cv::cvtColor(rgb_image, raw_image, cv::COLOR_RGB2YUV_I420);

  return *input;
}

void FaceDetectRunnable::SaveUserName() {
  QFile file(storage_path_ + "/userName.dat");
  if(!file.open(QIODevice::WriteOnly | QIODevice::Text)){
    qDebug()<<"Save face recognize data faild!";
    return;
  }
  QTextStream out(&file);
  QString item;
  foreach(item,user_name_list_)
    out<<item<<",";
  file.close();
}

void FaceDetectRunnable::LoadUserName(){
  QFile file(storage_path_ + "/userName.dat");
  if(!file.exists() || !file.open(QIODevice::ReadOnly | QIODevice::Text)){
    qDebug()<<"Load face recognize data faild!";
    return;
  }
  QTextStream in(&file);
  QString temp;
  temp = in.readAll();
  user_name_list_ = temp.split(",");
  file.close();
}

QVideoFilterRunnable* FaceDetectFilter::createFilterRunnable() {
  if(face_detect_runnable_ == NULL) {
    face_detect_runnable_ = new FaceDetectRunnable(this);
  }

  return reinterpret_cast<QVideoFilterRunnable*>(face_detect_runnable_);
}

void FaceDetectRunnable::SetRequestImageFlag(int index) {
  request_image_flag_ = true;
  face_sample_image_index_ = index;
}

void FaceDetectRunnable::SetRecognizeFlag(bool enable) {
  qDebug() << "set recog flag: " << enable;
  recognize_flag_ = enable;
}

void FaceDetectRunnable::TrainFaceModel(QString face_name) {
  user_name_list_ << face_name;
  int index = user_name_list_.size() - 1;
  
  qDebug() << "Train: " << face_name << ", " << index;

  std::vector<int> index_list(5);
  for(int i=0; i<5; i++) {
    index_list[i] = index;
    cv::cvtColor(face_sample_image_list_[i], face_sample_image_list_[i], cv::COLOR_BGR2GRAY);
  }
  if(index == 0) {
    face_model_->train(face_sample_image_list_, index_list);
  } else {
    face_model_->update(face_sample_image_list_, index_list);
  }
  face_model_->save(face_model_file_path_);
  face_recognize_available_ = true;
  SaveUserName();
}

void FaceDetectRunnable::CleanModel() {
  QFile face_model_fileA(storage_path_ + "/faceRecognition.xml");
  if(face_model_fileA.exists()){
    qDebug("Face file removed: %d", face_model_fileA.remove());
  }

  user_name_list_.clear();
  face_recognize_available_ = false;
  SaveUserName();
}

void FaceDetectFilter::requestImage(int index) {
  face_detect_runnable_->SetRequestImageFlag(index);
}

void FaceDetectFilter::trainFaceModel(QString face_name) {
  face_detect_runnable_->TrainFaceModel(face_name);
}

void FaceDetectFilter::cleanModel() {
  face_detect_runnable_->CleanModel();
}

void FaceDetectFilter::enableFaceRecognize(bool enable) {
  face_detect_runnable_->SetRecognizeFlag(enable);
}
