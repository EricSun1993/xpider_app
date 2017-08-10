import QtQuick 2.4

StepChartForm {
  property var list: []

  Canvas {
    id: step_chart_canvas
    anchors.fill: parent

    onPaint: {
      var ct = getContext('2d');

      var chart_canvas_times = 0.8;
      var chart_width = width * chart_canvas_times;
      var chart_height = height * chart_canvas_times;
      var top_left_x = (width - chart_width) / 2;
      var top_left_y = (height - chart_height) / 2;

      var chart_element_times = chart_canvas_times / 10;
      var chart_element_delta = chart_element_times * chart_width;

      ct.clearRect(0, 0, width, height);

      ct.strokeStyle = '#00FFDA';
      ct.fillStyle = '#00FFDA';
      ct.lineWidth = 1;

      ct.shadowColor = '#000000';
      ct.shadowBlur = 4;
      ct.shadowOffsetX = 3;
      ct.shadowOffsetY = 5;

      ct.beginPath();
      ct.moveTo(top_left_x, top_left_y);
      ct.lineTo(top_left_x, top_left_y+chart_height);
      ct.lineTo(top_left_x+chart_width, top_left_y+chart_height);
      ct.stroke();

      for(var i=1; i<12; i++) {
        ct.beginPath();
        ct.moveTo(top_left_x+i*chart_element_delta, top_left_y+chart_height*0.99);
        ct.lineTo(top_left_x+i*chart_element_delta, top_left_y+chart_height*0.94 );
        ct.stroke();
      }

      ct.font = "9pt sans-serif";
      for( i=1; i<12; i++) {
        ct.fillText(parseInt(list[i]), top_left_x+i*chart_element_delta-chart_element_delta*0.3, top_left_y+chart_height*1.1)
      }

      ct.beginPath();
      ct.moveTo(top_left_x, list[0]/1000*chart_height)
      for(i=1; i<12; i++) {
        ct.lineTo(top_left_x+i*chart_element_delta, top_left_y+(1000-list[i])/1000*chart_height* 0.8);
      }
      ct.stroke();

      for(i=1; i<12; i++) {
            ct.beginPath();
            ct.arc(top_left_x+i*chart_element_delta, top_left_y+(1000-list[i])/1000*chart_height* 0.8, app_window.width*0.008, 0, Math.PI*2, true);
            ct.fill();
      }
      ct.stroke();
    }
  }

  function start() {
    generateList();
    step_chart_canvas.requestPaint();
  }

  function generateList() {
    for(var i=0; i<12; i++){
      list.push(Math.random()*1000);
    }
  }

  Component.onCompleted: {
    start();
  }
}
