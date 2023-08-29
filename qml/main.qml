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

    property int lastSelectedIndex: -1

    // Set window dimensions and properties
    width: 1280
    height: 720
    minimumWidth: 940
    minimumHeight: 360
    visible: true
    title: "Home Automation"

    // Set window background color
    color: colorDarkGrey

    // App control
    RowLayout {
        id: appControl
        
        width: parent.width
        height: parent.height

        ColumnLayout {
            id: leftTabBar

            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop

            FeatureButton {
                id: featurebutton_control
                text: qsTr("Dashboard")
                icon.name: "dashboard"

                onClicked: {
                    featureButtonGroup.checkedButton = this;
                    contentLoader.source = "dashboard.qml";
                    contentLoader.item.currentRoomId = lastSelectedIndex;
                }
            }

            FeatureButton {
                text: qsTr("Settings")
                icon.name: "settings"

                onClicked: {
                    featureButtonGroup.checkedButton = this;
                    contentLoader.source = "settings.qml";
                }
            }
        }

        ButtonGroup {
            id: featureButtonGroup
            buttons: leftTabBar.children

            Component.onCompleted: {
                // Set the first button as checked by default
                if (buttons.length > 0) {
                    buttons[0].checked = true;
                }
            }
        }

        // Content area
        Loader {
            id: contentLoader
            Layout.fillHeight: true
            Layout.fillWidth: true
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
    }

    MesurementListModel {
        id: measurementModel

        function updateMeasurements() {
            var loadedList = backend.loadMeasurements(contentLoader.item.currentRoomId);
            measurementModel.updateRoomId(contentLoader.item.currentRoomId);
            measurementModel.updateModel(loadedList);
        }

        Component.onCompleted: {
            updateMeasurements();
            backend.measurementsUpdated.connect(updateMeasurements);
        }
    }

    ListModel {
        id: citiesModel

        function updateModel(cityObjects)
        {
            citiesModel.clear()

            for (var i = 0; i < cityObjects.length; i++) {
                citiesModel.append(cityObjects[i])
            }
        }
    }
}
