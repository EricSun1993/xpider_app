# Xpider App
Xpider is the app for robot Xpider

Image

##License
Xpider App is under GPL V2(GNU General Public License version 2) license.

##Download
IOS: App Store(QRCODE)
Android: Developing...

##How to build Xpider APP

###Dependencies
Qt 5.7.0+
OpenCV 3 with contrib modules
FFMPEG

### Setup compile environment
####Get FFmpeg and OpenCV SDK for IOS/Android
1. You can build your own SDK
2. Download compiled SDK for both IOS and Android. here

####Set Qt project enivronment value

```bash
#if build for ios
FFMPEG_SDK={PATH_TO_FFMPEG_SDK_FOR_IOS}
OPENCV_SDK={PATH_TO_OPENCV_SDK_FOR_IOS}

#if build for android
FFMPEG_SDK={PATH_TO_FFMPEG_SDK_FOR_ANDROID}/arm
OPENCV_SDK={PATH_TO_OPENCV_SDK_FOR_ANDROID}/sdk
```

##Xpider network protocol
If you want control Xpider from your own program, you can use the following protocol
Protocol website

##Contact Us
To ask questions either file issues in github or send emails to ...