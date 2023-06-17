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
            spacing: 10
            Layout.alignment: Qt.AlignTop

            Button {
                text: "Home"
            }

            Button {
                text: "Dashboard"
                onClicked: {
                    contentLoader.source = "dashboard.qml"
                }
            }

            Button {
                text: "Statistics"
            }

            Button {
                text: "Security"
            }

            Button {
                text: "Settings"
                onClicked: {
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
            source: "settings.qml"
        }

        // Right side buttons
        ColumnLayout {
            spacing: 10
            Layout.alignment: Qt.AlignTop | Qt.AlignRight

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
