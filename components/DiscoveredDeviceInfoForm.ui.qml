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
  property alias component_ddi_mousearea: component_ddi_mousearea
  property alias component_ddi_text: component_ddi_text

    Image {
      id: component_ddi_image
      x: 11 * app_window.screen_scale
      y: 22 * app_window.screen_scale
      width: 96 * app_window.screen_scale
      height: 118 * app_window.screen_scale
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 0
      source: "qrc:/images/panel_map_radar_icon_xpider.png"
    }

    Text {
        id: component_ddi_text
        x: 11 * app_window.screen_scale
        y: 8 * app_window.screen_scale
        width: 162 * app_window.screen_scale
        height: 31 * app_window.screen_scale
        color: app_window.colorA
        text: qsTr("Unknown")
        font.bold: false
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: font_bebas_neue_regular.name
        font.pointSize: 12
    }

    MouseArea {
      id: component_ddi_mousearea
      anchors.fill: parent
    }
}
