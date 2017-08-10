import QtQuick 2.4

import "../components"

PanelParameterForm {
  Connections {
    target: xpider_center

    onDistanceUpdated: {
      if(distance === 0) {
        panel_param_distance_value.text = "Invaild";
        panel_param_distance_pointer.visible = false;
      } else {
        panel_param_distance_value.text = distance + "mm"
        panel_param_distance_pointer.visible = true;
        panel_param_distance_pointer.x = distance * 0.7
      }
    }

    onSoundLevelUpdated: {
      // console.debug(sound_value);
      panel_param_sound_flow.update(sound_value);
    }
  }

  Component.onCompleted: {
  }

  Component.onDestruction: {
  }
}
