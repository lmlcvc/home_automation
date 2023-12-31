import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15


Item {
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

                onToggled: {
                    var newState = checked ? "on" : "off";
                    backend.updateDeviceState(roomIndex, itemData.name, newState);
                }
            }

            Text {
                text: itemData.name
                color: colorBright
                Layout.fillWidth: true
            }
        }
    }
}
