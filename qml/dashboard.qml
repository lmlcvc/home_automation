import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    id: dashboardWindow

    anchors.fill: parent
    spacing: 10

    property int currentRoomId: 0

        // AC control and current values
        ColumnLayout {
            spacing: 10
            Layout.alignment: Qt.AlignTop

            Switch {
                id: acSwitch
                text: "AC"
            }

            ListView {
                id: currentValues
                
                width: parent.width
                Layout.fillHeight: true

                model: measurementModel

                delegate: MeasurementListItem {
                    width: parent.width
                    height: 40
                    itemData: model
                }
            }
        }

        // Graphs
        ColumnLayout {
            spacing: 10
            Layout.alignment: Qt.AlignCenter

            Rectangle {
                width: 200
                height: 200
                color: "lightblue"
            }
        }

        // Time, date, weather, and device list
        ColumnLayout {
            spacing: 10
            Layout.alignment: Qt.AlignTop

            Text {
                text: "Time: 10:00 AM"
                color: "white"
            }

            Text {
                text: "Date: June 17, 2023"
                color: "white"
            }

            Text {
                text: "Weather: Sunny"
                color: "white"
            }

            ColumnLayout {
                Repeater {
                    model: ["Device 1", "Device 2", "Device 3"]
                    delegate: Switch {
                        text: modelData
                        Layout.alignment: Qt.AlignLeft
                    }
                }
            }
        }


        // Right side buttons (room selection)
        ColumnLayout {
            id: rightTabBarContentLayout
            spacing: 3

            Layout.fillHeight: true
            Layout.preferredWidth: 100

            property int preferredButtonHeight: Math.min(dashboardWindow.height / roomModel.count, 100)


            Repeater {
                model: roomModel

                delegate: Button {
                text: model.roomName

                Layout.preferredWidth: 100
                Layout.preferredHeight: rightTabBarContentLayout.preferredButtonHeight

                property bool isSelected: model.roomId == dashboardWindow.currentRoomId

                background: Rectangle {
                    color: isSelected ? "lightgreen" : "white"
                }

                // Emit a signal when the room button is clicked
                onClicked: {
                    console.log(dashboardWindow.height, roomModel.count)
                    backend.roomClicked(roomId, roomName);
                    dashboardWindow.currentRoomId = model.roomId;
                }
            }
        }
    }
}
