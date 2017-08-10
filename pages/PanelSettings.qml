import QtQuick 2.4

import "../components"

PanelSettingsForm {
  panel_settings_complete_button.onClicked: {
    console.debug(panel_settings_name_input.text);
    console.debug(panel_settings_name_input.acceptableInput);
    xpider_center.updateName(panel_settings_name_input.text);
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
      panel_settings_firmware_value.text = firmware;
    }

    onUuidUpdated: {
      panel_settings_uuid_value.text = uuid;
    }
  }

  Component.onCompleted: {
    panel_settings_name_input.text = "LOADING...";
    panel_settings_version_value.text = "LOADING...";
    panel_settings_firmware_value.text = "LOADING...";
    panel_settings_uuid_value.text = "LOADING...";

    xpider_center.getXpiderInfo();
  }

  Component.onDestruction: {
  }
}
