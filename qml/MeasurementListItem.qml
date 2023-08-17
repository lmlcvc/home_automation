import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3


Item {
    width: parent.width 

    property var itemData: { }

    property string measurementName: itemData.measurementName
    property string measurementValue: itemData.measurementValue

    RowLayout {
        width: parent.width
        spacing: 10
        Layout.fillWidth: true

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: measurementName
            }

            Text {
                text: measurementValue
            }
        }
    }
}
