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

import "../components"

PanelSettingsForm {
  property var firmware_version: "unknown"
  property var controller_version: "unknown"

  XDialog {
    id: panel_settings_dialog

    Text {
      id: panel_settings_dialog_text
      anchors.centerIn: parent
      width: parent.width * 0.9
      text:""
      color: app_window.colorA
      font.pointSize: 18
      horizontalAlignment: Text.AlignHCenter
      wrapMode: Text.Wrap
    }
  }

  panel_settings_complete_button.onClicked: {
    console.debug(panel_settings_name_input.text);
    console.debug(panel_settings_name_input.acceptableInput);
    xpider_center.updateName(panel_settings_name_input.text);
    panel_settings_dialog_text.text = "Please restart Xpider and reconnect to the new WIFI: " + panel_settings_name_input.text
    panel_settings_dialog.open();
  }

  Connections {
    target: xpider_center

    onNameUpdated: {
      panel_settings_name_input.text = name;
    }

    onVersionUpdated: {
      panel_settings_version_value.text = version;
    }

    onFirmwareUpdated: {
      firmware_version = firmware
      panel_settings_firmware_value.text = firmware_version + ", " + controller_version
    }

    onUuidUpdated: {
      panel_settings_uuid_value.text = uuid;
    }

    onControllerUpdated: {
      controller_version = controller
      panel_settings_firmware_value.text = firmware_version + ", " + controller_version
    }

    onDeviceConnected: {
      xpider_center.getXpiderInfo();
    }

    onDeviceDisconnected: {
      panel_settings_name_input.readOnly = true;
      panel_settings_name_input.text = "Unknown";
      panel_settings_version_value.text = "Unknown";
      panel_settings_firmware_value.text = "Unknown";
      panel_settings_uuid_value.text = "Unknown";
    }
  }

  Component.onCompleted: {
    panel_settings_name_input.readOnly = false;
    panel_settings_name_input.text = "LOADING...";
    panel_settings_version_value.text = "LOADING...";
    panel_settings_firmware_value.text = "LOADING...";
    panel_settings_uuid_value.text = "LOADING...";

    xpider_center.getXpiderInfo();
  }

  Component.onDestruction: {
  }
}
