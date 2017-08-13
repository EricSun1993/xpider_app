import QtQuick 2.4
import QtQuick.Controls 2.0

PanelNeural3Form {
  property var sensor_list: []
  property var groups: [{action: [], "id": 1, "learned": 0}, {action:[], "id": 2, "learned": 0}]
  property var action_template: {
    "list": ["walk", "rotate", "led"],
    "add_action": {
      "image": "qrc:/images/panel_neural_button_action_add.png",
      "description": "Do not delete this object!!!"
    },
    "walk": {
      "template": '{"type": "walk", "speed": 100, "time": 1000}',
      "image": "qrc:/images/panel_neural_action_walk.png",
      "add_image": "qrc:/images/panel_neural_add_walk.png",
      "image_selected": "qrc:/images/panel_neural_add_walk_click.png",
      "description": "Walk with defined speed and timeout."
    },
    "rotate": {
      "template": '{"type": "rotate", "speed": 100, "time": 1000}',
      "image": "qrc:/images/panel_neural_action_rotate.png",
      "add_image": "qrc:/images/panel_neural_add_rotate.png",
      "image_selected": "qrc:/images/panel_neural_add_rotate_click.png",
      "description": "Rotate with defined speed and timeout."
    },
    "led": {
      "template": '{"type": "led", "rr": 255, "rg": 255, "rb": 255, "lr": 255, "lg": 255, "lb": 255, "time": 1000}',
      "image": "qrc:/images/panel_neural_action_led.png",
      "add_image": "qrc:/images/panel_neural_add_light.png",
      "image_selected": "qrc:/images/panel_neural_add_light_click.png",
      "description": "Set front full-color leds with defined color."
    }
  }

  id: page

  TabBar {
    id: group_tab_bar
    anchors.left: parent.left
    anchors.leftMargin: page.width * 0.08
    anchors.top: parent.top
    anchors.topMargin: page.height * 0.03
    width: page.width * 0.9
    background: Item {
      /* set background to empty */
    }

    Repeater {
      id:groups_repeater
      model: groups.length

      TabButton {
        text: qsTr("Second")
        width: app_window.width * 0.120
        height: app_window.height * 0.104
        anchors.verticalCenter: parent.verticalCenter
        contentItem: Text {
          color: (group_tab_bar.currentIndex===index) ? app_window.colorB : app_window.colorA
          anchors.centerIn: group_tab_bar.Center
          text: "GROUP" + (index+1)
          font.pointSize: 12
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        background: Image {
          anchors.centerIn: group_tab_bar.Center
          width: app_window.width * 0.120
          height: app_window.height * 0.104
          source: (group_tab_bar.currentIndex===index) ?
                  "qrc:/images/panel_neural_button_group.png" :
                  "qrc:/images/panel_neural_button_group_click.png"
        }

        onClicked: {
          group_tab_bar.currentIndex = index;
          panel_neural_learned_text.text = "Learned: " + groups[group_tab_bar.currentIndex].learned + "/10";
          setActionGridModel(index);
        }
      }
    }

    TabButton {
      width: app_window.width * 0.046
      height: app_window.height * 0.081
      anchors.verticalCenter: parent.verticalCenter

      background: Image {
        width: app_window.width * 0.046
        height: app_window.height * 0.081
        source: "qrc:/images/panel_neural_button_group_add.png"
      }

      MouseArea {
        id: add_mousearea
        anchors.fill: parent

        onClicked: {
          groups.push({"id": groups.length+1, "action": [], "learned": 0});
          groups_repeater.model = groups.length;
          group_tab_bar.currentIndex = groups.length-1;
          setActionGridModel(groups.length-1)
          if(groups.length >= 5) {
            parent.enabled = false;
          }
        }
      }
    }

    Component.onCompleted: {
      currentIndex = 0;
      setActionGridModel(0);
    }
  }

  GridView {
    id: action_grid_view
    width: page.width * 0.7
    height: page.height * 0.6
    anchors.left: parent.left
    anchors.leftMargin: page.width * 0.037
    anchors.verticalCenter: parent.verticalCenter

    cellWidth: page.width * 0.11
    cellHeight: page.height * 0.173
    model: ListModel {
      id: action_grid_model

      /* add button, this element should not be deleted at anytime*/
      ListElement {
        type: "add_action"
      }
    }

    delegate: Button {
      width: page.width * 0.097
      height: page.height * 0.173

      background: Image {
        anchors.fill: parent
        source: action_template[model.type].image
      }

      onClicked: {
        if(model.type === "add_action") {
          add_action_popup.open();
        } else {
          action_grid_view.currentIndex = index;
          setSettingsModel(groups[group_tab_bar.currentIndex].action[index]);
          action_setting_popup.open();
        }
      }
    }
  }

  Popup {
    id: trash_popup
    x: page.width * 0.600
    y: page.height * 0.747
    width: page.width * 0.244
    height: page.height * 0.171

    background: Image {
      anchors.fill: parent
      source: "qrc:/images/panel_neural_popup_delete.png"
    }

    Row {
      anchors.centerIn: parent
      spacing: parent.width * 0.2

      Button {
        width: page.width * 0.061
        height: page.height * 0.109
        enabled: false

        background: Image {
          anchors.fill: parent
          source: parent.down ? "qrc:/images/panel_neural_button_delete_group_click.png" :"qrc:/images/panel_neural_button_delete_group.png"
        }

        onClicked: {
          groups.splice(group_tab_bar.currentIndex, 1);
          groups_repeater.model = groups.length;
          group_tab_bar.currentIndex = groups.length-1;
          setActionGridModel(groups.length-1)
        }
      }

      Button {
        width: page.width * 0.061
        height: page.height * 0.109

        background: Image {
          anchors.fill: parent
          source: parent.down ? "qrc:/images/panel_neural_button_delete_all_click.png" : "qrc:/images/panel_neural_button_delete_all.png"
        }

        onClicked: {
          xpider_center.forget();
          groups = [{action: [], "id": 1, "learned": 0}, {action:[], "id": 2, "learned": 0}];
          groups_repeater.model = groups.length;
          group_tab_bar.currentIndex = groups.length - 1;
          setActionGridModel(groups.length-1)
        }
      }
    }

    onClosed: {
      panel_nerual_trash_button_background.source = "qrc:/images/panel_neural_button_trash.png"
    }
  }

  Popup {
    id: add_action_popup
    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    width: parent.width * 0.6
    height: parent.height * 0.8
    modal: true
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
      anchors.fill: parent
      color: app_window.colorA
    }

    Button {
      x:0
      y:0
      width: page.width * 0.047
      height: page.height * 0.084

      background: Image {
        anchors.fill: parent
        source: "qrc:/images/panel_neural_button_popup_close.png"
      }

      onClicked: {
        add_action_gridview.currentIndex = -1;
        add_action_popup.close();
      }
    }

    GridView {
      id: add_action_gridview
      x: parent.width * 0.1
      y: parent.height * 0.1
      width: parent.width * 0.9
      height: parent.height * 0.7

      cellWidth: page.width * 0.120
      cellHeight: page.height * 0.150

      model: action_template["list"]

      delegate: Button {
        width: page.width * 0.082
        height: page.height * 0.145

        background: Image {
          anchors.fill: parent
          source: add_action_gridview.currentIndex===index ? action_template[modelData].image_selected
                                                           : action_template[modelData].add_image
        }

        onClicked: {
          add_action_gridview.currentIndex = index;
          action_description.text = action_template[modelData].description
        }
      }

      Component.onCompleted: {
        currentIndex = -1;
      }
    }

    Label {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: page.height * 0.05
      anchors.left: parent.left
      anchors.leftMargin: page.width * 0.01
      id: action_description
      text: "Select action to show action description"
    }

    Button {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 0
      anchors.right: parent.right
      anchors.rightMargin: 0
      width: 50
      height: 50
      text: "OK"

      onClicked: {
        groups[group_tab_bar.currentIndex].action.push(JSON.parse(action_template[action_template.list[add_action_gridview.currentIndex]].template));
        setActionGridModel(group_tab_bar.currentIndex);

        console.debug("add action: ", action_template.list[add_action_gridview.currentIndex]);
        console.debug(JSON.stringify(groups));

        add_action_gridview.currentIndex = -1;
        add_action_popup.close();
      }
    }
  }

  Popup {
    id: action_setting_popup
    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    width: parent.width * 0.6
    height: parent.height * 0.9
    modal: true
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
      anchors.fill: parent
      color: app_window.colorA
    }

    Column {
      anchors.verticalCenter: parent.verticalCenter
      width: parent.width
      Repeater {
        id: action_settings_repeater
        model: ListModel{
          id: action_settings_model
        }

        Row {
          Text {
            width: page.width * 0.1
            height: page.height * 0.120
            text: model.key
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
          }
          TextField {
            width: page.width * 0.221
            height: page.height * 0.120
            text: model.value
            color: app_window.colorA

            background: Image {
              anchors.fill: parent
              source: "qrc:/images/panel_neural_settings_input.png"
            }

            onEditingFinished: {
              action_settings_model.setProperty(index, "value", Number(text));
            }
          }
        }
      }
    }

    Button {
      anchors.top: parent.top
      anchors.topMargin: page.height * 0.25
      anchors.right: parent.right
      anchors.rightMargin: page.width * 0.07
      width: page.width * 0.106
      height: page.height * 0.090

      background: Image {
        anchors.fill: parent
        source: parent.down ? "qrc:/images/panel_neural_button_ok_click.png" : "qrc:/images/panel_neural_button_ok.png"
      }

      onClicked: {
        updateActionSettings(group_tab_bar.currentIndex, action_grid_view.currentIndex);
        action_setting_popup.close();
      }
    }

    Button {
      anchors.bottom: parent.bottom
      anchors.bottomMargin: page.height * 0.25
      anchors.right: parent.right
      anchors.rightMargin: page.width * 0.07
      width: page.width * 0.106
      height: page.height * 0.090

      background: Image {
        anchors.fill: parent
        source: parent.down ? "qrc:/images/panel_neural_button_delete_click.png" : "qrc:/images/panel_neural_button_delete.png"
      }

      onClicked: {
        groups[group_tab_bar.currentIndex].action.splice(action_grid_view.currentIndex, 1);
        setActionGridModel(group_tab_bar.currentIndex);
        action_setting_popup.close();
      }
    }
  }

  panel_neural_trash_button.onClicked: {
    trash_popup.open();
    panel_nerual_trash_button_background.source = "qrc:/images/panel_neural_button_trash_click.png"
  }

  panel_neural_learn_button.onClicked: {
    groups.forEach(function(group) {
      xpider_center.saveGroupData(JSON.stringify(group));
    })
//    train_timer.start();
    xpider_center.learn(group_tab_bar.currentIndex+1, sensor_list);
    groups[group_tab_bar.currentIndex].learned += 1;
    panel_neural_learned_text.text = "Learned: " + groups[group_tab_bar.currentIndex].learned + "/10";
  }

  panel_neural_stop_button.onClicked: {
    // train_timer.stop();
    xpider_center.emergencyStop();
  }

  panel_neural_run_button.onClicked: {
    groups.forEach(function(group) {
      xpider_center.saveGroupData(JSON.stringify(group));
    })
    xpider_center.sendGroupInfo();
    xpider_center.sendLearnInfo(sensor_list);
    xpider_center.sendRunData();
  }

//  Timer {
//    id: train_timer
//    interval: 1000
//    repeat: true
//    running: false

//    onTriggered: {
//      console.debug("Train timer triggered.")
//      xpider_center.learn(group_tab_bar.currentIndex+1, sensor_list);
//    }
//  }

  /* set group action grid model */
  function setActionGridModel(group_index) {
    if(action_grid_model.get(0).type !== "add_action") {
      action_grid_model.remove(0, action_grid_model.count-1);
    }
    for(var i=0; i<groups[group_index].action.length; i++) {
      action_grid_model.insert(i, {"type": groups[group_index].action[i].type});
    }
  }

  /* set action settings popup menu model*/
  function setSettingsModel(action_settings) {
    action_settings_model.clear();
    Object.keys(action_settings).forEach(function(k) {
      if(k !== "type") {
        action_settings_model.append({"key": k, "value": action_settings[k]});
      }
    });
  }

  /* update action settings */
  function updateActionSettings(group_index, action_index) {
    for(var i=0; i<action_settings_model.count; i++) {
      groups[group_index].action[action_index][action_settings_model.get(i).key] = action_settings_model.get(i).value;
    }

    console.debug("update action settings: ", group_index, ", ", action_index);
    console.debug(JSON.stringify(groups));
  }

  Component.onCompleted: {
    console.debug("Get sensor list: ", sensor_list)
    var raw_data = xpider_center.loadGroupFile()
    console.debug("Load group data: ", raw_data)
    if(raw_data !== "") {
      groups = JSON.parse(raw_data)
    }
  }

  Component.onDestruction: {
    xpider_center.emergencyStop()
    xpider_center.saveGroupFile(JSON.stringify(groups))
  }
}
