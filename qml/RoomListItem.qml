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
    property string selectedMeasurement: "temperature" // Default measurement

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
                        deleteRoomDialog.roomName = roomName;
                        deleteRoomDialog.open();
                    }
                }

                Button {
                    id: button_manage
                    width: buttonSize
                    height: buttonSize
                    implicitWidth: width
                    implicitHeight: height
                    icon.width: width
                    icon.height: height
                    icon.source: "../images/add.png"        // TODO: some other img
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        manageRoomDevicesDialog.roomName = roomName;
                        manageRoomDevicesDialog.open();
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
            }
        }

        Dialog {
            id: deleteRoomDialog
            title: "Delete Room" 
            standardButtons: StandardButton.Ok | StandardButton.Cancel

            width: 300
            height: 100 

            property string roomName: ""

            ColumnLayout {
                Text {
                    text: "Delete " + roomName + "?"
                }
            }

            onAccepted: {
                roomModel.roomDeleted(itemData.roomId);
            }
        }

        Dialog {
            id: manageRoomDevicesDialog
            title: "Manage Devices"
            standardButtons: StandardButton.Ok | StandardButton.Cancel

            width: 300
            height: 100

            property string roomName: ""
            property string deviceName: ""
            

            ColumnLayout {
                Text {
                    text: "Enter new device for " + roomName
                }

                TextField {
                    id: newDeviceNameField
                    placeholderText: "Enter new device name"
                }

                ComboBox {
                    id: measurementComboBox
                    model: ["temperature", "humidity", "air pressure", "brightness", "power consumption"]
                    currentIndex: measurementComboBox.model.indexOf(selectedMeasurement)
                }
            }

            onAccepted: {
                var newDevice = {
                    deviceName: newDeviceNameField.text,
                    measurement: measurementComboBox.currentText
                }
                devices.push(newDevice)
                // TODO: Update backend with the new device information
            }
        }


        Rectangle {
            width: parent.width
            height: 20 
            color: "transparent"
        }

        ListView {
            id: deviceListView
            width: parent.width
            visible: false // Start with the device list hidden
            model: devices

            delegate: Text {
                text: modelData 
                color: "white"
            }
        }
    }
}
