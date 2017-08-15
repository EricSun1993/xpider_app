import QtQuick 2.4

PanelNeural1Form {
  id: root

  panel_neural_1_button.onClicked: {
    stack.push("qrc:/pages/PanelNeural2.qml")
  }
}
