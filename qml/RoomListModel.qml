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

}
