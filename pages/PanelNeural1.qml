import QtQuick 2.4

PanelNeural1Form {
  id: root

  panel_nerual_1_button.onClicked: {
    stack.push("qrc:/pages/PanelNeural2.qml")
  }
}
