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

                Button {
                    text: "Add Device"
                    onClicked: {
                        addDeviceDialog.open();
                    }
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
                                    var deviceToDelete = model.name; 
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
                var updatedDevices = [];

                // Copy the devices from the displayedDevices list
                for (var i = 0; i < manageRoomDevicesDialog.displayedDevices.count; i++) {
                    updatedDevices.push({
                        name: manageRoomDevicesDialog.displayedDevices.get(i).name,
                        measurement: manageRoomDevicesDialog.displayedDevices.get(i).measurement
                    });
                }
                roomModel.devicesUpdated(itemData.roomId, updatedDevices);
                // XXX: Only emit the signal if there were changes
                // for example introduce a changesOccurred boolean to the dialog that will be set to true on any deviceList update
            }

            Dialog {
                id: addDeviceDialog
                title: "Add Device"
                standardButtons: StandardButton.Ok | StandardButton.Cancel

                property string newDeviceName: ""
                property string newDeviceMeasurement: "temperature" // Default measurement

                Dialog {
                    id: errorMessageDialog
                    title: "Error"
                    standardButtons: StandardButton.Ok

                    ColumnLayout {
                        Text {
                            id: errorMessageText
                        }
                    }
                }

                function showErrorMessage(message) {
                    errorMessageText.text = message;
                    errorMessageDialog.open();
                }

                ColumnLayout {
                    spacing: 10

                    TextField {
                        id: newDeviceNameField
                        placeholderText: "Enter new device name"
                        onTextChanged: {
                            if (newDeviceNameField.text.length > 30) {
                                newDeviceNameField.text = newDeviceNameField.text.substring(0, 30);
                            }
                        }
                    }

                    ComboBox {
                        id: measurementComboBox
                        model: ["temperature", "humidity", "air pressure", "brightness", "power consumption"]
                        currentIndex: measurementComboBox.model.indexOf(addDeviceDialog.newDeviceMeasurement)
                    }
                }

                onAccepted: {
                    var dialogDisplayedDevices = Array.from(manageRoomDevicesDialog.displayedDevices);
                    newDeviceName = newDeviceNameField.text;
                    newDeviceMeasurement = measurementComboBox.currentText;

                    if (newDeviceName.trim() === "") {
                        showErrorMessage("Device name must not be empty.");
                    } else if (dialogDisplayedDevices.some(function(device) { return device.name.toLowerCase() == newDeviceName.toLowerCase(); })) {  // FIXME: always false
                        showErrorMessage("Device name already exists in this room.");
                    } else {
                        var newDevice = {
                            name: newDeviceName,
                            measurement: newDeviceMeasurement
                        };
                        manageRoomDevicesDialog.displayedDevices.append(newDevice);
                    }
                    newDeviceNameField.text = "";
                }
            }
        }
    }
}
