import QtQuick 2.4
import QtMultimedia 5.5
import QtQuick.Controls 2.0

import "../components"

Page {
  property alias panel_fpv_color_bar_image: panel_fpv_color_bar_image
  property alias panel_fpv_info_text: panel_fpv_info_text
  property alias panel_fpv_distance_text: panel_fpv_distance_text
  property alias panel_fpv_imu_mousearea: panel_fpv_imu_mousearea
  property alias panel_fpv_info_mousearea: panel_fpv_info_mousearea
  property alias panel_fpv_camera_status_text: panel_fpv_camera_status_text
  property alias panel_fpv_joy: panel_fpv_joy
  property alias panel_fpv_color_button_image: panel_fpv_color_button_image
  property alias panel_fpv_color_button_mousearea: panel_fpv_color_button_mousearea
  property alias panel_fpv_led_image: panel_fpv_led_image
  property alias panel_fpv_sound_image: panel_fpv_sound_image
  property alias panel_fpv_face_image: panel_fpv_face_image
  property alias panel_fpv_led_mousearea: panel_fpv_led_mousearea
  property alias panel_fpv_sound_mousearea: panel_fpv_sound_mousearea
  property alias panel_fpv_face_mousearea: panel_fpv_face_mousearea
  property alias panel_fpv_frame: panel_fpv_frame

  id: page

  Image {
    id: panel_fpv_background_image
    anchors.fill: parent
    source: "qrc:/images/panel_fpv_background.png"
  }

  Image {
    id: panel_fpv_color_bar_image
    x: page.width * 0.725
    y: page.height * 0.040
    width: page.width * 0.271
    height: page.height * 0.073
    z: 2
    source: "qrc:/images/panel_fpv_color bar.png"
    opacity: 0.3

    Image {
      id: panel_fpv_color_button_image
      x: parent.width * 0.013
      y: parent.height * 0.571
      width: parent.width * 0.085
      height: parent.height * 0.532
      source: "qrc:/images/panel_fpv_color bar_button.png"
    }

    MouseArea {
      id: panel_fpv_color_button_mousearea
      enabled: false
      anchors.rightMargin: 0
      anchors.bottomMargin: 0
      anchors.leftMargin: 0
      anchors.topMargin: 0
      anchors.fill: parent
    }
  }

  Joy {
    id: panel_fpv_joy
    x: page.width * 0.031
    y: page.height * 0.556
    width: page.width * 0.938
    height: page.height * 0.417
    z: 2
  }

  Text {
    id: panel_fpv_camera_status_text
    x: page.width * 0.459
    y: page.height * 0.481
    z: 1
    width: page.width * 0.260
    height: page.height * 0.093
    color: app_window.colorA
    text: qsTr("Connecting...")
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.pointSize: 20
  }

  Image {
    id: panel_fpv_info_image
    x: page.width * 0.015
    y: page.height * 0.139
    width: page.width * 0.044
    height: page.height * 0.083
    z: 2
    source: "qrc:/images/panel_fpv_parameter_button.png"

    MouseArea {
      id: panel_fpv_info_mousearea
      anchors.fill: parent
    }
  }

  Image {
    id: panel_fpv_imu_image
    x: page.width * 0.015
    y: page.height * 0.222
    width: page.width * 0.044
    height: page.height * 0.083
    z: 2
    source: "qrc:/images/panel_fpv_navigation_button.png"

    MouseArea {
      id: panel_fpv_imu_mousearea
      anchors.fill: parent
    }
  }

  Text {
    id: panel_fpv_distance_text
    x: page.width * 0.058
    y: page.height * 0.240
    color: app_window.colorA
    text: qsTr("0.0v")
    z: 2
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.pointSize: 16
  }

  Text {
    id: panel_fpv_info_text
    x: page.width * 0.058
    y: page.height * 0.155
    color: app_window.colorA
    text: qsTr("0.0mm")
    z: 2
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.pointSize: 16
  }

  Text {
    id: panel_fpv_face_text
    x: page.width * 0.072
    y: page.height * 0.044
    width: page.width * 0.156
    height: page.height * 0.074
    color: app_window.colorA
    text: qsTr("FACE RECOGNIZE")
    z: 2
    textFormat: Text.StyledText
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.family: font_bebas_neue_bold.name
    font.pointSize: 22
  }

  Image {
    id: panel_fpv_face_image
    x: page.width * 0.229
    y: page.height * 0.040
    width: page.width * 0.061
    height: page.height * 0.073
    z: 2
    source: "qrc:/images/panel_fpv_switch_on.png"

    MouseArea {
      id: panel_fpv_face_mousearea
      anchors.fill: parent
    }
  }

  Text {
    id: panel_fpv_sound_text
    x: page.width * 0.289
    y: page.height * 0.044
    width: page.width * 0.156
    height: page.height * 0.073
    color: app_window.colorA
    text: qsTr("SOUND OUTPUT")
    z: 2
    textFormat: Text.RichText
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.family: font_bebas_neue_book.name
    font.pointSize: 22
  }

  Image {
    id: panel_fpv_sound_image
    x: page.width * 0.443
    y: page.height * 0.040
    width: page.width * 0.061
    height: page.height * 0.073
    z: 2
    source: "qrc:/images/panel_fpv_switch_off.png"

    MouseArea {
      id: panel_fpv_sound_mousearea
      anchors.fill: parent
    }
  }

  Text {
    id: panel_fpv_led_text
    x: page.width * 0.504
    y: page.height * 0.044
    width: page.width * 0.156
    height: page.height * 0.073
    color: app_window.colorA
    text: qsTr("INDICATOR LIGHT")
    z: 2
    styleColor: "#00000000"
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.family: font_bebas_neue_book.name
    font.pointSize: 22
  }

  Image {
    id: panel_fpv_led_image
    x: page.width * 0.661
    y: page.height * 0.040
    width: page.width * 0.061
    height: page.height * 0.073
    z: 2
    source: "qrc:/images/panel_fpv_switch_off.png"

    MouseArea {
      id: panel_fpv_led_mousearea
      anchors.fill: parent
    }
  }

  Image {
    id: panel_fpv_frame
    width: page.width * 0.156
    height: page.height * 0.278
    z:2
    source: "qrc:/images/panel_face_recognition_frame.png"
    visible: false
  }
}
