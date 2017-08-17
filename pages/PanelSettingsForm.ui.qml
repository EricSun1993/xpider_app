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
import QtQuick.Controls 2.0

import "../components"

Page {
  property alias panel_settings_reset_button: panel_settings_reset_button
  property alias panel_settings_complete_button: panel_settings_complete_button
  property alias panel_settings_name_input: panel_settings_name_input
  property alias panel_settings_version_value: panel_settings_version_value
  property alias panel_settings_firmware_value: panel_settings_firmware_value
  property alias panel_settings_uuid_value: panel_settings_uuid_value
  property alias panel_settings_firmware_row: panel_settings_firmware_row

  id: page

  Rectangle {
    id: panel_settings_background
    color: app_window.colorB
    anchors.fill: parent
  }

  Image {
    id: panel_settings_logo_image
    width: parent.width * 0.165
    height: parent.height * 0.293
    anchors.top: parent.top
    anchors.topMargin: parent.height * 0.074
    anchors.horizontalCenter: parent.horizontalCenter
    source: "qrc:/images/panel_settings_logo.png.png"
  }

  Row {
    id: panel_settings_button_row
    width: parent.width * 0.538
    spacing: parent.width * 0.182
    anchors.bottom: parent.bottom
    anchors.bottomMargin: parent.height * 0.04
    anchors.horizontalCenter: parent.horizontalCenter

    Button {
      id: panel_settings_reset_button
      width: page.width * 0.178
      height: page.height * 0.144

      background: Image {
        width: parent.width
        height: parent.height
        source: parent.down ? "qrc:/images/panel_settings_button_reset_open.png":
                              "qrc:/images/panel_settings_button_reset_close.png"
      }
    }

    Button {
      id: panel_settings_complete_button
      width: page.width * 0.178
      height: page.height * 0.144

      background: Image {
        width: parent.width
        height: parent.height
        source: parent.down ? "qrc:/images/panel_settings_button_complete_open.png":
                              "qrc:/images/panel_settings_button_complete_close.png"
      }
    }
  }

  Column {
    id: panel_settings_column
    x: parent.width * 0.229
    y: parent.height * 0.391
    width: parent.width * 0.402
    height: parent.height * 0.404
    spacing: height * 0.018
    anchors.horizontalCenterOffset: 0
    anchors.horizontalCenter: parent.horizontalCenter

    Row {
      id: panel_settings_name_row
      height: parent.height * 0.238
      anchors.right: parent.right
      anchors.rightMargin: 0
      anchors.left: parent.left
      anchors.leftMargin: 0
      spacing: 0

      Text {
        id: panel_settings_name_title
        width: parent.width * 0.324
        color: app_window.colorA
        text: qsTr("NAME:")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 20
        font.family: font_bebas_neue_regular.name
      }

      TextField {
        id: panel_settings_name_input
        text: qsTr("LOADING...")
        maximumLength: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        color: app_window.colorA
        font.pointSize: 16

        /* 正则表达式：字符A~Z，a~z, 0~9和下划线组成的最长7位的字符串 */
        validator: RegExpValidator {regExp: /^[A-Za-z0-9_]{1,20}$/}

        background: Image {
          width: parent.width * 0.35
          height: parent.height
          x: -parent.width * 0.02
          source: "qrc:/images/panel_settings_frame.png"
        }
      }

    }

    Row {
      id: panel_settings_uuid_row
      height: parent.height * 0.238
      spacing: 0
      anchors.right: parent.right
      anchors.rightMargin: 0
      anchors.left: parent.left
      anchors.leftMargin: 0

      Text {
        id: panel_settings_uuid_title
        width: parent.width * 0.324
        color: app_window.colorA
        text: qsTr("UUID:")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 20
        font.family: font_bebas_neue_regular.name
      }

      TextField {
        id: panel_settings_uuid_value
        text: qsTr("LOADING...")
        opacity: 0.9
        readOnly : true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        color: app_window.colorA
        font.pointSize: 16

        background: Image {
          width: parent.width * 0.35
          height: parent.height
          x: -parent.width * 0.02
          source: "qrc:/images/panel_settings_frame.png"
        }
      }
    }

    Row {
      id: panel_settings_version_row
      height: parent.height * 0.238
      spacing: 0
      anchors.right: parent.right
      anchors.rightMargin: 0
      anchors.left: parent.left
      anchors.leftMargin: 0

      Text {
        id: panel_settings_version_title
        width: parent.width * 0.324
        color: app_window.colorA
        text: qsTr("VERSION:")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 20
        font.family: font_bebas_neue_regular.name
      }

      TextField {
        id: panel_settings_version_value
        placeholderText: "LOADNG..."
        opacity: 1
        readOnly : true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        color: app_window.colorA
        font.pointSize: 16

        background: Image {
          width: parent.width * 0.35
          height: parent.height
          x: -parent.width * 0.02
          source: "qrc:/images/panel_settings_frame.png"
        }
      }
    }


    Row {
      id: panel_settings_firmware_row
      height: parent.height * 0.238
      spacing: 0
      anchors.right: parent.right
      anchors.rightMargin: 0
      anchors.left: parent.left
      anchors.leftMargin: 0

      Text {
        id: panel_settings_firmware_title
        width: parent.width * 0.324
        color: app_window.colorA
        text: qsTr("FIRMWARE:")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 20
        font.family: font_bebas_neue_regular.name
      }

      TextField {
        id: panel_settings_firmware_value
        text: qsTr("LOADING...")
        readOnly : true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        color: app_window.colorA
        font.pointSize: 16

        background: Image {
          width: parent.width * 0.35
          height: parent.height
          x: -parent.width * 0.02
          source: "qrc:/images/panel_settings_frame.png"
        }
      }
    }
  }
}
