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

import QtQuick 2.4
import QtMultimedia 5.5
import QtQuick.Controls 2.1

import Xpider 1.0
import "../components"

FaceTrainForm {
  property bool video_status: false
  property real face_train_step: 0
  property real video_scale: width / 1280

  XCamera {
    id: panel_face_camera
  }

  VideoOutput {
    id: fanel_face_videooutput
    z: 1
    anchors.fill: parent
    source: panel_face_camera
    // rotation: 180;
    filters: [panel_face_face_detect_filter]
  }

  FaceDetectFilter {
    id: panel_face_face_detect_filter

    onFaceImageGet: {
      face_provider.updateImage(index, image);
      switch(index){
      case 0:
        panel_face_recognition_next_button.text = "1";
        front_image.source = "image://face_provider/0";
        break;
      case 1:
        panel_face_recognition_next_button.text = "2";
        left_image.source = "image://face_provider/1";
        break;
      case 2:
        panel_face_recognition_next_button.text = "3";
        right_image.source = "image://face_provider/2";
        break;
      case 3:
        panel_face_recognition_next_button.text = "4";
        up_image.source = "image://face_provider/3";
        break;
      case 4:
        panel_face_recognition_next_button.text = "train";
        down_image.source = "image://face_provider/4";
        break;
      default:break;
      }
      face_train_step = face_train_step + 1;
    }
  }
  
  XDialog {
    id: input_dialog
    closePolicy: Popup.NoAutoClose

    Text {
      id: input_dialog_title
      x: parent.width * 0.05
      y: parent.height * 0.12

      text: "Please input name:"
      color: app_window.colorA
      font.pointSize: 19
      font.family: font_bebas_neue_bold.name
    }

    TextField {
      id: input_dialog_input
      focus: true
      anchors.centerIn: parent
      width: parent.width * 0.5

      placeholderText: "Input Here"
      color: app_window.colorA
      font.pointSize: 17
      // font.family: font_bebas_neue_book.name
      horizontalAlignment: Text.AlignHCenter

      /* 正则表达式：字符A~Z，a~z, 0~9和下划线组成的最长7位的字符串 */
       validator: RegExpValidator {regExp: /^[A-Za-z0-9_]{1,7}$/}

      background: Rectangle {
        opacity: 0
      }
    }

    Button {
      id: input_dialog_ok
      width: parent.width / 3
      height: parent.height / 4
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.horizontalCenterOffset: parent.width * (-0.25)
      anchors.bottom: parent.bottom
      anchors.bottomMargin: parent.height * 0.1

      background: Image {
        anchors.fill: parent
        source: parent.down ? "qrc:/images/panel_face_recognition_button_ok_click.png":
                              "qrc:/images/panel_face_recognition_button_ok_normal.png"
      }

      onClicked: {
        panel_face_face_detect_filter.trainFaceModel(input_dialog_input.text);
        front_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
        left_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
        right_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
        up_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
        down_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
        panel_face_recognition_next_button.text = "1";
        input_dialog.close();
        face_train_step = 0;
      }
    }

    Button {
      id: input_dialog_cancel
      width: parent.width / 3
      height: parent.height / 4
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.horizontalCenterOffset: parent.width * 0.25
      anchors.bottom: parent.bottom
      anchors.bottomMargin: parent.height * 0.1

      background: Image {
        anchors.fill: parent
        source: parent.down ? "qrc:/images/panel_face_recognition_button_cancel_click.png":
                              "qrc:/images/panel_face_recognition_button_cancel_normal.png"
      }

      onClicked: {
        input_dialog.close();
      }
    }
  }

  Text {
    id: video_status_message
    x: 878
    y: 423
    color: app_window.colorA
    text: qsTr("Connecting...")
    z: 1
    font.bold: true
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.pointSize: 20
  }

  panel_face_recognition_next_button.onClicked: {
    if(face_train_step === 5) {
      input_dialog.open();
    } else {
      panel_face_face_detect_filter.requestImage(face_train_step);
    }
  }

  panel_face_recognition_undo_button.onClicked: {
    switch(face_train_step) {
    case 1:
      panel_face_recognition_next_button.text = "0";
      front_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
      break;
    case 2:
      panel_face_recognition_next_button.text = "1";
      left_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
      break;
    case 3:
      panel_face_recognition_next_button.text = "2";
      right_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
      break;
    case 4:
      panel_face_recognition_next_button.text = "3";
      up_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
      break;
    case 5:
      panel_face_recognition_next_button.text = "4";
      down_image.source = "qrc:/images/panel_face_recognition_picture_normal.png";
      break;
    default:
      break;
    }
    if(face_train_step > 0) {
      face_train_step = face_train_step - 1;
    }
  }

  panel_face_recognition_forget_button.onClicked: {
    panel_face_face_detect_filter.cleanModel();
  }

  Connections {
    target: xpider_center

    onDeviceConnected: {
      if(panel_face_camera.is_opened() === false) {
        panel_face_camera.startVideo()
        video_status_message.text = "Connecting..."
      }
    }

    onDeviceDisconnected: {
//      if(panel_face_camera.is_opened() === true) {
//        panel_face_camera.stopVideo()
//        video_status_message.text = "Please check wifi and xpider power status"
//      }
    }
  }

  Timer {
    id: start_timer
    interval: 1000
    repeat: false

    onTriggered: {
      video_status = panel_face_camera.startVideo();
      switch(video_status) {
      case false:
        console.debug("rakVideo: Device not Found");
        video_status_message.text = "Device not Found\n";
        video_status_message.visible = true;
        break;
      case true:
      default:
        console.debug("rakVideo: Connect Success!");
        fanel_face_videooutput.visible = true;
        video_status_message.visible = false;
      }
    }
  }

  Component.onCompleted: {
    if(xpider_enable === true) {
      start_timer.start();
    } else {
      video_status_message.visible = true;
      video_status_message.text = "Please check wifi and xpider power status"
    }
  }

  Component.onDestruction: {
    if(panel_face_camera.is_opened() === true) {
      panel_face_camera.stopVideo();
    }
    video_status = false;
  }
}

