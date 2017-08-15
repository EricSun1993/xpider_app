import QtQuick 2.4
import QtQuick.Controls 2.1

Item {
  id: page
  property alias panel_neural_1_button: panel_neural_1_button

  Label {
    id: panel_neural_1_label
    width: parent.width * 0.58
    height: parent.height * 0.2
    text: "In next page, you will choose the sensor you want, which will be used by Xpider to explorer the world.\n"
          + "The information will appear on the right when you tap the sensor."
    anchors.topMargin: 130
    color: app_window.colorA
    font.pointSize: 15
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.WordWrap
    font.family: "Arial"
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
  }

  Button {
    id: panel_neural_1_button
    width: parent.width * 0.139
    height: parent.height * 0.093
    anchors.bottom: parent.bottom
    anchors.bottomMargin: parent.height * 0.056
    anchors.right: parent.right
    anchors.rightMargin: parent.width * 0.063

    background: Image {
      anchors.fill: parent
      source: parent.pressed ? "qrc:/images/panel_neural_button_next_click.png" : "qrc:/images/panel_neural_button_next.png"
    }
  }
}
