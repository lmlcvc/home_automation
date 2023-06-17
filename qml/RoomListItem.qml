import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    property var itemData: {}
    property int buttonSize: 36

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#6aff6a"
    }

    property string roomName: modelData.roomName
    property var devices: modelData.devices

    Component.onCompleted: {
        console.log("Room Name:", roomName);
        console.log("Devices:", devices);
    }

    ColumnLayout {
        width: parent.width
        spacing: 10
        Layout.fillWidth: true

        Rectangle {
            width: parent.width
            height: 1
            color: "white"
        }

        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            Text {
                text: roomName
            }

            Button {
                id: button_edit
                width: buttonSize
                height: buttonSize
                implicitWidth: width
                implicitHeight: height
                icon.width: width
                icon.height: height
                icon.source: "../images/edit.png"
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    // Handle edit button clicked
                }
            }

            Button {
                id: button_delete
                width: buttonSize
                height: buttonSize
                implicitWidth: width
                implicitHeight: height
                icon.width: width
                icon.height: height
                icon.source: "../images/delete.png"
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    // Handle delete button clicked
                }
            }

            Button {
                id: button_expand
                width: buttonSize
                height: buttonSize
                implicitWidth: width
                implicitHeight: height
                icon.width: width
                icon.height: height
                icon.source: "../images/expand.png" // Use the appropriate expand icon
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    deviceListView.visible = !deviceListView.visible
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 20 // Adjust the spacing as needed
            color: "transparent"
        }

        ListView {
            id: deviceListView
            width: parent.width
            visible: false // Start with the device list hidden
            model: devices

            delegate: Text {
                text: modelData // Access each device string
                color: "white"
            }
        }
    }

    // Bind itemData property to modelData in delegate item
    Binding {
        target: itemData
        property: "modelData"
        value: modelData
    }
}
