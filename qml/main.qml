import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../util"


ApplicationWindow {
    id: mainAppWindow

    readonly property color colorAccent: "mediumseagreen"
    readonly property color colorWarning: "red"
    readonly property color colorMain: "lightgreen"
    readonly property color colorBright: "#eeeeee"
    readonly property color colorLightGrey: "#888"
    readonly property color colorDarkGrey: "#111"

    // Set window dimensions and properties
    width: 1280
    height: 720
    minimumWidth: 640
    minimumHeight: 360
    visible: true
    title: "Home Automation"

    // Set window background color
    color: colorDarkGrey

    // App control
    RowLayout {
        id: appControl
        Layout.fillHeight: true

        ColumnLayout {
            id: leftTabBar

            Layout.fillWidth: false
            Layout.fillHeight: true

            ButtonGroup {
                id: featureButtonGroup
                buttons: columnLayout.children

                Component.onCompleted: {
                    // Set the first button as checked by default
                    if (buttons.length > 0) {
                        buttons[0].checked = true;
                    }
                }
            }

            FeatureButton {
                id: featurebutton_control
                text: qsTr("Dashboard")
                icon.name: "dashboard"
                Layout.fillHeight: true

                checked: true

                onClicked: {
                    featureButtonGroup.checkedButton = this;
                    contentLoader.source = "dashboard.qml"
                }
            }

            FeatureButton {
                text: qsTr("Management")
                icon.name: "management"
                Layout.fillHeight: true

                onClicked: {
                    featureButtonGroup.checkedButton = this;
                    contentLoader.source = "management.qml"
                }
            }

            FeatureButton {
                text: qsTr("Settings")
                icon.name: "settings"
                Layout.fillHeight: true

                onClicked: {
                    featureButtonGroup.checkedButton = this;
                    contentLoader.source = "settings.qml"
                }
            }
        }

        // Content area
        Loader {
            id: contentLoader
            Layout.fillWidth: true
            Layout.preferredWidth: mainAppWindow.width
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            source: "dashboard.qml"
        }
    }


    RoomListModel {
        id: roomModel

        function updateModelAfterAction() {
            var loadedList = backend.loadData();
            roomModel.updateModel(loadedList);
        }

        Component.onCompleted: {
            updateModelAfterAction();
        }

        onAddRoom: {
            backend.addRoom(roomName);
            updateModelAfterAction();
        }

        onRoomEdited: {
            backend.editRoom(roomId, newRoomName);
            updateModelAfterAction();
        }

        onRoomDeleted: {
            backend.deleteRoom(roomId);
            updateModelAfterAction();
        }

        onDeviceAdded: {
            backend.addDevice(roomId, deviceName, measurement);
            updateModelAfterAction();
        }

        onDeviceRemoved: {
            backend.removeDevice(roomId, deviceName);
            updateModelAfterAction();
        }

        onDevicesUpdated: {
            backend.updateDevices(roomId, devices);
            updateModelAfterAction();
        }
    }

    DeviceListModel {
        id: deviceModel

        function updateDevices() {
            var loadedList = backend.getDevicesForRoom(contentLoader.item.currentRoomId);
            deviceModel.updateRoomId(contentLoader.item.currentRoomId);
            deviceModel.updateModel(loadedList);
        }

        Component.onCompleted: {
            updateDevices();
        }

        // TODO: catch room updating signals?
    }

    // TODO: update measurements as they're incoming
    MesurementListModel {
        id: measurementModel

        function updateMeasurements() {
            var loadedList = backend.loadMeasurements(contentLoader.item.currentRoomId);
            measurementModel.updateRoomId(contentLoader.item.currentRoomId);
            measurementModel.updateModel(loadedList);
        }

        Component.onCompleted: {
            updateMeasurements();
        }

        onMeasurementUpdated: {
            backend.updateMeasurement(roomId, measurementName, measurementValue);
            updateMeasurements();
        }
    }
}
