import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Button {
    id: button

    checkable: true
    font.pixelSize: 14
    leftPadding: 4
    rightPadding: 4
    topPadding: 12
    bottomPadding: 12

    implicitHeight: 75
    implicitWidth: 120

    background: Rectangle {
        color: button.hovered ? colorAccent : (button.checked ? colorMain : colorBright)
    }

    contentItem: Text {
        text: button.text
        font: button.font
        color: "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}