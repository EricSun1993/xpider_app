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
