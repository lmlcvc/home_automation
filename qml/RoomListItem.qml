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
            // FIXME: make devices list scrollable
            // FIXME: align delete button to right
            // TODO: limit max. device name length
            id: manageRoomDevicesDialog
            title: "Manage Devices"
            standardButtons: StandardButton.Ok | StandardButton.Cancel

            width: 400
            height: 400

            property string roomName: ""
            property string deviceName: ""
            property var devicesToRemove: []
            property var displayedDevices: devices

            ColumnLayout {
                spacing: 10

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

                ListView {
                    id: deviceListView
                    width: parent.width
                    height: 200
                    // Layout.fillHeight: true

                    model: manageRoomDevicesDialog.displayedDevices

                    delegate: Item {
                        width: parent.width
                        height: 36

                        RowLayout {
                            Text {
                                text: model.name
                            }

                            Text {
                                text: "(" + model.measurement + ")"
                            }

                            Button {
                                text: "Delete"
                                onClicked: {
                                    var deviceToDelete = model.name; // Store the name of the device to delete
                                    manageRoomDevicesDialog.devicesToRemove.push({ roomId: roomId, name: deviceToDelete });

                                    // Remove the device from the displayedDevices list
                                    for (var i = 0; i < manageRoomDevicesDialog.displayedDevices.count; i++) {
                                        if (manageRoomDevicesDialog.displayedDevices.get(i).name === deviceToDelete) {
                                            manageRoomDevicesDialog.displayedDevices.remove(i);
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            onAccepted: {
                if (newDeviceNameField.text.trim() !== "") {
                    var newDevice = {
                        name: newDeviceNameField.text,
                        measurement: measurementComboBox.currentText
                    };
                    roomModel.deviceAdded(itemData.roomId, newDevice.name, newDevice.measurement);
                }

                for (var i = 0; i < devicesToRemove.length; i++) {
                    roomModel.deviceRemoved(manageRoomDevicesDialog.devicesToRemove[i].roomId, manageRoomDevicesDialog.devicesToRemove[i].name);
                }
            }
        }


        Rectangle {
            width: parent.width
            height: 20 
            color: "transparent"
        }

        /*ListView {
            id: deviceListView
            width: parent.width
            visible: false // Start with the device list hidden
            model: devices

            delegate: Text {
                text: itemData.devices.name 
                color: "white"
            }
        }*/
    }
}
