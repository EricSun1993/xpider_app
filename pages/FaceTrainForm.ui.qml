import QtQuick 2.4
import QtMultimedia 5.5
import QtQuick.Controls 2.1

import "../components"

Page {
  property alias name: name
  property alias panel_face_recognition_forget_button: panel_face_recognition_forget_button
  property alias panel_face_recognition_undo_button: panel_face_recognition_undo_button
  property alias panel_face_recognition_next_button: panel_face_recognition_next_button
  property alias front_image: front_image
  property alias left_image: left_image
  property alias right_image: right_image
  property alias up_image: up_image
  property alias down_image: down_image
  property alias panel_face_frame: panel_face_frame

  id: page

  background: Rectangle {
    color: app_window.colorB
  }

  Text {
    id: name
    width: page.width * 0.208
    height: page.height * 0.037
    color: app_window.colorA
    text: qsTr("")
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignLeft
    styleColor: "#000000"
    anchors.left: parent.left
    anchors.leftMargin: page.width * 0.016
    anchors.top: parent.top
    anchors.topMargin: page.height * 0.139
    font.pointSize: 13
  }

  Grid {
    id: panel_face_recognition_grid
    x: page.width * 0.641
    y: page.height * 0.508
    width: page.width * 0.319
    height: page.height * 0.471
    z: 2
    rows: 3
    columns: 3

    Image {
      id: front_image
      cache: false
      width: parent.width * 0.318
      height: parent.height * 0.383
      z: 2
      source: "qrc:/images/panel_face_recognition_picture_normal.png"
    }

    Image {
      id: left_image
      cache: false
      width: parent.width * 0.318
      height: parent.height * 0.383
      z: 2
      source: "qrc:/images/panel_face_recognition_picture_normal.png"
    }

    Image {
      id: right_image
      cache: false
      width: parent.width * 0.318
      height: parent.height * 0.383
      z: 2
      source: "qrc:/images/panel_face_recognition_picture_normal.png"
    }

    Image {
      id: up_image
      cache: false
      width: parent.width * 0.318
      height: parent.height * 0.383
      z: 2
      source: "qrc:/images/panel_face_recognition_picture_normal.png"
    }

    Image {
      id: down_image
      cache: false
      width: parent.width * 0.318
      height: parent.height * 0.383
      z: 2
      source: "qrc:/images/panel_face_recognition_picture_normal.png"
    }

    Button {
      id: panel_face_recognition_next_button
      width: parent.width * 0.318
      height: parent.height * 0.383
      text: "0"

      background: Image {
        width: parent.width
        height: parent.height
        source: parent.down ? "qrc:/images/panel_face_recognition_button_click.png":
                              "qrc:/images/panel_face_recognition_button_normal.png"
      }
    }

    Button {
      id: panel_face_recognition_undo_button
      width: parent.width * 0.318
      height: parent.height * 0.183
      background: Image {
        width: parent.width
        height: parent.height
        source: parent.down ? "qrc:/images/panel_face_recognition_button_undo_click.png":
                              "qrc:/images/panel_face_recognition_button_undo_normal.png"
      }
    }

    Button {
      id: panel_face_recognition_forget_button
      width: parent.width * 0.318
      height: parent.height * 0.183
      background: Image {
        width: parent.width
        height: parent.height
        source: parent.down ? "qrc:/images/panel_face_recognition_button_forget_click.png":
                              "qrc:/images/panel_face_recognition_button_forget_normal.png"
      }
    }
  }

  Image {
    id: panel_face_recognition_icon1
    width: page.width * 0.026
    height: page.height * 0.357
    anchors.top: panel_face_recognition_grid.top
    anchors.topMargin: 0
    anchors.left: panel_face_recognition_grid.right
    anchors.leftMargin: page.width * 0.005
    source: "qrc:/images/panel_face_recognition_icon_.png"
  }

  Image {
      id: panel_face_frame
      width: page.width * 0.156
      height: page.height * 0.278
      z:2
      visible: false
      source: "qrc:/images/panel_face_recognition_frame.png"
  }
}
