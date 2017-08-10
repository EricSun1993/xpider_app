import QtQuick 2.4
import QtQuick.Controls 2.1

Page {
  id: page
  background: Rectangle {
    color: app_window.colorB
  }

  Image {
      id: image
      width: page.width * 0.165
      height: page.height * 0.293
      anchors.top: parent.top
      anchors.topMargin: parent.height * 0.15
      anchors.horizontalCenter: parent.horizontalCenter
      source: "qrc:/images/panel_settings_logo.png.png"
  }

  Text {
      id: text1
      text: "Xpider"
      opacity: 0.7
      anchors.top: parent.top
      anchors.topMargin: parent.height * 0.55
      anchors.horizontalCenter: parent.horizontalCenter
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      font.pointSize: 40
      style: Text.Raised
      font.family: font_bebas_neue_bold.name
      color: app_window.colorA
  }

  Text {
      id: text2
      text: "CopyRight© 2015-2017 Roboeve. All rights Reserved"
      opacity: 0.75
      font.family: "Courier"
      anchors.top: parent.top
      anchors.topMargin: parent.height * 0.9
      anchors.horizontalCenter: parent.horizontalCenter
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
      font.pixelSize: 13
      color: app_window.colorA
      font.weight: Font.Thin
  }
}
