import QtQuick 2.15

ListModel {
    id: deviceListModel

    property int currentRoomId: 0

    function updateModel(deviceObjects) {
        deviceListModel.clear() // Clear the model before adding new items

        for (var i = 0; i < deviceObjects.length; i++) {
            append(deviceObjects[i])
        }
    }
}
