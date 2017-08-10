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

#ifndef FACE_DETECT_FILTER_H
#define FACE_DETECT_FILTER_H

#include <QPointF>
#include <QList>
#include <QVariant>
#include <QVariantList>
#include <QAbstractVideoFilter>
#include <QVideoFilterRunnable>

#include <opencv2/opencv.hpp>
#include <opencv2/face.hpp>

#define FACE_DETECT_SCALE 4

class FaceDetectFilter;

class FaceDetectRunnable : public QVideoFilterRunnable {
public:
  static QString kStoragePath;

  FaceDetectRunnable(FaceDetectFilter* filter);

  void init();
  virtual QVideoFrame run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags);

  void SetRecognizeFlag(bool enable);
  void SetRequestImageFlag(int index);

  void CleanModel();
  void TrainFaceModel(QString face_name);

private:
  bool recognize_flag_;
  bool request_image_flag_;
  int face_sample_image_index_;

  QString storage_path_;

  FaceDetectFilter* filter_;

  std::vector<cv::Mat> face_sample_image_list_;
  cv::CascadeClassifier face_cascade_;

  bool face_recognize_available_;
  QStringList user_name_list_;
  std::string face_model_file_path_;
  cv::Ptr<cv::face::LBPHFaceRecognizer> face_model_;

  void SaveUserName();
  void LoadUserName();
};

class FaceDetectFilter : public QAbstractVideoFilter {
  Q_OBJECT
public:
  QVideoFilterRunnable* createFilterRunnable();

  Q_INVOKABLE void enableFaceRecognize(bool enable);
  Q_INVOKABLE void requestImage(int index);

  Q_INVOKABLE void cleanModel();
  Q_INVOKABLE void trainFaceModel(QString face_name);

private:
  FaceDetectRunnable* face_detect_runnable_;

signals:
  void finished(QVariantList face_list);
  void faceImageGet(int index, QImage image);
};

#endif // FACE_DETECT_FILTER_H
