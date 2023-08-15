import QtQuick 2.15

ListModel {
    id: roomListModel

    signal addRoom(string roomName, var devices)
    signal roomEdited(int roomId, string newRoomName)
    signal roomDeleted(int roomId)

    signal deviceAdded(int roomId, string deviceName, string measurement)
    signal deviceRemoved(int roomId, string deviceName)

    function updateModel(roomObjects)
    {
        roomListModel.clear()

        for (var i = 0; i < roomObjects.length; i++) {
            roomListModel.append(roomObjects[i])
        }
    }
}

