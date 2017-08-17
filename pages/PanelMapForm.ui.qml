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
  property alias xpider_image: xpider_image
  property alias destination_image: destination_image
  property alias stop_button_image: stop_button_image
  property alias xpider_arrow_image: xpider_arrow_image
  property alias stop_mousearea: stop_mousearea
  property alias destination_mousearea: destination_mousearea

  id: page

  Image {
    id: xpider_image
    width: page.width * 0.065
    height: page.height * 0.116
    scale: 1.4
    z: 3
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    source: "qrc:/images/heading.png"
  }

  Image {
    id: xpider_arrow_image
    x: parent.width * 0.487
    y: parent.height * 0.370
    width: parent.width * 0.026
    height: parent.height * 0.259
    visible: false
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    z: 3
    source: "qrc:/images/heading_arrow.png"
  }

  Image {
    id: destination_image
    width: parent.width * 0.104
    height: parent.height * 0.182
    z: 3
    visible: false
    source: "qrc:/images/panel_navigation_tag_icon.png"
  }

  MouseArea {
    id: destination_mousearea
    z: 2
    anchors.fill: parent
  }

  Image {
    id: stop_button_image
    x: parent.width * 0.448
    y: parent.height * 0.908
    z:3
    width: parent.width * 0.247
    height: parent.height * 0.245
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0
    source: "qrc:/images/map_stop.png"
  }

  MouseArea {
    id: stop_mousearea
    z: 5
    width: parent.width * 0.093
    height: parent.height * 0.106
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 0
    anchors.horizontalCenterOffset: 0
    anchors.horizontalCenter: parent.horizontalCenter
  }
}
