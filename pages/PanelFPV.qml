import QtQuick 2.4
import QtMultimedia 5.5
import QtQuick.Controls 2.1

import Xpider 1.0
import "../components"

PanelFPVForm {
  id: fpv_panel
  property real video_scale: width / 1280

  property int last_x: 0;
  property int last_y: 0;
  property int last_z: 0;

  property bool face_detect_enalbe: false
  property bool panel_fpv_led_enable: false
  property bool panel_fpv_face_enable: true
  property bool panel_fpv_sound_enable: false

  XCamera {
    id: panel_fpv_camera
  }

  VideoOutput {
    id: panel_fpv_videooutput
    z: 1
    anchors.fill: parent
    source: panel_fpv_camera
    // rotation: 180
    filters: [panel_fpv_face_detect_filter]
  }

  FaceDetectFilter {
    id: panel_fpv_face_detect_filter

    onFinished: {
//      if(face_list.length !== 0) {
//        panel_fpv_frame.visible = true;
//        panel_fpv_frame.x = face_list[0].x * video_scale - 0.1*face_list[0].width/2;
//        panel_fpv_frame.y = face_list[0].y * video_scale - 0.1*face_list[0].width/2;
//        panel_fpv_frame.width = face_list[0].width * video_scale + 0.1*face_list[0].width;
//        panel_fpv_frame.height = face_list[0].height * video_scale + 0.1*face_list[0].width;
//      } else {
//        console.debug("No Face");
//        panel_fpv_frame.visible = false;
//      }
    }
  }

  panel_fpv_led_mousearea.onClicked: {
    panel_fpv_led_enable = !panel_fpv_led_enable
    button_clicked(panel_fpv_led_image, panel_fpv_led_enable)

    /* TODO: 给每个界面添加启动和关闭函数，里面包含visible的更改，还有界面的初始化 */
    if(panel_fpv_led_enable) {
      panel_fpv_color_bar_image.opacity = 1;
      panel_fpv_color_button_mousearea.enabled = true;
    } else {
      xpider_center.setFrontLeds(0, 0, 0, 0, 0, 0);
      panel_fpv_color_bar_image.opacity = 0.3;
      panel_fpv_color_button_mousearea.enabled = false;
    }
  }

  panel_fpv_face_mousearea.onClicked: {
    panel_fpv_face_enable = !panel_fpv_face_enable
    panel_fpv_face_detect_filter.enableFaceRecognize(panel_fpv_face_enable);
    button_clicked(panel_fpv_face_image, panel_fpv_face_enable)
  }

  panel_fpv_sound_mousearea.onClicked: {
    panel_fpv_sound_enable = !panel_fpv_sound_enable
    button_clicked(panel_fpv_sound_image, panel_fpv_sound_enable)
  }

  panel_fpv_color_button_mousearea.onPressed: {
    var target_x = panel_fpv_color_button_image.x
    if(mouse.x < app_window.width*0.008) {
      target_x = app_window.width*0.008
    } else if (mouse.x > app_window.width*0.262) {
      target_x = app_window.width*0.262
    } else {
      target_x = mouse.x
    }

    panel_fpv_color_button_image.x = target_x - panel_fpv_color_button_image.width / 2;

    var h_value = 359 - (target_x - app_window.width*0.008) / (app_window.width*0.254) * 359
    xpider_center.setFrontLedsByHSV(h_value, 100, 100, h_value, 100, 100)
    // console.debug("h_value: ", h_value, ", target_x", target_x);
  }

  panel_fpv_color_button_mousearea.onPositionChanged: {
    var target_x = panel_fpv_color_button_image.x
    if(mouse.x < app_window.width*0.008) {
      target_x = app_window.width*0.008
    } else if (mouse.x > app_window.width*0.262) {
      target_x = app_window.width*0.262
    } else {
      target_x = mouse.x
    }

    panel_fpv_color_button_image.x = target_x - panel_fpv_color_button_image.width / 2;

    var h_value = 359 - (target_x - app_window.width*0.008) / (app_window.width*0.254) * 359
    xpider_center.setFrontLedsByHSV(h_value, 100, 100, h_value, 100, 100)
    // console.debug("h_value: ", h_value, ", target_x", target_x);
  }

  panel_fpv_info_mousearea.onClicked: {
    panel_fpv_info_text.visible = !panel_fpv_info_text.visible;
  }

  panel_fpv_imu_mousearea.onClicked: {
    panel_fpv_distance_text.visible = !panel_fpv_distance_text.visible;
  }

  Connections {
    target: panel_fpv_joy

    onJoyUpdated: {
      x_value = Math.abs(x_value)<0.4 ? 0 : x_value;
      y_value = Math.abs(y_value)<0.4 ? 0 : y_value;
      z_value = Math.abs(z_value)<0.4 ? 0 : z_value;

      xpider_center.setEyeMove(Math.round(z_value*100));
      xpider_center.setMove(Math.round(y_value*100), Math.round(x_value*100));

      // console.debug("x_value: ", x_value, ", y_value: ", y_value, ", z_value: ", z_value);
      // console.debug("last_x: ", last_x, ", last_y: ", last_y);
    }
  }

  Connections {
    target: xpider_center

    onDeviceConnected: {
      if(panel_fpv_camera.is_opened() === false) {
        panel_fpv_camera_status_text.text = "Connecting..."
        panel_fpv_camera.startVideo();
      }
    }

    onDeviceDisconnected: {
      if(panel_fpv_camera.is_opened() === true) {
        panel_fpv_camera_status_text.text = "Please check wifi and xpider power status"
        panel_fpv_camera.stopVideo();
      }
    }

    onVoltageUpdated: {
      panel_fpv_info_text.text = voltage.toFixed(1) + "v";
    }

    onDistanceUpdated: {
      panel_fpv_distance_text.text = distance.toFixed(1) + "mm";
    }
  }

  Connections {
    target: panel_fpv_camera
    onConnectionResult: {
      if(result_code === true) {
        panel_fpv_camera_status_text.visible = false
      } else {
        panel_fpv_camera_status_text.text = "Camera Error, Code: " + result_code
      }
    }
  }

  function button_clicked(image_view, value) {
    if(value === true) {
      image_view.source = "qrc:/images/panel_fpv_switch_on.png"
    } else {
      image_view.source = "qrc:/images/panel_fpv_switch_off.png"
    }
  }

  Component.onCompleted: {
    if(xpider_enable === true) {
      panel_fpv_camera.startVideo()
    } else {
      panel_fpv_camera_status_text.text = "Please check wifi and xpider power status"
    }
  }

  Component.onDestruction: {
    if(panel_fpv_camera.is_opened()) {
      panel_fpv_camera.stopVideo()
    }
  }
}
