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

PanelScanForm {
  property bool is_scanning: false

  RotationAnimation {
    id: panel_scan_scan_line_animation
    target: panel_scan_scan_line_image
    running: true
    from: 0
    to: 360
    direction: RotationAnimation.Clockwise
    duration: 8000
    loops: Animation.Infinite
  }

  ParallelAnimation {
    id: panel_scan_scan_circle_animation
    // running: true
    SequentialAnimation {
      PauseAnimation {
        duration: 0
      }
      ParallelAnimation {
        ScaleAnimator{
          target: panel_scan_scan_circle1_image;
          easing.type: Easing.InOutQuad
          from: 0.01
          to: 1
          duration: 4000
          loops: Animation.Infinite
        }
        OpacityAnimator {
          target: panel_scan_scan_circle1_image;
          easing.type: Easing.InOutQuad
          from: 1
          to: 0
          duration: 4000
          loops: Animation.Infinite
        }
      }
    }

    SequentialAnimation {
      PauseAnimation {
        duration: 600
      }
      ParallelAnimation {
        ScaleAnimator{
          target: panel_scan_scan_circle2_image
          easing.type: Easing.InOutQuad
          from: 0.01
          to: 1
          duration: 4000
          loops: Animation.Infinite
        }
        OpacityAnimator {
          target: panel_scan_scan_circle2_image
          easing.type: Easing.InOutQuad
          from: 1
          to: 0
          duration: 4000
          loops: Animation.Infinite
        }
      }
    }

    SequentialAnimation {
      PauseAnimation {
        duration: 1200
      }
      ParallelAnimation {
        ScaleAnimator{
          target: panel_scan_scan_circle3_image
          easing.type: Easing.InOutQuad
          from: 0.01
          to: 1
          duration: 4000
          loops: Animation.Infinite
        }
        OpacityAnimator {
          target: panel_scan_scan_circle3_image
          easing.type: Easing.InOutQuad
          from: 1
          to: 0
          duration: 4000
          loops: Animation.Infinite
        }
      }
    }
  }

  panel_scan_stop_mousearea.onPressed: {
     panel_scan_stop_image.source = "qrc:/images/panel_scan_stop_pressed.png"
  }

  panel_scan_stop_mousearea.onReleased: {
    if(is_scanning === true) {
      xpider_center.stop();
    } else {
      xpider_center.start();
    }

     panel_scan_stop_image.source = "qrc:/images/panel_scan_stop_unpressed.png"
  }

  panel_scan_path_view.interactive: false
  panel_scan_path_view.model: xpider_center.deviceList
  panel_scan_path_view.delegate: Component {
    DiscoveredDeviceInfoForm {
      width: 184 * app_window.screen_scale
      height: 159 * app_window.screen_scale
      component_ddi_mousearea.onClicked: {
        xpider_center.stop();
        xpider_center.connectToDevice(modelData.deviceAddress)
        console.debug("Connecting to: ", modelData.deviceAddress)
      }

      Component.onCompleted: {
        component_ddi_text.text = modelData.deviceName.substr(3);
      }
    }
  }

  Connections {
    target: xpider_center

    /* Device list update */
    onDeviceListUpdated: {
      panel_scan_found_index_text.text = panel_scan_path_view.count
    }

    /* Start ble device scan */
    onStateDeviceDiscoverStarted: {
      console.debug("Scanning new devices...");

      setScanState(true);
    }

    /* Scan complete */
    onStateDeviceDiscoverDone: {
      console.debug("Scan finish.");

      setScanState(false);
    }

    /* start to scan ble service */
    onStateServiceDiscoverStarted: {
      console.debug("Searching required serivce.");
    }

    /* ble service scan finished */
    onStateServiceDiscoverDone: {
      if(xpider_center.isServiceDiscovered()) {
        console.debug("Reuqired service found.");
        stop();
        fpv_panel.start();
      } else {
        console.debug("Required service not found on target.");
      }
    }
  }

  function setScanState(state) {
    if(state === true) {
      is_scanning = state;
      panel_scan_button_text.source = "qrc:/images/panel_scan_button_word_stop.png"
      panel_scan_scan_line_animation.running = true;
      panel_scan_scan_circle_animation.running = true;

      panel_scan_scan_line_image.visible = true;
      panel_scan_scan_circle1_image.visible = true;
      panel_scan_scan_circle2_image.visible = true;
      panel_scan_scan_circle3_image.visible = true;
    } else if (state === false) {
      is_scanning = state;
      panel_scan_button_text.source = "qrc:/images/panel_scan_button_word_start.png"
      panel_scan_scan_line_animation.running = false;
      panel_scan_scan_circle_animation.running = false;

      panel_scan_scan_line_image.visible = false;
      panel_scan_scan_circle1_image.visible = false;
      panel_scan_scan_circle2_image.visible = false;
      panel_scan_scan_circle3_image.visible = false;
    }
  }

  function disconnect() {
    xpider_center.disconnectFromDevice();
  }

  Component.onCompleted: {
    xpider_center.start();
  }

  Component.onDestruction: {
    xpider_center.stop();
  }
}
