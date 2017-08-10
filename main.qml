import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.1

import "components"

ApplicationWindow {
  id: app_window
  title: "Xpider"

  property bool xpider_enable: false

  property color colorA: "#00FFDA"
  property color colorB: "#363d46"
  property real screen_scale: app_window.width / 1920

  ListModel {
    id: menu_model_list
    ListElement {
      title: "FPV";
      force_disalbe: false;
      need_conntection: false;
      icon: "qrc:/images/panel_menu_game_icon.png"
      source: "qrc:/pages/PanelFPV.qml"
    }
    ListElement {
      title: "NAVIGATION";
      force_disalbe: false;
      need_conntection: true;
      icon: "qrc:/images/panel_menu_navigation_icon.png"
      source: "qrc:/pages/PanelMap.qml"
    }
    ListElement {
      title: "SENSOR INFO";
      force_disalbe: false;
      need_conntection: true;
      icon: "qrc:/images/panel_menu_parameter_icon.png"
      source: "qrc:/pages/PanelParameter.qml"
    }
    ListElement {
      title: "ADD FACE";
      force_disalbe: false;
      need_conntection: true;
      icon: "qrc:/images/panel_menu_face_recognition_icon.png"
      source: "qrc:/pages/FaceTrain.qml"
    }
    ListElement {
      title: "NEURAL";
      force_disalbe: false;
      need_conntection: true;
      icon: "qrc:/images/panel_menu_neural_network_icon.png"
      source: "qrc:/pages/PanelNeural.qml"
    }
    ListElement {
      title: "SETTINGS";
      force_disalbe: false;
      need_conntection: true;
      icon: "qrc:/images/panel_menu_settings_icon.png"
      source: "qrc:/pages/PanelSettings.qml"
    }
    ListElement {
      title: "ABOUT";
      force_disalbe: false;
      need_conntection: false;
      icon: "qrc:/images/panel_menu_settings_icon.png"
      source: "qrc:/pages/PanelAbout.qml"
    }
  }

  FontLoader {
    id: font_bebas_neue_bold
    source: "qrc:/fonts/BebasNeue_Bold.otf"
  }

  FontLoader {
    id: font_bebas_neue_book
    source: "qrc:/fonts/BebasNeue_Book.otf"
  }

  FontLoader {
    id: font_bebas_neue_light
    source: "qrc:/fonts/BebasNeue_Light.otf"
  }

  FontLoader {
    id: font_bebas_neue_regular
    source: "qrc:/fonts/BebasNeue_Regular.otf"
  }

  FontLoader {
    id: font_bebas_neue_thin
    source: "qrc:/fonts/BebasNeue_Thin.otf"
  }

  Button {
    id: button
    width: app_window.height * 0.15
    height: app_window.height * 0.15
    z: 2
    text: ""
    anchors.left: parent.left
    anchors.leftMargin: 0
    anchors.top: parent.top
    anchors.topMargin: 0

    background: Image {
      width: app_window.width * 0.035
      height: app_window.height * 0.045
      anchors.centerIn: parent
      source: "qrc:/images/component_menu.png"
    }

    onClicked: {
      drawer.open();
    }
  }

  Drawer {
    id: drawer
    width: Math.min(app_window.width, app_window.height) / 3 * 2
    height: app_window.height

    Rectangle {
      anchors.fill: parent
      color: app_window.colorA

      ListView {
        id: listView
        focus: true
        currentIndex: -1
        anchors.fill: parent
        headerPositioning: ListView.PullBackHeader

        model: menu_model_list

        delegate: ItemDelegate {
          width: parent.width
          height: app_window.height * 0.21
          enabled: !model.force_disalbe
          highlighted: ListView.isCurrentItem

          Image {
            id: menu_item_icon
            width: parent.width * 0.132
            height: parent.height * 0.335
            source: model.icon
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.1
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            text: model.title
            width: contentWidth
            height: contentHeight
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: parent.height * 0.03
            font.pointSize: 20
            font.family: font_bebas_neue_regular.name
            color: app_window.colorB
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
          }

          onClicked: {
            // console.debug(page_loader.source);
            // console.debug(model.source);
            if(page_loader.source.toString() !== model.source) {
              page_loader.setSource(model.source);
              console.debug("Xpider Menu: different page, do change")
            } else {
              console.debug("Xpider Menu: same page, do nothing")
            }

            drawer.close();
          }
        }

        header: Component {
          id: list_view_header

          Rectangle {
            color: app_window.colorB
            width: parent.width
            height: app_window.height * 0.15

            Button {
              id: list_view_header_button
              width: parent.width * 0.225
              height: parent.height
              anchors.top: parent.top
              anchors.right: parent.right
              z: 2

              background: Image {
                anchors.centerIn: parent
                width: parent.width * 0.42
                height: parent.height * 0.302
                source: "qrc:/images/component_menu.png"
              }

              onClicked: {
                drawer.close();
              }
            }
          }
        }
        ScrollIndicator.vertical: ScrollIndicator { }
      }
    }

    onClosed: {
      listView.positionViewAtBeginning();
    }
  }

  XDialog {
    id: app_dialog

    Text {
      anchors.centerIn: parent
      width: parent.width * 0.9
      id: dialog_text

      text:"Can not connect to the Xpider, please check wifi connection and xpider power, then try again."
      color: app_window.colorA
      font.pointSize: 18
      horizontalAlignment: Text.AlignHCenter
      wrapMode: Text.Wrap
    }
  }

  Loader {
    id: page_loader
    anchors.fill: parent

    source: "qrc:/pages/PanelFPV.qml"
  }

  Connections {
    target: xpider_center

    /* 设备已经连接上 */
    onDeviceConnected: {
      xpider_enable = true;
      xpider_center.getXpiderInfo();
      app_dialog.close();
      console.debug("Xpider connected!");
    }

    /* 设备连接断开 */
    onDeviceDisconnected: {
      xpider_enable = false;
      app_dialog.open();
      xpider_center.connectXpider();
      console.debug("Device disconnected.");
    }
  }

  Component.onCompleted: {
    xpider_center.connectXpider();
  }
}
