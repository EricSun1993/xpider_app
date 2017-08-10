import QtQuick 2.4

Item {
  property alias component_ddi_mousearea: component_ddi_mousearea
  property alias component_ddi_text: component_ddi_text

    Image {
      id: component_ddi_image
      x: 11 * app_window.screen_scale
      y: 22 * app_window.screen_scale
      width: 96 * app_window.screen_scale
      height: 118 * app_window.screen_scale
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 0
      source: "qrc:/images/panel_map_radar_icon_xpider.png"
    }

    Text {
        id: component_ddi_text
        x: 11 * app_window.screen_scale
        y: 8 * app_window.screen_scale
        width: 162 * app_window.screen_scale
        height: 31 * app_window.screen_scale
        color: app_window.colorA
        text: qsTr("Unknown")
        font.bold: false
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: font_bebas_neue_regular.name
        font.pointSize: 12
    }

    MouseArea {
      id: component_ddi_mousearea
      anchors.fill: parent
    }
}
