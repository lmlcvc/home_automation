import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    width: parent.width
    height: 60

    property var itemData: {}
    property int buttonSize: 36

    Rectangle {
        id: background
        color: "#6aff6a"
        width: parent.width
        height: 60 // contentColumn.height
    }

    property string roomName: itemData.roomName
    property var devices: itemData.devices

    Rectangle {
    width: parent.width
    height: 60

    Text {
        text: itemData.roomName // Assuming roomName is a property in itemData
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        leftPadding: 10
        }
    }


    /*ColumnLayout {
        id: contentColumn
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
                text: modelData // Display the actual item from the device list
                color: "white"
            }
        }
    }*/

    // Bind itemData property to itemData in delegate item
    Binding {
        target: itemData
        property: "roomName"
        value: roomName
    }
}
