import QtQuick 2.0
import QtQuick.Controls 2.1

Popup {
  modal: true
  x: (app_window.width - width) / 2
  y: (app_window.height - height) / 2
  width: app_window.width / 1.5
  height: app_window.height / 1.5

  background: Rectangle{
    color: app_window.colorB
  }
}
