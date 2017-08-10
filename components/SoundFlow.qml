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
