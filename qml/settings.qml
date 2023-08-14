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

            model: roomModel

            delegate: RoomListItem {
                width: parent.width
                height: 60
                itemData: model
            }
        }
    }

    Dialog {
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
            // Emit the addRoom signal with the entered room name and icon
            roomModel.addRoom(roomNameField.text, "new-icon");      
            roomModel.updateModel(roomNameField.text);
        }
    }
}