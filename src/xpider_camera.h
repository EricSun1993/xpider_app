#ifndef XPIDER_CAMERA_H_
#define XPIDER_CAMERA_H_

#include <QImage>
#include <QObject>
#include <QThread>
#include <QAbstractVideoSurface>
#include <QVideoSurfaceFormat>

#include "rak_camera.h"

#define IMAGE_WIDTH     1280
#define IMAGE_HEIGHT    720

class XpiderCamera : public QObject {
  Q_OBJECT
  Q_PROPERTY(QAbstractVideoSurface* videoSurface READ getVideoSurface WRITE setVideoSurface)

public:
  explicit XpiderCamera(QObject *parent = 0);
  ~XpiderCamera();

  QAbstractVideoSurface* getVideoSurface() const;
  void setVideoSurface(QAbstractVideoSurface* videoSurface);

  Q_INVOKABLE bool startVideo();
  Q_INVOKABLE bool stopVideo();

  Q_INVOKABLE bool is_opened() { return is_opened_; }

private:
  QMutex mutex_;
  QThread rak_thread_;
  RakCamera rak_camera_;

  QVideoFrame* videoFrame_;
  QAbstractVideoSurface* videoSurface_ = NULL;

  bool is_opened_;

signals:
  void startRakVideo();
  void connectionResult(int result_code);
  void cameraError(int error_code);

public slots:
  void imageReceived(uint8_t* data, uint8_t* data1, uint8_t* data2);
  void errorGet(int error_code);
  void connectionResultGet(int result_code);
};

#endif // XPIDER_CAMERA_H_
