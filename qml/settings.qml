import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    width: parent.width
    height: parent.height

    RowLayout {
        id: top

        Text {
            id: title
            text: "Settings"
            font.pixelSize: 20
            color: "#eeeeee"
        }

        Button {
            id: button_add_room
            width: 46
            height: 46
            implicitWidth: width
            implicitHeight: height
            icon.width: width
            icon.height: height
            icon.source: "../images/add.png"
            Layout.alignment: Qt.AlignLeft
            onClicked: {
                // Handle edit button clicked
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
        // FIXME Only first item of rooms and devices are displayed
            id: list_rooms
            width: parent.width
            height: parent.height

            model: [
                { roomName: "Living Room", devices: ["Device 1", "Device 2", "Device 3"] },
                { roomName: "Bedroom 1", devices: ["Device A", "Device B", "Device C"] },
                { roomName: "Bedroom 2", devices: ["Device X", "Device Y", "Device Z"] }
            ]

            delegate: RoomListItem {
                width: parent.width
                height: 60
                itemData: model
            }
        }
    }
}
