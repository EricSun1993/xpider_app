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
import QtQuick.Controls 2.1

Item {
  property alias panel_neural_learned_text: panel_neural_learned_text
  property alias panel_neural_learn_button: panel_neural_learn_button
  property alias panel_neural_run_button: panel_neural_run_button
  property alias panel_neural_stop_button: panel_neural_stop_button
  property alias panel_neural_trash_button: panel_neural_trash_button
  property alias panel_neural_trash_button_background: panel_neural_trash_button_background

  id: page

  Column {
    id: panel_neural_button_column
    anchors.right: parent.right
    anchors.rightMargin: page.width * 0.06
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: parent.height * 0.05
    spacing: parent.height * 0.02

    Button {
      id: panel_neural_learn_button
      width: page.width * 0.093
      height: page.height * 0.165

      background: Image {
        anchors.fill: parent
        source: parent.down ? "qrc:/images/panel_neural_button_learn_click.png" : "qrc:/images/panel_neural_button_learn.png"
      }
    }

    Button {
      id: panel_neural_run_button
      width: page.width * 0.093
      height: page.height * 0.165

      background: Image {
        anchors.fill: parent
        source: parent.down ? "qrc:/images/panel_neural_button_run_click.png" : "qrc:/images/panel_neural_button_run.png"
      }
    }

    Button {
      id: panel_neural_stop_button
      width: page.width * 0.093
      height: page.height * 0.165

      background: Image {
        anchors.fill: parent
        source: parent.down ? "qrc:/images/panel_neural_button_stop_click.png" : "qrc:/images/panel_neural_button_stop.png"
      }
    }

    Button {
      id: panel_neural_trash_button
      width: page.width * 0.093
      height: page.height * 0.165

      background: Image {
        id: panel_neural_trash_button_background
        anchors.centerIn: parent
        width: page.width * 0.081
        height: page.height * 0.144
        source: "qrc:/images/panel_neural_button_trash.png"
      }
    }
  }

  Text {
    id: panel_neural_learned_text
    anchors.bottom: parent.bottom
    anchors.bottomMargin: parent.height * 0.08
    anchors.left: parent.left
    anchors.leftMargin: parent.width * 0.05
    text: "Learned: 0/10"
    font.pointSize: 18
    color: app_window.colorA
  }
}
