import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainAppWindow

    // Set window dimensions and properties
    width: 1280
    height: 720
    minimumWidth: 1180
    minimumHeight: 663
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
        ColumnLayout {
            id: buttons_control

            spacing: 10
            Layout.alignment: Qt.AlignTop

            Button {
                text: "Dashboard"
                onClicked: {
                    contentLoader.source = "dashboard.qml"
                }
            }

            Button {
                text: "Security"
            }

            Button {
                text: "Settings"
                onClicked: {
                    contentLoader.source = "settings.qml"
                    buttons_rooms.visible = false
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
            onSourceChanged: {
                buttons_rooms.visible = true
            }
        }

        // Right side buttons
        ColumnLayout {
            id: buttons_rooms

            spacing: 10
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            visible: contentLoader.source !== "settings.qml"

            Button {
                text: "Living room"
            }

            Button {
                text: "Bedroom 1"
            }

            Button {
                text: "Bedroom 2"
            }
        }
    }
}
