import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ListView {
    width: parent.width
    height: parent.height

    model: [
        { roomName: "Living Room", devices: ["Device 1", "Device 2", "Device 3"] },
        { roomName: "Bedroom 1", devices: ["Device A", "Device B", "Device C"] },
        { roomName: "Bedroom 2", devices: ["Device X", "Device Y", "Device Z"] }
    ]

    delegate: RoomListItem {
        height: 50
        width: parent.width

        itemData: model
    }
}
