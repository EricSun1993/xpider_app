import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1

Page {
  id: page

  background: Image {
    source: "qrc:/images/panel_fpv_background.png"
  }

  StackView {
    id: stack
    anchors.fill: parent
    initialItem: "qrc:/pages/PanelNeural1.qml"
  }

}
