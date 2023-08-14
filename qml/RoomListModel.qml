import QtQuick 2.15

ListModel {
    id: roomListModel

    signal roomClicked(string roomId, string roomName)
    signal addRoom(string roomName, string roomIcon)

//    function onAddRoom(roomId, roomName, roomIcon) {
//        // Logic to add a room to the list model
//        // You need to implement this according to your requirements
//    }
//
//    function onRoomClicked(roomId, roomName) {
//        // Logic to handle when a room is clicked
//        // You need to implement this according to your requirements
//    }

function updateModel(roomNames) {
    // Clear the existing model data
    roomListModel.clear()

    // Add the loaded data to the model
    for (var i = 0; i < roomNames.length; i++) {
        var roomObject = {
            roomName: roomNames[i]
        }
        roomListModel.append(roomObject)        
    }
}

}

