import QtQuick 2.15

ListModel {
    id: deviceListModel

    property int currentRoomId: -1 

    function updateModel(deviceObjects) {
        deviceListModel.clear();

        for (var i = 0; i < deviceObjects.length; i++) {
            append(deviceObjects[i]);
        }
    }

    function updateRoomId(roomId) {
        currentRoomId = roomId;
    }
}
