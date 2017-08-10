import QtQuick 2.4

Item {
  property alias item_image: item_image
  property alias item_mouse_area: item_mouse_area

  Image {
    id: item_image
    width: app_window.width * 0.091
    height: app_window.height * 0.162
  }

  MouseArea {
    id: item_mouse_area
    anchors.fill: item_image
  }
}
