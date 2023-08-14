import QtQuick 2.15

ListModel {
    id: roomListModel

    signal roomClicked(string roomId, string roomName)
    signal addRoom(string roomName, string roomIcon)        // FIXME: no room icon
    signal roomEdited(int roomId, string newRoomName)


    function updateModel(roomNames)
    {
        roomListModel.clear()

        for (var i = 0; i < roomNames.length; i++) {
            var roomObject = {
                roomName: roomNames[i]
            }
            roomListModel.append(roomObject)
        }
    }
}

