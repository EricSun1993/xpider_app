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

SoundFlowForm {
  property var delta_list: []
  property int flow_item_number: 100
  property int flow_center: height / 2

  Canvas {
    id: sound_flow_canvas
    anchors.fill: parent

    onPaint: {
      var ct = getContext('2d');

      ct.clearRect(0, 0, width, height);

      ct.strokeStyle = app_window.colorA;
      ct.lineWidth = 1;

      ct.shadowColor = '#000000';
      ct.shadowBlur = 3;
      ct.shadowOffsetX = 2;
      ct.shadowOffsetY = 4;

      for(var i=0; i<delta_list.length; i++) {
        ct.beginPath();
        ct.moveTo(i*width*0.01, flow_center - delta_list[i]);
        ct.lineTo(i*width*0.01, flow_center + delta_list[i]);
        ct.closePath;
        ct.stroke();
      }
    }
  }

  function update(value) {
    /* 测试代码 */
    // var t = Math.random()*255
    // var delta = t / 255 * flow_center;

    var delta = value / 255 * flow_center;

    /* 绘制中线 */
    if(delta === 0) {
      delta = 5;
    }

    if(delta_list.length > flow_item_number) {
      delta_list.shift();
    }
    delta_list.push(delta);

    sound_flow_canvas.requestPaint();
  }

  function stop() {
    delta_list = [];
  }
}
