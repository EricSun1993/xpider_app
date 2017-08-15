import QtQuick 2.4
import "../components"

PanelNeural2Form {
  property var sensor_list: []

  ListModel {
    id: sensor_list_model

    ListElement {
      name: "Obstacle"
      selected: false
      description: "Obstacle Sensor\n\nObstacle sensor use ir distance sensor to get obstacle distance."
      imageA: "qrc:/images/panel_neural_sensor_distance.png"
      imageB: "qrc:/images/panel_neural_sensor_distance_click.png"
    }

    ListElement {
      name: "Sound"
      selected: false
      description: "Sound Sensor\n\nSound sensor use microphone to get sound level data."
      imageA: "qrc:/images/panel_neural_sensor_sound.png"
      imageB: "qrc:/images/panel_neural_sensor_sound_click.png"
    }

    ListElement {
      name: "Gryo"
      selected: false
      description: "Gryo Sensor\n\nGryo sensor use IMU to get 6-axis data in 10fps."
      imageA: "qrc:/images/panel_neural_sensor_gyro.png"
      imageB: "qrc:/images/panel_neural_sensor_gyro_click.png"
    }
  }

  XDialog {
    id: panel_neural2_dialog

    Text {
      anchors.centerIn: parent
      width: parent.width * 0.9
      id: panel_neural2_dialog_text

      text:"Please select at least 1 sensor"
      color: app_window.colorA
      font.pointSize: 18
      horizontalAlignment: Text.AlignHCenter
      wrapMode: Text.Wrap
    }
  }

  panel_neural_2_gridview.model: sensor_list_model
  panel_neural_2_gridview.delegate:
   NeuralItem {
    width: app_window.width * 0.091
    height: app_window.height * 0.162
    item_image.source: model.imageA

    item_mouse_area.onClicked: {
      selected = !selected;
      model.selected = selected;
      item_image.source = selected ? model.imageB : model.imageA;
      // console.debug(model.name);
      sensor_description_label.text = model.description
    }
  }

  panel_neural_2_button.onClicked: {
    var is_empty = true
    sensor_list = []
    for(var i=0; i<sensor_list_model.count; i++) {
      if(sensor_list_model.get(i).selected === true) {
        sensor_list.push(i+1);
        is_empty = false
      }
    }

    if(is_empty === true) {
      panel_neural2_dialog.open()
    } else {
      stack.push("qrc:/pages/PanelNeural3.qml", {"sensor_list": sensor_list})
    }
  }
}
