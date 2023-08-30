import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    property var itemData: { }

    property string measurementName: itemData.name
    property string measurementValue: itemData.value

    RowLayout {
        width: parent.width
        spacing: 10
        Layout.fillWidth: true

        RowLayout {
            Layout.fillWidth: true

            Text {
                Layout.minimumWidth: 120
                text: measurementName
                color: colorBright
            }

            Text {
                text: measurementValue
                color: measurementValue.toLowerCase().includes("err") ? colorWarning : colorMain
            }
        } 
    }
}
