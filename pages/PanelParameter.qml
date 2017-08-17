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
