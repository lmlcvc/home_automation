import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.LocalStorage 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "Country and City Selector"

    Rectangle {
        width: parent.width
        height: parent.height

        Column {
            spacing: 10
            anchors.centerIn: parent

            ComboBox {
                id: countryComboBox
                width: parent.width * 0.8
                model: countryModel
                textRole: "name"
                placeholderText: "Select a country..."
                onCurrentTextChanged: {
                    cityModel.clear();
                    if (countryComboBox.currentIndex >= 0) {
                        var selectedCountry = countryComboBox.currentText;
                        cityModel.append(cities[selectedCountry]);
                    }
                }
            }

            ComboBox {
                width: parent.width * 0.8
                model: cityModel
                textRole: "name"
                placeholderText: "Select a city..."
            }
        }
    }

    Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("placesData", "", "Places data", 1000000);
        var placesData = db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS places(key TEXT PRIMARY KEY, value TEXT)');
            var res = tx.executeSql('SELECT value FROM places WHERE key=?', ['data']);
            if (res.rows.length === 0) {
                var rawData = readFile("places_data.json");
                tx.executeSql('INSERT INTO places VALUES(?, ?)', ['data', rawData]);
                return rawData;
            } else {
                return res.rows.item(0).value;
            }
        });

        var countryData = JSON.parse(placesData);
        var countries = Object.keys(countryData);
        countryModel.clear();
        countryModel.append({ "name": "Select a country..." });
        for (var i = 0; i < countries.length; i++) {
            countryModel.append({ "name": countries[i] });
        }
    }

    ListModel {
        id: countryModel
        ListElement { "name": "Select a country..." }
    }

    ListModel {
        id: cityModel
    }
}
