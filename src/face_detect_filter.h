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
