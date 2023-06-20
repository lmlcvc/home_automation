import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
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
                addRoomDialog.open()
            }
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
            id: list_rooms
            width: parent.width
            height: parent.height

            // Define the model as a ListModel
            model: roomListModel

            delegate: RoomListItem {
                width: parent.width
                height: 60
                itemData: model
            }
        }
    }

    Dialog {
    // FIXME adding a room. Not rendering and modelData is not defined
        id: addRoomDialog
        title: "Add Room"
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        ColumnLayout {
            TextField {
                id: roomNameField
                placeholderText: "Enter room name"
            }
        }

        onAccepted: {
            // Call a function to add the room with the entered name
            addRoom(roomNameField.text, []);
        }
    }

    // Define the roomListModel as a separate JavaScript object
    ListModel {
        id: roomListModel
    }

    function addRoom(roomName, devices) {
        // Create a new JavaScript object for the room
        var room = {
            roomName: roomName,
            devices: devices
        };

        // Add the room object to the model
        roomListModel.append(room);
    }

    // Initialize the model with default rooms
    Component.onCompleted: {
        addRoom("Living Room", ["Device 1", "Device 2", "Device 3"]);
        addRoom("Bedroom 1", ["Device A", "Device B", "Device C"]);
        addRoom("Bedroom 2", ["Device X", "Device Y", "Device Z"]);
    }
}
