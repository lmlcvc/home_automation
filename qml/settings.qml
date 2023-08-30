import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15

ColumnLayout {
    id: settingsWindow
    Layout.preferredWidth: parent.width
    Layout.preferredHeight: parent.height

    RowLayout {
        id: top

        Layout.fillWidth: true
        Layout.topMargin: 15
        Layout.bottomMargin: 25
        Layout.leftMargin: 15
        Layout.rightMargin: 15

        Text {
            id: titleSettings
            text: "SETTINGS"
            font.pixelSize: 30
            color: colorBright
            Layout.preferredWidth: settingsWindow.width - 150
        }

        Button {
            id: button_add_room
            text: "ADD ROOM"
            Layout.preferredWidth: 100
            Layout.alignment: Qt.AlignRight
            verticalPadding: 15

            background: Rectangle {
                color: button_add_room.hovered ? colorAccent : colorLightGrey
            }

            MouseArea {
                width: parent.width
                height: parent.height
                cursorShape: button_add_room.hovered ? Qt.PointingHandCursor : Qt.ArrowCursor

                onClicked: {
                    addRoomDialog.open();
                }
            }
        }
    }

    ListView {
        id: list_rooms
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: parent.height

        model: roomModel

        delegate: RoomListItem {
            width: list_rooms.width
            height: 60
            itemData: model
        }
    }


    Dialog {
        id: addRoomDialog
        title: "Add Room"
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        width: 300
        height: 100

        ColumnLayout {
            TextField {
                id: roomNameField
                placeholderText: "Enter room name"
            }
        }

        onAccepted: {
            roomModel.addRoom(roomNameField.text, []);
        }
    }
}