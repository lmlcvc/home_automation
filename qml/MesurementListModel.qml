import QtQuick 2.15

ListModel {
    id: measurementListModel

    signal measurementUpdated(int roomId, string measurementName, string measurementValue)

    function updateModel(measurementObjects)
    {
        measurementListModel.clear()

        for (var i = 0; i < measurementObjects.length; i++) {
            measurementListModel.append(measurementObjects[i])
        }
    }
}


