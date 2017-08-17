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

Item {
  property alias commponent_joy1_down_image: commponent_joy1_down_image
  property alias commponent_joy1_up_image: commponent_joy1_up_image
  property alias component_joy1_move_image: component_joy1_move_image
  property alias component_joy1_button_image: component_joy1_button_image
  property alias component_joy2_normal_image: component_joy2_normal_image
  property alias component_joy1_normal_image: component_joy1_normal_image
  property alias component_joy_mousearea: component_joy_mousearea
  property alias commponent_joy2_right_image: commponent_joy2_right_image
  property alias commponent_joy2_left_image: commponent_joy2_left_image
  property alias commponent_joy2_down_image: commponent_joy2_down_image
  property alias commponent_joy2_up_image: commponent_joy2_up_image
  property alias component_joy2_button_image: component_joy2_button_image
  property alias component_joy2_move_image: component_joy2_move_image

  id: joy_self

  MultiPointTouchArea {
    id: component_joy_mousearea
    anchors.fill: parent

    touchPoints: [
      TouchPoint { id: point1 },
      TouchPoint { id: point2 }
    ]
  }
  Image {
    id: component_joy1_normal_image
    x: joy_self.width * 0.067
    y: joy_self.height * 0.213
    width: joy_self.width * 0.144
    height: joy_self.height * 0.578
    anchors.verticalCenterOffset: 0
    anchors.horizontalCenterOffset: -joy_self.width * 0.35
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    source: "qrc:/images/panel_fpv_circle_normal.png"
  }
  Image {
      id: component_joy1_move_image
      x: -1
      y: -1
      width: joy_self.width * 0.191
      height: joy_self.height * 0.753
      opacity: 0.3
      anchors.horizontalCenter: component_joy1_normal_image.horizontalCenter
      anchors.verticalCenter: component_joy1_normal_image.verticalCenter
      source: "qrc:/images/panel_fpv_circle_movement.png"
  }
  Image {
    id: component_joy1_button_image
    x: joy_self.width * 0.119
    y: joy_self.height * 0.367
    width: joy_self.width * 0.062
    height: joy_self.height * 0.267
    source: "qrc:/images/panel_fpv_button.png"
  }
  Image {
    id: commponent_joy1_up_image
    x: joy_self.width * 0.113
    y: joy_self.height * 0.018
    width: joy_self.width * 0.038
    height: joy_self.height * 0.093
    anchors.verticalCenterOffset: -joy_self.height * 0.4
    anchors.verticalCenter: component_joy1_normal_image.verticalCenter
    anchors.horizontalCenter: component_joy1_normal_image.horizontalCenter
    source: "qrc:/images/panel_fpv_arrow.png"
  }
  Image {
    id: commponent_joy1_down_image
    x: joy_self.width * 0.113
    y: joy_self.height * 0.836
    width: joy_self.width * 0.038
    height: joy_self.height * 0.093
    anchors.verticalCenterOffset: joy_self.height * 0.4
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenterOffset: 0
    anchors.horizontalCenter: component_joy1_normal_image.horizontalCenter
    rotation: 180
    source: "qrc:/images/panel_fpv_arrow.png"
  }
  Image {
    id: component_joy2_normal_image
    width: joy_self.width * 0.144
    height: joy_self.height * 0.578
    anchors.verticalCenterOffset: 0
    anchors.horizontalCenterOffset: joy_self.width * 0.35
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    source: "qrc:/images/panel_fpv_circle_normal.png"
  }
  Image {
    id: component_joy2_move_image
    width: joy_self.width * 0.191
    height: joy_self.height * 0.753
    opacity: 0.3
    anchors.verticalCenterOffset: 0
    anchors.horizontalCenterOffset: 0
    anchors.horizontalCenter: component_joy2_normal_image.horizontalCenter
    anchors.verticalCenter: component_joy2_normal_image.verticalCenter
    source: "qrc:/images/panel_fpv_circle_movement.png"
  }
  Image {
    id: component_joy2_button_image
    x: joy_self.width * 0.819
    y: joy_self.height * 0.367
    width: joy_self.width * 0.062
    height: joy_self.height * 0.267
    source: "qrc:/images/panel_fpv_button.png"
  }
  Image {
    id: commponent_joy2_up_image
    x: joy_self.width * 0.682
    y: joy_self.height * 0.018
    width: joy_self.width * 0.038
    height: joy_self.height * 0.093
    anchors.verticalCenterOffset: -joy_self.height * 0.4
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: component_joy2_normal_image.horizontalCenter
    source: "qrc:/images/panel_fpv_arrow.png"
  }
  Image {
    id: commponent_joy2_down_image
    x: joy_self.width * 0.682
    y: joy_self.height * 0.018
    width: joy_self.width * 0.038
    height: joy_self.height * 0.093
    anchors.verticalCenterOffset: joy_self.height * 0.4
    anchors.verticalCenter: component_joy2_normal_image.verticalCenter
    anchors.horizontalCenter: component_joy2_normal_image.horizontalCenter
    rotation: 180
    source: "qrc:/images/panel_fpv_arrow.png"
  }
  Image {
    id: commponent_joy2_left_image
    x: joy_self.width * 0.578
    y: joy_self.height * 0.431
    width: joy_self.width * 0.038
    height: joy_self.height * 0.093
    anchors.verticalCenter: component_joy2_normal_image.verticalCenter
    anchors.horizontalCenterOffset: -joy_self.width * 0.1
    anchors.horizontalCenter: component_joy2_normal_image.horizontalCenter
    rotation: 270
    source: "qrc:/images/panel_fpv_arrow.png"
  }
  Image {
    id: commponent_joy2_right_image
    x: joy_self.width * 0.788
    y: joy_self.height * 0.429
    width: joy_self.width * 0.038
    height: joy_self.height * 0.093
    anchors.horizontalCenterOffset: joy_self.width * 0.1
    anchors.horizontalCenter: component_joy2_normal_image.horizontalCenter
    anchors.verticalCenterOffset: 0
    anchors.verticalCenter: component_joy2_normal_image.verticalCenter
    rotation: 90
    scale: 1
    source: "qrc:/images/panel_fpv_arrow.png"
  }
}
