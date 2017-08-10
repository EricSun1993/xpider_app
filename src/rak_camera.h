#ifndef RAK_CAMERA_H_
#define RAK_CAMERA_H_

#include <QObject>
#include <QMutex>

#ifdef __cplusplus
extern "C" {
#endif
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libavutil/imgutils.h"
#ifdef __cplusplus
}
#endif

class RakCamera : public QObject {
  Q_OBJECT
public:
  explicit RakCamera(QObject *parent = 0);

  bool is_running() { return is_running_; }

  void Initialize(QMutex* mutex, std::string url);
  void stopCamera();

  bool start();

private:
  bool work_flag_;
  bool is_running_;
  bool initialized_;

  std::string url_;

  QMutex* mutex_;

  AVCodec *codec_;
  AVCodecContext* codec_context_;
  AVFormatContext* input_format_context_;

  int video_stream_index_;

  bool stop();

signals:
  void imageReady(uint8_t* data, uint8_t* data1, uint8_t* data2);
  void connectionResult(int result_code);
  void error(int error_code);

public slots:
  void doWork();
};

#endif // RAK_CAMERA_H_
