import QtQuick 2.15

ListModel {
    id: deviceListModel

    property int currentRoomId: 0       // TODO: manage room ID

    function updateModel(deviceObjects, roomId) {
        deviceListModel.clear();

        deviceListModel.currentRoomId = roomId;

        for (var i = 0; i < deviceObjects.length; i++) {
            append(deviceObjects[i]);
        }
    }
}
