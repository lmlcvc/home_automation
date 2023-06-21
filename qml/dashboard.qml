import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


RowLayout {
anchors.fill: parent
spacing: 10

    // AC control and current values
    ColumnLayout {
        spacing: 10
        Layout.alignment: Qt.AlignTop

        Switch {
            id: acSwitch
            text: "AC"
        }

        ColumnLayout {
            Repeater {
                model: ["Temperature: 24°C", "Humidity: 50%", "Air Pressure: 1015 hPa", "Brightness: 80%", "Power Usage: 100W"]
                delegate: Text {
                    text: modelData
                    color: "white"
                }
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

     // Right side buttons
    ScrollView {
        id: buttons_rooms
        Layout.fillHeight: true
        visible: false  // Initially hidden

        Container {
            id: rightTabBar

            currentIndex: 1

            Layout.fillHeight: true

            ButtonGroup {
                buttons: rightTabBarContentLayout.children
            }

            contentItem: ColumnLayout {         // FIXME model data not displaying. loaded properly into backend
                id: rightTabBarContentLayout
                spacing: 3

                Repeater {
                    model: roomModel // Bind the model to the Repeater
                    delegate: FeatureButton {
                        text: model.roomName // Display the room name
                        icon.name: model.roomIcon
                        Layout.maximumHeight: featurebutton_control.height
                        Layout.fillHeight: true

                        // Emit a signal when the room button is clicked
                        onClicked: {
                            roomClicked(model.roomId, model.roomName)
                        }
                    }
                }
            }
        }
    }
}
