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

import QtQuick 2.7
import QtQuick.Controls 2.0

import "../components"

Page {
  id: page
  property alias panel_scan_scan_line_image: panel_scan_scan_line_image
  property alias panel_scan_scan_circle1_image: panel_scan_scan_circle1_image
  property alias panel_scan_scan_circle2_image: panel_scan_scan_circle2_image
  property alias panel_scan_found_index_text: panel_scan_found_index_text
  property alias panel_scan_scan_circle3_image: panel_scan_scan_circle3_image
  property alias panel_scan_stop_image: panel_scan_stop_image
  property alias panel_scan_stop_mousearea: panel_scan_stop_mousearea
  property alias panel_scan_path_view: panel_scan_path_view
  property alias panel_scan_button_text: panel_scan_button_text

  Image {
    id: panel_scan_scan_line_image
    width: page.width
    height: page.width
    visible: false
    z: 1
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    source: "qrc:/images/panel_map_radar_scan_line.png"
  }

  Image {
    id: panel_scan_background_image
    opacity: 1
    anchors.fill: parent
    source: "qrc:/images/panel_scan_background.png"
  }

  Image {
    id: panel_scan_scan_circle1_image
    width: page.width
    height: page.width
    z: 1
    scale: 0.01
    opacity: 0
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    source: "qrc:/images/panel_map_radar_scan_circle.png"
  }

  Image {
    id: panel_scan_scan_circle2_image
    width: page.width
    height: page.width
    opacity: 0
    z: 1
    scale: 0.01
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: panel_scan_scan_circle1_image.verticalCenter
    source: "qrc:/images/panel_map_radar_scan_circle.png"
  }

  Image {
    id: panel_scan_scan_circle3_image
    width: page.width
    height: page.width
    opacity: 0
    z: 1
    scale: 0.01
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: panel_scan_scan_circle1_image.verticalCenter
    source: "qrc:/images/panel_map_radar_scan_circle.png"
  }

  Image {
    id: panel_scan_center_image
    width: parent.width * 0.07
    height: parent.width * 0.07
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    source: "qrc:/images/panel_scan_center.png"
  }

  Image {
    id: panel_scan_stop_image
    y: parent.width * 0.15
    width: parent.width * 0.14
    height: parent.width * 0.14
    anchors.bottom: panel_scan_center_image.bottom
    anchors.bottomMargin: page.height * 0.049
    z: 4
    anchors.horizontalCenterOffset: 0
    anchors.horizontalCenter: parent.horizontalCenter
    source: "qrc:/images/panel_scan_stop_unpressed.png"

    MouseArea {
      id: panel_scan_stop_mousearea
      anchors.fill: parent
      z: 4
    }

    Image {
      id: panel_scan_button_text
      width: page.width * 0.07
      height: page.height * 0.06
      anchors.bottom: parent.bottom
      anchors.bottomMargin: page.height * 0.073
      anchors.horizontalCenter: parent.horizontalCenter
      source: "qrc:/images/panel_scan_button_word_start.png"
    }

    //    Text {
    //        id: panel_scan_stop_text
    //        x: 85
    //        y: 140
    //        color: app_window.colorB
    //        text: qsTr("STOP")
    //        verticalAlignment: Text.AlignVCenter
    //        horizontalAlignment: Text.AlignHCenter
    //        font.family: font_bebas_neue_regular.name
    //        font.pointSize: 23
    //    }
  }

  Text {
    id: panel_scan_found_text
    x: page.width * 0.45
    y: page.height * 0.85
    width: page.width * 0.104
    height: page.height * 0.093
    color: app_window.colorA
    text: qsTr("FOUND")
    z: 2
    font.bold: false
    anchors.horizontalCenterOffset: 0
    anchors.horizontalCenter: parent.horizontalCenter
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.pixelSize: 40
    font.family: font_bebas_neue_regular.name
  }

  Text {
    id: panel_scan_found_index_text
    x: page.width * 0.448
    y: page.height * 0.741
    width: page.width * 0.078
    height: page.height * 0.120
    color: app_window.colorA
    text: qsTr("0")
    z: 2
    font.bold: true
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    anchors.horizontalCenterOffset: -5
    anchors.horizontalCenter: parent.horizontalCenter
    font.pixelSize: 80
    font.family: font_bebas_neue_regular.name
  }

  PathView {
    id: panel_scan_path_view
    z: 3
    anchors.fill: parent
    path: Path {
      startX: page.width * 0.630
      startY: page.height * 0.500
      PathArc {
        x: page.width * 0.370
        y: page.height * 0.500
        radiusX: page.width * 0.130
        radiusY: page.height * 0.231
      }

      PathArc {
        x: page.width * 0.734
        y: page.height * 0.500
        radiusX: page.width * 0.182
        radiusY: page.height * 0.787
      }

      PathArc {
        x: page.width * 0.5
        y: page.height * 0.083
        radiusX: page.width * 0.234
        radiusY: page.height * 0.417
        useLargeArc: true
      }
    }
  }
}
