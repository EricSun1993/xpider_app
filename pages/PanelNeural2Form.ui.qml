import QtQuick 2.4
import QtQuick.Controls 2.0
import "../components"

Item {
  property alias sensor_description_label: sensor_description_label
  property alias panel_neural_2_gridview: panel_neural_2_gridview
  property alias panel_neural_2_button: panel_neural_2_button

  id: page

  GridView {
    id: panel_neural_2_gridview
    width: page.width * 0.465
    height: page.height * 0.653
    anchors.leftMargin: page.width * 0.06
    anchors.topMargin: page.height * 0.12
    anchors.top: parent.top
    anchors.left: parent.left
    cellWidth: parent.width * 0.130
    cellHeight: parent.width * 0.231
  }

  Button {
    id: panel_neural_2_button
    width: page.width * 0.139
    height: page.height * 0.093
    anchors.bottom: page.bottom
    anchors.bottomMargin: page.height * 0.056
    anchors.right: page.right
    anchors.rightMargin: page.width * 0.063

    background: Image {
      anchors.fill: parent
      source: parent.pressed ? "qrc:/images/panel_neural_button_next_click.png" : "qrc:/images/panel_neural_button_next.png"
    }
  }

  Label {
    id: sensor_description_label
    x: 446
    width: 250
    height: 245
    text: qsTr("Label")
    anchors.top: parent.top
    anchors.topMargin: 45
    anchors.right: parent.right
    anchors.rightMargin: 30
    color: app_window.colorA
    font.pointSize: 15
    horizontalAlignment: Text.AlignLeft
    wrapMode: Text.WordWrap
    font.family: "Arial"
  }

  Row {
    id: row
    anchors.bottomMargin: 25
    anchors.leftMargin: 40
    anchors.bottom: page.bottom
    anchors.left: page.left
    spacing: 5

    Image {
      id: image
      width: page.width * 0.042
      height: page.height * 0.074
      source: "qrc:/images/panel_neural_icon_notation.png"
    }

    Label {
      id: label
      width: page.width * 0.53
      text: qsTr("Once you chosen sensor, the sensors list will not be changed in this learning cycle")
      color: app_window.colorA
      font.pointSize: 13
      horizontalAlignment: Text.AlignLeft
      wrapMode: Text.WordWrap
      font.family: "Arial"
    }
  }
}
