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
import QtQuick.Window 2.2

import "../components"

PanelMapForm {
  property int pixel_per_step: app_window.width*0.008
  property real screen_center_x: xpider_image.x + xpider_image.width / 2
  property real screen_center_y: xpider_image.y + xpider_image.height / 2

//  Behavior on xpider_image.rotation {
//    SmoothedAnimation { velocity: 180 }
//  }

//  Behavior on xpider_arrow_image.rotation {
//    SmoothedAnimation { velocity: 180 }
//  }

  Canvas {
    id: background_canvas
    anchors.fill: parent

    property bool autopilot_enalbe: false
    property var paint_object_list: [{x: 0, y: 0}]

    property real grid1_width: parent.width * 0.05
    property real grid2_width: parent.width * 0.5

    property real delta_grid1_x: 0
    property real delta_grid1_y: 0
    property real delta_grid2_x: 0
    property real delta_grid2_y: 0

    onPaint: {
      var ctx = getContext('2d');
      ctx.lineWidth = 1;
      ctx.fillStyle = app_window.colorB;

      ctx.strokeStyle = app_window.colorA;
      ctx.fillRect(0,0,background_canvas.width,background_canvas.height);

      // draw grid line
      if(background_canvas.paint_object_list[0].x !== 0) {
        background_canvas.delta_grid1_x = -pixel_per_step * background_canvas.paint_object_list[0].x % background_canvas.grid1_width;
      }
      if(background_canvas.paint_object_list[0].y !== 0) {
        background_canvas.delta_grid1_y = pixel_per_step * background_canvas.paint_object_list[0].y % background_canvas.grid1_width;
      }

      if(background_canvas.paint_object_list[0].x !== 0) {
        background_canvas.delta_grid2_x = -pixel_per_step * background_canvas.paint_object_list[0].x % background_canvas.grid2_width;
      }
      if(background_canvas.paint_object_list[0].y !== 0) {
        background_canvas.delta_grid2_y = pixel_per_step * background_canvas.paint_object_list[0].y % background_canvas.grid2_width;
      }

      // grid 1
      ctx.beginPath();
      for(var ii=background_canvas.delta_grid1_y; ii<background_canvas.height;) {
          ctx.moveTo(0, ii);
          ctx.lineTo(background_canvas.width, ii);
          ii = ii +grid1_width;
      }

      for(ii=background_canvas.delta_grid1_x; ii<background_canvas.width;) {
          ctx.moveTo(ii, 0);
          ctx.lineTo(ii, background_canvas.height);
          ii = ii +grid1_width;
      }

      ctx.closePath();

      ctx.stroke();

      // grid 2
      ctx.lineWidth = 2;
      ctx.beginPath();
      for(ii=background_canvas.delta_grid2_y; ii<background_canvas.height;) {
          ctx.moveTo(0, ii);
          ctx.lineTo(background_canvas.width, ii);
          ii = ii +grid2_width;
      }

      for(ii=background_canvas.delta_grid2_x; ii<background_canvas.width;) {
          ctx.moveTo(ii, 0);
          ctx.lineTo(ii, background_canvas.height);
          ii = ii +grid2_width;
      }

      ctx.closePath();

      ctx.stroke();

      ctx.fillStyle = app_window.colorA;

      var xpider_x = background_canvas.paint_object_list[0].x;
      var xpider_y = background_canvas.paint_object_list[0].y;

      // darw obstacle
      var obstacle_x, obstacle_y
      for(var i=2; i<background_canvas.paint_object_list.length; i++) {
        if(background_canvas.paint_object_list[i].x !== 0 ||
           background_canvas.paint_object_list[i].y !== 0) {
          obstacle_x = (background_canvas.paint_object_list[i].x-xpider_x)*pixel_per_step+screen_center_x;
          /* cause y axis in canvas is opposite of xpider coordinate */
          obstacle_y = (-1)*(background_canvas.paint_object_list[i].y-xpider_y)*pixel_per_step+screen_center_y;

          ctx.fillStyle = "#FF0000";
          ctx.strokeStyle = "#FF0000";

          ctx.beginPath();
          ctx.arc(obstacle_x, obstacle_y, app_window.width*0.02, 0, Math.PI * 2, false);
          ctx.closePath();
          ctx.fill();
          ctx.stroke();

          // console.debug("obstacle x: ", obstacle_x)
          // console.debug("obstacle y: ", obstacle_y)
        } else {
          // console.debug("Obstacle is too far/near.")
        }
      }
    }

    function updateMap(a_enable, object_list) {
      background_canvas.autopilot_enalbe = a_enable;
      background_canvas.paint_object_list = object_list;
      background_canvas.requestPaint();
    }
  }

  Connections {
    target: xpider_center
    onMapUpdated: {
      // update heading
      var heading_degree = heading/Math.PI*180;
      if(heading_degree < 0) {
        heading_degree = heading_degree + 360;
      }
      xpider_image.rotation = heading_degree;

      // update map grid and obstacle
      background_canvas.updateMap(autopilot_enable, map_object_list);

      if(autopilot_enable === true) {
        var delta_x = map_object_list[1].x - map_object_list[0].x;
        var delta_y = (map_object_list[1].y - map_object_list[0].y);
        /* cause y axis in canvas is opposite of xpider coordinate */
        var target_degree = Math.PI/2 - Math.atan2(delta_y, delta_x);

//        console.debug("t_x: ", map_object_list[1].x)
//        console.debug("t_y: ", map_object_list[1].y)
//        console.debug("x_x: ", map_object_list[0].x)
//        console.debug("x_y: ", map_object_list[0].y)
//        console.debug("t_d: ", target_degree)

        // update target flag image
        destination_image.visible = true;
        destination_image.x = delta_x*pixel_per_step+screen_center_x-destination_image.width/2;
        /* cause y axis in canvas is opposite of xpider coordinate */
        destination_image.y = (-1)*(delta_y*pixel_per_step)+screen_center_y-destination_image.height/2;

        // update target arraow image
        xpider_arrow_image.rotation = target_degree/Math.PI*180;
        // console.debug("target_degree: ", target_degree/Math.PI*180);
      } else {
        destination_image.visible = false;
        xpider_arrow_image.visible = false;
      }
    }
  }

  Connections {
    target: xpider_center
    onObstacleUpdated: {

    }
  }

  stop_mousearea.onPressed: {
    stop_button_image.source = "qrc:/images/map_stop_clicked.png";
  }

  stop_mousearea.onReleased: {
    stop_button_image.source = "qrc:/images/map_stop.png";
    xpider_center.stopAutopilot();
  }

  destination_mousearea.onClicked: {
    xpider_arrow_image.visible = true;

    var target_relative_x = (mouse.x - screen_center_x) / pixel_per_step;
    var target_relative_y = (mouse.y - screen_center_y) / pixel_per_step;
    /* cause y axis in canvas is opposite of xpider coordinate */
    xpider_center.setAutopilotTarget(target_relative_x, target_relative_y*(-1));
  }

  Component.onCompleted: {
    background_canvas.requestPaint();
  }

  Component.onDestruction: {
    xpider_center.stopAutopilot();
  }
}
