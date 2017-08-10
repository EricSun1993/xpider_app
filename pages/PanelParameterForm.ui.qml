import QtQuick 2.4
import QtQuick.Controls 2.0

import "../components"

Page {
  property alias panel_param_sound_flow: panel_param_sound_flow
  property alias panel_param_distance_value: panel_param_distance_value
  property alias panel_param_distance_pointer: panel_param_distance_pointer

  id: page

  Rectangle {
    id: panel_parameter_background
    color: app_window.colorB
    anchors.fill: parent
    z: 0
  }

  Column {
    id: column1
    x: parent.width * 0.059
    y: parent.height * 0.719
    spacing: parent.height * 0.028

    Row {
      id: panel_param_distance_row
      spacing: 30 * app_window.screen_scale

      Text {
        id: panel_param_distance_text
        width: page.width * 0.093
        height: page.height * 0.087
        color: app_window.colorA
        text: qsTr("DISTANCE")
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 15
        font.family: font_bebas_neue_regular.name
      }

      Image {
        id: image1
        width: 93 * app_window.screen_scale
        height: 84 * app_window.screen_scale
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/images/panel_parameter_distance_icon.png"
      }

      Item {
        id: panel_param_distance_item
        width: 155 * app_window.screen_scale
        height: 94 * app_window.screen_scale

        Image {
          id: panel_param_distance_tbackground
          width: 155 * app_window.screen_scale
          height: 91 * app_window.screen_scale
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          source: "qrc:/images/panel_parameter_distance_frame.png"
        }

        Text {
          id: panel_param_distance_value
          color: app_window.colorB
          text: qsTr("INVAILD")
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font.pointSize: 15
          font.family: font_bebas_neue_regular.name
        }
      }

      Image {
        id: panel_param_distance_bar
        width: 1077 * app_window.screen_scale
        height: 94 * app_window.screen_scale
        source: "qrc:/images/panel_parameter_distance_progress_bar.png"

        Image {
          id: panel_param_distance_pointer
          width: 62 * app_window.screen_scale
          height: 126 * app_window.screen_scale
          anchors.bottom: parent.bottom
          anchors.bottomMargin: 0
          source: "qrc:/images/panel_parameter_distance_arrow.png"
        }
      }

    }

    Row {
      id: panel_param_sound_row
      spacing: 20 * app_window.screen_scale

      Text {
        id: panel_param_sound_text
        width: page.width * 0.063
        height: page.height * 0.087
        color: app_window.colorA
        text: qsTr("SOUND")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 15
        font.family: font_bebas_neue_regular.name
      }

      Item {
        id: panel_param_sound_item
        width: 155 * app_window.screen_scale
        height: 94 * app_window.screen_scale

        Image {
          id: panel_param_sound_background
          width: 150 * app_window.screen_scale
          height: 79 * app_window.screen_scale
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          anchors.top: parent.top
          fillMode: Image.Stretch
          source: "qrc:/images/panel_parameter_sound_frame.png"
        }

        Text {
          id: panel_param_sound_value
          color: app_window.colorB
          text: qsTr("0dB")
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          horizontalAlignment: Text.AlignCenter
          verticalAlignment: Text.AlignVCenter
          font.pointSize: 13
          font.family: font_bebas_neue_regular.name
        }
      }

      SoundFlow {
        id: panel_param_sound_flow
        width: page.width * 0.6
        height: page.height * 0.087
      }
    }
  }

  StepChart {
    id: panel_param_motion_chart
    x: parent.width * 0.075
    y: parent.height * 0.239
    width: parent.width * 0.885
    height: parent.height * 0.380
    anchors.horizontalCenter: parent.horizontalCenter
    z: 4
  }

  Text {
    id: panel_param_motion_data
    x: parent.width * 0.759
    y: parent.height * 0.121
    color: app_window.colorA
    text: qsTr("SPORT DATA: 1000")
    opacity: 0.6
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
    font.pointSize: 10
    font.family: font_bebas_neue_regular.name
  }

  Text {
    id: panel_param_motion_title
    x: parent.width * 0.090
    y: parent.height * 0.098
    color: app_window.colorA
    text: qsTr("MOTION SENSING DATA")
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
    font.pointSize: 20
    font.family: font_bebas_neue_regular.name
  }
}
