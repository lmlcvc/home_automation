import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3


Item {
    id: roomListItem

    Layout.fillWidth: true

    property var itemData: { }
    property int buttonSize: 36

    property string roomName: itemData.roomName || ""
    property var devices: itemData.devices
    property string selectedMeasurement: "temperature" // Default measurement

    Rectangle {
        id: background
        color: colorMain
        width: parent.width
        height: 60 
    }


    ColumnLayout {
        id: contentColumn
        width: parent.width
        spacing: 10
        Layout.fillWidth: true

        Rectangle {
            width: parent.width
            height: 2
            color: colorDarkGrey
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight  // Align the whole row to the right

            Text {
                text: roomName
                leftPadding: 15
                Layout.alignment: Qt.AlignLeft
            }

            RowLayout {
                id: buttonsContainer
                spacing: 10

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight

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

                    background: Rectangle {
                        color: "transparent"
                    }

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

                   background: Rectangle {
                        color: "transparent"
                    }

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
                    icon.source: "../images/manage.png"
                    Layout.alignment: Qt.AlignRight

                   background: Rectangle {
                        color: "transparent"
                    }

                    onClicked: {
                        manageRoomDevicesDialog.roomName = roomName;
                        manageRoomDevicesDialog.open();
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

            width: 500
            height: 400

            property string roomName: ""
            property string deviceName: ""
            property var devicesToRemove: []
            property var displayedDevices: devices
            property bool changesOccurred: false


            ColumnLayout {
                spacing: 10

                Button {
                    id: buttonAddDevice
                    text: "Add Device"
                    Layout.preferredWidth: manageRoomDevicesDialog.width - 40
                    Layout.alignment: Qt.AlignCenter
                    verticalPadding: 15
                    Layout.bottomMargin: 20

                    onClicked: {
                        addDeviceDialog.open();
                    }

                    background: Rectangle {
                        color: buttonAddDevice.hovered ? colorMain : colorAccent
                    }
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    width: parent.width
                    Layout.topMargin: 20
                    Layout.bottomMargin: 50

                    ListView {
                        id: deviceListView

                        width: parent.width
                        height: parent.height

                        spacing: 10

                        model: manageRoomDevicesDialog.displayedDevices

                        delegate: RowLayout {
                            Layout.fillWidth: true
                            height: 40

                            Text {
                                id: deviceNameText
                                Layout.preferredWidth: 350
                                Layout.alignment: Qt.AlignLeft
                                text: model.name + " (" + model.measurement + ")"
                                elide: Text.ElideRight	
                            }

                            Item {
                                width: 100
                                height: buttonDelete.implicitHeight
                                Layout.alignment: Qt.AlignRight

                                Button {
                                    id: buttonDelete
                                    text: "Delete"
                                    
                                    onClicked: {
                                        var deviceToDelete = model.name; 
                                        manageRoomDevicesDialog.devicesToRemove.push({ roomId: roomId, name: deviceToDelete });

                                        // Remove the device from the displayedDevices list
                                        for (var i = 0; i < manageRoomDevicesDialog.displayedDevices.count; i++) {
                                            if (manageRoomDevicesDialog.displayedDevices.get(i).name == deviceToDelete) {
                                                manageRoomDevicesDialog.displayedDevices.remove(i);
                                                break;
                                            }
                                        }
                                    }
                                }
                            }

                            Item {
                                Layout.fillWidth: true
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
                        measurement: manageRoomDevicesDialog.displayedDevices.get(i).measurement,
                        state: manageRoomDevicesDialog.displayedDevices.get(i).state
                    });
                }
                roomModel.devicesUpdated(itemData.roomId, updatedDevices);
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
                    newDeviceName = newDeviceNameField.text;
                    newDeviceMeasurement = measurementComboBox.currentText;

                    if (newDeviceName.trim() === "") {
                        showErrorMessage("Device name must not be empty.");
                    } else {
                        var newDevice = {
                            name: newDeviceName,
                            measurement: newDeviceMeasurement,
                            state: "off"
                        };
                        manageRoomDevicesDialog.displayedDevices.append(newDevice);
                    }
                    newDeviceNameField.text = "";
                }
            }
        }
    }
}
