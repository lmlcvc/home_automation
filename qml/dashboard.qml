import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtPositioning 5.15


RowLayout {
    id: dashboardWindow

    anchors.fill: parent
    spacing: 10

    property int currentRoomId

    property string weatherDescription: ""
    property string weatherTemperature: ""
    
    property var locationData: ""  
    property real latitude: -1
    property real longitude: -1

    signal dashboardCurrentRoomIdChanged(int roomId)
    onDashboardCurrentRoomIdChanged: {
        measurementModel.updateMeasurements(dashboardWindow.currentRoomId);
        deviceModel.updateDevices();
    }

    Component.onCompleted: {
        if (roomModel.count > 0 && currentRoomId == -1) {
            currentRoomId = roomModel.get(0).roomId;
            dashboardCurrentRoomIdChanged(currentRoomId);
        }

        loadCitiesData();
        retrieveLocationData();
        updateTimeAndWeather();
        fetchWeather();
    }

    // Current values
    ColumnLayout {
        spacing: 10
        Layout.alignment: Qt.AlignTop
        Layout.preferredWidth: 200

        Layout.leftMargin: 20
        Layout.topMargin: 20

        Text {
            id: titleMeasurements
            text: "MEASUREMENTS"
            font.pixelSize: 30
            color: colorBright
        }

        Rectangle {
            id: line1
            color: colorMain
            height: 1
            Layout.minimumWidth: 250
        }

        ListView {
            id: currentValues

            Layout.minimumHeight: count > 0 ? 200 : 0

            model: measurementModel

            onCountChanged: {
                if (count == 0) {
                    measurementsEmptyText.visible = true;
                } else {
                    measurementsEmptyText.visible = false;
                }
            }

            delegate: MeasurementListItem {
                Layout.fillWidth: true
                height: 40
                itemData: model
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 20
            visible: currentValues.count === 0

            Text {
                id: measurementsEmptyText
                text: "No measurements available"
                color: colorLightGrey
            }

            Text {
                id: devicesEmptyText
                text: "No devices available"
                color: colorLightGrey
            }
        }

        Rectangle {
            id: line2
            color: colorMain
            height: 1
            Layout.minimumWidth: 250
        }

        ListView {
            id: deviceController

            width: parent.width
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop

            model: deviceModel

            onCountChanged: {
                if (count == 0) {
                    devicesEmptyText.visible = true;
                    line2.visible = false;
                } else {
                    devicesEmptyText.visible = false;
                    line2.visible = true;
                }
            }

            delegate: DeviceListItem {
                Layout.fillWidth: true
                height: 40
                itemData: model
                roomIndex: currentRoomId
            }
        }
    }


    // Time, date, weather, and device list
    ColumnLayout {
        id: infoColumn

        spacing: 10
        Layout.alignment: Qt.AlignTop
        Layout.fillWidth: true

        Layout.topMargin: 20

        Text {
            text: "INFO"
            font.pixelSize: 30
            color: colorBright
        }

        Rectangle {
            color: colorMain
            height: 1
            Layout.minimumWidth: 250
        }

        Text {
            id: currentTimeText
            color: colorBright
            Layout.alignment: Qt.AlignBottom
            font.pixelSize: 26
        }

        Text {
            text: getCurrentDate()
            color: colorBright
            bottomPadding: 15
            font.pixelSize: 26
        }

        RowLayout {
            Text {
                text: "Location: "
                color: colorMain
            }

            ComboBox {
                id: cityComboBox

                Layout.preferredWidth: 200

                model: citiesModel
                displayText: cityComboBox.currentIndex === -1 ? "Select place" : locationData

                delegate: ItemDelegate {
                    contentItem: Text {
                        text: model.name
                        color: colorDarkGrey
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Component.onCompleted: {
                    if (locationData !== "") {
                        for (var i = 0; i < citiesModel.count; i++) {
                            var city = citiesModel.get(i);
                            if (city.name === locationData) {
                                cityComboBox.currentIndex = i;
                                break;
                            }
                        }
                    }
                }

                onActivated: {
                    var index = cityComboBox.currentIndex;
                    var selectedCity = citiesModel.get(index); 
                    if (selectedCity) {
                        latitude = parseFloat(selectedCity.latitude);
                        longitude = parseFloat(selectedCity.longitude);
                        locationData = selectedCity.name;
                        storeLocationData();
                        fetchWeather();
                    }
                }
            }
        }

        Text {
            text: (weatherTemperature != "unknown") ? ("<font color='lightgreen'>Weather:</font> " + weatherTemperature + ", " + weatherDescription) : "<font color='lightgreen'>Weather:</font> unknown"
            bottomPadding: 15
            color: colorBright
            Component.onCompleted: fetchWeather()
        }

        Button {
            id: buttonRefresh
            text: "Refresh all"
            Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
            
            onClicked: {
                refreshAllContent();
            }
        }
    }

    ScrollView {
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignTop | Qt.AlignRight

        ColumnLayout {
            id: rightTabBarContentLayout
            spacing: 3

            Layout.fillHeight: true

            property int preferredButtonHeight: Math.min(dashboardWindow.height / roomModel.count, 75)

            Repeater {
                model: roomModel

                delegate: Button {
                    text: model.roomName

                    Layout.preferredWidth: 100
                    Layout.preferredHeight: rightTabBarContentLayout.preferredButtonHeight

                    property bool isSelected: model.roomId == dashboardWindow.currentRoomId

                    background: Rectangle {
                        color: hovered ? colorAccent : (isSelected ? colorMain : colorBright)
                    }

                    onClicked: {       
                        dashboardWindow.currentRoomId = model.roomId;
                        dashboardCurrentRoomIdChanged(dashboardWindow.currentRoomId);
                        mainAppWindow.lastSelectedIndex = dashboardWindow.currentRoomId;
                    }
                }
            }
        }
    }


    function storeLocationData() {
        backend.addLocation(latitude, longitude, locationData);
    }

    function retrieveLocationData() {
        var location = backend.retrieveLocation();  
        latitude = location[0];  
        longitude = location[1]; 
        locationData = location[2];
    }

    function loadCitiesData() {
        var citiesData = backend.loadCitiesData();
        citiesModel.updateModel(citiesData)
    }

    function updateTimeAndWeather() {
        currentTimeText.text = getCurrentTime();

        if (new Date().getMinutes() == 0) {    // Update the weather every hour
            fetchWeather();
        }
    }
    
    function getCurrentTime() {
        var currentTime = new Date();
        var hours = currentTime.getHours();
        var minutes = currentTime.getMinutes();
        
        // Format the time as HH:MM
        return (hours < 10 ? "0" : "") + hours + ":" + (minutes < 10 ? "0" : "") + minutes + "<font color='lightgreen'> h</font>";
    }
    
    function getCurrentDate() {
        var currentDate = new Date();
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth() + 1;
        var day = currentDate.getDate();
        
        return day + "<font color='lightgreen'>/</font>" + (month < 10 ? "0" : "") + month + "<font color='lightgreen'>/</font>" + year;
    }

    function fetchWeather() {
        if(latitude == -1 || longitude == -1) {
            weatherDescription = "unknown";
            weatherTemperature = "unknown";
            return;
        }

        var weatherApiUrl = "http://api.openweathermap.org/data/2.5/weather?lat=" + latitude + "&lon=" + longitude + "&appid=" + weatherApiKey;

        var request = new XMLHttpRequest();
        request.open("GET", weatherApiUrl);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status === 200) {
                    var response = JSON.parse(request.responseText);

                    var description = response.weather[0].description;
                    var temperatureKelvin = response.main.temp;
                    var temperatureCelsius = (temperatureKelvin - 273.15).toFixed(0);

                    weatherDescription = description;
                    weatherTemperature = temperatureCelsius + " °C";
                } else {
                    weatherDescription = "unknown";
                    weatherTemperature = "unknown";
                    console.error("Error fetching weather data");
                }
            }
        }
        request.send();
    }

    function refreshAllContent() {
        updateTimeAndWeather();
        measurementModel.updateMeasurements(dashboardWindow.currentRoomId);
        deviceModel.updateDevices();
    }
}
