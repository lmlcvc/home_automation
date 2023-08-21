import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


ApplicationWindow {
    id: mainAppWindow

    // Set window dimensions and properties
    width: 1280
    height: 720
    minimumWidth: 640
    minimumHeight: 360
    visible: true
    title: "Home Automation"

    // Define color properties
    readonly property color colorGlow: "#1ddd14"
    readonly property color colorWarning: "#d5232f"
    readonly property color colorMain: "#6aff6a"
    readonly property color colorBright: "#ffffff"
    readonly property color colorLightGrey: "#888"
    readonly property color colorDarkGrey: "#333"

    // Set window background color
    color: "black"

    RowLayout {
        anchors.fill: parent
        spacing: 10

        // App control
        ScrollView {
            id: buttons_control
            Layout.fillHeight: true

            Container {
                id: leftTabBar

                currentIndex: 1

                Layout.fillWidth: false
                Layout.fillHeight: true

                ButtonGroup {
                    buttons: columnLayout.children
                }

                contentItem: ColumnLayout {
                    id: columnLayout
                    spacing: 3

                    Repeater {
                        model: leftTabBar.contentModel
                    }
                }

                FeatureButton {
                    id: featurebutton_control
                    text: qsTr("Dashboard")
                    icon.name: "dashboard"
                    Layout.fillHeight: true

                    checked: true

                    onClicked: {
                        contentLoader.source = "dashboard.qml"
                    }
                }

                FeatureButton {
                    text: qsTr("Security")
                    icon.name: "security"
                    Layout.fillHeight: true

                    onClicked: {
                        contentLoader.source = ""
                    }
                }

                FeatureButton {
                    text: qsTr("Settings")
                    icon.name: "settings"
                    Layout.fillHeight: true

                    onClicked: {
                        contentLoader.source = "settings.qml"
                    }
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
            var loadedList = backend.getDevicesForRoom(currentRoomId);
            deviceModel.updateModel(loadedList);
        }

        Component.onCompleted: {
            updateDevices();
        }

        // TODO: catch room updating signals?
    }

    MesurementListModel {
        id: measurementModel

        function updateMeasurements() {
            var loadedList = backend.loadMeasurements(currentRoomId);
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
