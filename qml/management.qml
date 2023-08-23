import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


RowLayout {
        width: parent.width
        height: parent.height
        
        ListModel {
            id: countryModel
            ListElement { "name": "United States" }
            ListElement { "name": "Canada" }
            ListElement { "name": "Australia" }
            // Add more countries here...
        }

        ListModel {
            id: cityModel
        }

        Column {
            spacing: 10
            anchors.centerIn: parent

            ComboBox {
                width: parent.width * 0.8
                model: countryModel
                textRole: "name"
                onCurrentTextChanged: {
                    updateCityModel(currentText);
                }
            }

            ComboBox {
                id: cityComboBox
                width: parent.width * 0.8
                model: cityModel
                textRole: "name"
            }
        }

    function updateCityModel(selectedCountry) {
        cityModel.clear();

        // Dummy data for demonstration
        if (selectedCountry === "United States") {
            cityModel.append({ "name": "New York" });
            cityModel.append({ "name": "Los Angeles" });
            cityModel.append({ "name": "Chicago" });
        } else if (selectedCountry === "Canada") {
            cityModel.append({ "name": "Toronto" });
            cityModel.append({ "name": "Vancouver" });
            cityModel.append({ "name": "Montreal" });
        } else {
            cityModel.append({ "name": "Select a country first" });
        }
    }
}
