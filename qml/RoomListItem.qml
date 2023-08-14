import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3


Item {
    width: parent.width 

    property var itemData: { }
    property int buttonSize: 36

    property string roomName: itemData.roomName
    property var devices: itemData.devices

    Rectangle {
        id: background
        color: "#6aff6a"
        width: parent.width
        height: 60 // contentColumn.height
    }


    ColumnLayout {
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
            Layout.fillWidth: true

            Text {
                text: roomName
            }


            RowLayout {
                spacing: 10

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
                        editRoomDialog.open()
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
                    icon.source: "../images/expand.png"
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        deviceListView.visible = !deviceListView.visible
                    }
                }
            }

        }

        Dialog {
            id: editRoomDialog
            title: "Edit Room"
            standardButtons: StandardButton.Ok | StandardButton.Cancel

            width: 300
            height: 100

            ColumnLayout {
                TextField {
                    id: newRoomNameField
                    placeholderText: "Enter new room name"
                }
            }

            onAccepted: {
                roomModel.roomEdited(itemData.roomId, newRoomNameField.text);
                roomModel.updateModel(newRoomNameField.text);
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
    }
}
