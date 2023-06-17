import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    anchors.fill: parent
    spacing: 10
    Layout.fillWidth: true

    property int buttonSize: 36

    Repeater {
        model: [
            { roomName: "Living Room", devices: ["Device 1", "Device 2", "Device 3"] },
            { roomName: "Bedroom 1", devices: ["Device A", "Device B", "Device C"] },
            { roomName: "Bedroom 2", devices: ["Device X", "Device Y", "Device Z"] }
        ]

        delegate: ColumnLayout {
            width: parent.width
            spacing: 10
            Layout.fillWidth: true

            Rectangle {
                width: parent.width
                height: 1
                color: "white"
            }

            ColumnLayout {
                id: layout_room

                RowLayout {
                    spacing: 10
                    Layout.fillWidth: true

                    Text {
                        text: modelData.roomName
                        color: "white"
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
                    model: modelData

                    delegate: Repeater {
                        model: modelData.devices

                        delegate: Text {
                            text: modelData
                            color: "white"
                        }
                    }
                }
            }
        }
    }
}
