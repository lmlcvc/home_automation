import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15


Item {
    width: parent.width

    property var itemData: { }
    property int roomIndex: -1

    ColumnLayout {
        width: parent.width
        spacing: 10
        Layout.fillWidth: true

        RowLayout {
            spacing: 10

            Switch {
                Layout.alignment: Qt.AlignLeft
                checked: itemData.state.toLowerCase() === "on"
            }

            Text {
                text: itemData.name
                color: "white"
                Layout.fillWidth: true
            }
        }
    }
}
