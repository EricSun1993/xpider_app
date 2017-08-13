TEMPLATE = app

QT += core qml quick bluetooth network multimedia

CONFIG += c++11 console

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
  qml.qrc \
  resources.qrc

HEADERS += \
  src/rak_camera.h \
  src/linked_list.h \
  src/neuronengine.h \
  src/grid_map.h \
  src/grid_map_layer.h \
  src/grid_map_common.h \
  src/xpider_info.h \
  src/xpider_camera.h \
  src/xpider_center.h \
  src/xpider_protocol.h \
  src/linked_list.h \
  src/face_provider.h \
  src/face_detect_filter.h \
  src/hdlc_qt.h \
  src/xpider_comm.h \
  src/arduino_log.h \
  src/xpider_wifi.h

SOURCES += \
  main.cpp \
  src/rak_camera.cpp \
  src/neuronengine.cpp \
  src/grid_map.cpp \
  src/grid_map_layer.cpp \
  src/xpider_info.cpp \
  src/xpider_camera.cpp \
  src/xpider_center.cpp \
  src/xpider_protocol.cpp \
  src/face_provider.cpp \
  src/face_detect_filter.cpp \
  src/hdlc_qt.cpp \
  src/xpider_comm.cpp \
  src/xpider_wifi.cpp

LIBS += \
  -lz \
  -lavformat \
  -lavcodec \
  -lavutil \
  -lswscale \
  -lswresample

android {
  message(build on android)

  QT += androidextras

  DISTFILES += \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle \
    android/res/drawable/splash.xml \
    android/res/values/apptheme.xml

  ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

  INCLUDEPATH += \
    $$(FFMPEG_SDK)/include \
    $$(OPENCV_SDK)/native/jni/include

  LIBS += \
    -L$$(FFMPEG_SDK)/lib \
    -L$$(OPENCV_SDK)/native/libs/$$ANDROID_TARGET_ARCH \
    -L$$(OPENCV_SDK)/native/3rdparty/libs/$$ANDROID_TARGET_ARCH \
    -lopencv_ml \
    -lopencv_objdetect \
    -lopencv_calib3d \
    -lopencv_video \
    -lopencv_features2d \
    -lopencv_highgui \
    -lopencv_flann \
    -lopencv_imgproc \
    -lopencv_core \
    -lopencv_imgcodecs \
    -lopencv_photo \
    -lopencv_shape \
    -lopencv_stitching \
    -lopencv_superres \
    -lopencv_videoio \
    -lopencv_videostab \
    -lopencv_face \
    -llibjpeg \
    -llibpng \
    -llibtiff \
    -llibjasper \
    -ltbb \
    -lIlmImf \
    -llibwebp \
    -ltegra_hal

  ANDROID_EXTRA_LIBS = $$(OPENCV_SDK)/native/libs/$$ANDROID_TARGET_ARCH/libopencv_java3.so
}

ios{
  message(build on ios)

  QMAKE_INFO_PLIST = ios/Info.plist

  assets_catalogs.files = $$files($$PWD/ios/*.xcassets)
  app_launch_images.files = $$PWD/ios/Launch.storyboard

  INCLUDEPATH += \
    $$(FFMPEG_SDK)/include \
    $$(OPENCV_SDK)/include

  LIBS += \
    -L$$(FFMPEG_SDK)/lib \
    -F$$(OPENCV_SDK) \
    -lbz2 \
    -liconv \
    -framework opencv2 \
    -framework VideoToolbox

  QMAKE_BUNDLE_DATA += \
    assets_catalogs \
    app_launch_images
}
