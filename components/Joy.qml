import QtQuick 2.4

JoyForm {
  property int range: width * 0.1;
  property int component_center_x: width/2
  property int component_center_y: height/2

  // TODO: 使用point list代替
  property real joy1_center_x: component_joy1_normal_image.x + component_joy1_normal_image.width/2;
  property real joy1_center_y: component_joy1_normal_image.y + component_joy1_normal_image.height/2;
  property real joy2_center_x: component_joy2_normal_image.x + component_joy2_normal_image.width/2;
  property real joy2_center_y: component_joy2_normal_image.y + component_joy2_normal_image.height/2;
  property bool left_joy_enable: false
  property bool right_joy_enable: false
  property real x_value: 0
  property real y_value: 0
  property real z_value: 0

  /* x为joy2的x坐标，y为joy1的y坐标，z为joy2的y坐标，数值范围-100~100*/
  signal joyUpdated(var x_value, var y_value, var z_value);

  component_joy_mousearea.onTouchUpdated: {
    for(var tp_index=0; tp_index<touchPoints.length; tp_index++) {
      var x, y, r, alpha, map_point;

      if(touchPoints[tp_index].x < component_center_x) {
        x = touchPoints[tp_index].x - joy1_center_x;
        y = touchPoints[tp_index].y - joy1_center_y;
        r = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
        alpha = calc_alpha(x, y, r);
        if(r > range) {
          if(left_joy_enable === true) {
            component_joy1_button_image.x= joy1_center_x + range*Math.cos(alpha) - component_joy1_button_image.width/2;
            component_joy1_button_image.y = joy1_center_y + range*Math.sin(alpha) - component_joy1_button_image.height/2;
            // console.debug("Joy: left joy out of range, set max value");
          }
        } else {
          left_joy_enable = true;
          component_joy1_button_image.x = touchPoints[tp_index].x - component_joy1_button_image.width/2;
          component_joy1_button_image.y = touchPoints[tp_index].y - component_joy1_button_image.height/2;
          // console.debug("Joy: update left joy value");
        }

        if(left_joy_enable === true) {
          y_value = y / range * (-1.0);
          if(y_value < -1.0) { y_value = -1.0; }
          if(y_value > 1.0) { y_value = 1.0; }

          component_joy1_move_image.visible = true;
          component_joy1_move_image.opacity = (r / range) + 0.2;
        }
      } else {
        x = touchPoints[tp_index].x - joy2_center_x;
        y = touchPoints[tp_index].y - joy2_center_y;
        r = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
        alpha = calc_alpha(x, y, r);

        if(r > range) {
          if(right_joy_enable === true) {
            component_joy2_button_image.x= joy2_center_x + range*Math.cos(alpha) - component_joy2_button_image.width/2;
            component_joy2_button_image.y = joy2_center_y + range*Math.sin(alpha) - component_joy2_button_image.height/2;
            // console.debug("Joy: right joy out of range, set max value");
          }
        } else {
          right_joy_enable = true;
          component_joy2_button_image.x = touchPoints[tp_index].x - component_joy2_button_image.width/2;
          component_joy2_button_image.y = touchPoints[tp_index].y - component_joy2_button_image.height/2;
          // console.debug("Joy: update right joy value");
        }

        if(right_joy_enable === true) {
          x_value = x / range;
          z_value = y / range * (-1.0);
          if(x_value < -1.0) { x_value = -1.0; }
          if(x_value > 1.0) { x_value = 1.0;}
          if(z_value < -1.0) { z_value = -1.0; }
          if(z_value > 1.0) { z_value = 1.0; }

          component_joy2_move_image.visible = true;
          component_joy2_move_image.opacity = (r / range) + 0.2;
        }
      }
    }

    /* emit joy updated signal */
    joyUpdated(x_value, y_value, z_value);
  }

  component_joy_mousearea.onReleased: {
    for(var tp_index=0; tp_index<touchPoints.length; tp_index++) {
      if(touchPoints[tp_index].x < component_center_x) {
        if(left_joy_enable === true) {
          // console.debug("Joy: Release left joy");
          left_joy_enable = false;
          y_value = 0;
          joyUpdated(x_value, y_value, z_value);

          component_joy1_move_image.opacity = 0.3;
          component_joy1_button_image.x = joy1_center_x - component_joy1_button_image.width/2
          component_joy1_button_image.y = joy1_center_y - component_joy1_button_image.height/2
        }
      } else {
        if(right_joy_enable === true) {
          // console.debug("Joy: Release right joy");
          right_joy_enable = false;
          x_value = 0;
          z_value = 0;
          joyUpdated(x_value, y_value, z_value);

          component_joy2_move_image.opacity = 0.3;
          component_joy2_button_image.x = joy2_center_x - component_joy2_button_image.width/2
          component_joy2_button_image.y = joy2_center_y - component_joy2_button_image.height/2
        }
      }
    }
  }

  function calc_alpha(x,y,r) {
    if(r === 0)return 0;
    var alpha = Math.asin(y / r);
    if(x < 0) {
      alpha = Math.PI-alpha;
    }

    return alpha;
  }
}
