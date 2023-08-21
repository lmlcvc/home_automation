import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtPositioning 5.15

RowLayout {
    id: dashboardWindow

    anchors.fill: parent
    spacing: 10

    property int currentRoomId: 0

    property string weatherDescription: ""
    property string weatherTemperature: ""
    
    property var locationData: "Geneva, Switzerland"     // TODO: fetch location
    // TODO: handle unknown location

    signal weatherDataUpdated(string description)
    onWeatherDataUpdated: {
        weatherData = description; // Update the description when the signal is received
    }

    signal dashboardCurrentRoomIdChanged(int roomId)
    onDashboardCurrentRoomIdChanged: {
        measurementModel.updateMeasurements(dashboardWindow.currentRoomId);
    }

    // AC control and current values
    ColumnLayout {
        spacing: 10
        Layout.alignment: Qt.AlignTop

        ListView {
            id: currentValues
            
            width: parent.width
            Layout.fillHeight: true

            model: measurementModel

            delegate: MeasurementListItem {
                width: parent.width
                height: 40
                itemData: model
            }
        }
    }

    // Graphs
    ColumnLayout {
        spacing: 10
        Layout.alignment: Qt.AlignCenter

        Rectangle {
            width: 200
            height: 200
            color: "lightblue"
        }
    }

    // Time, date, weather, and device list
    ColumnLayout {
        spacing: 10
        Layout.alignment: Qt.AlignTop

        Text {
            id: currentTimeText
            color: "white"
        }

        Text {
            text: "Date: " + getCurrentDate()
            color: "white"
        }

        Text {
            text: "Location: " + locationData
            color: "white"
            Component.onCompleted: fetchLocation() // Fetch the user's location on component completion
        }

        Text {
            text: (weatherTemperature != "unknown") ? ("Weather: " + weatherTemperature + ", " + weatherDescription) : "Weather: unknown"
            color: "white"
            Component.onCompleted: fetchWeather()
        }

        ListView {
            id: deviceController

            width: parent.width
            Layout.fillHeight: true

            model: deviceModel

            delegate: DeviceListItem {
                width: parent.width
                height: 40
                itemData: model
                roomIndex: currentRoomId
            }

            // TODO: turning device off modifies json
        }
    }

    // Right side buttons (room selection)
    ColumnLayout {
        id: rightTabBarContentLayout
        spacing: 3

        Layout.fillHeight: true
        Layout.preferredWidth: 100

        property int preferredButtonHeight: Math.min(dashboardWindow.height / roomModel.count, 100)

        Repeater {
            model: roomModel

            delegate: Button {
                text: model.roomName

                Layout.preferredWidth: 100
                Layout.preferredHeight: rightTabBarContentLayout.preferredButtonHeight

                property bool isSelected: model.roomId == dashboardWindow.currentRoomId

                background: Rectangle {
                    color: isSelected ? "lightgreen" : "white"
                }

                // Emit a signal when the room button is clicked
                onClicked: {       
                    console.log(dashboardWindow.height, roomModel.count, model.roomName);
                    // backend.roomClicked(model.roomId, model.roomName);

                    dashboardWindow.currentRoomId = model.roomId;
                    dashboardCurrentRoomIdChanged(roomModel.roomId);
                }
            }
        }
    }

    Timer {
        // FIXME: initialised but not updating
        id: dashboardUpdateTimer
        interval: 10000 // Update every 10 seconds
        repeat: true

        onTriggered: {
            updateTimeAndWeather();
            console.log("eeeeeee");
        }

        Component.onCompleted: {
            updateTimeAndWeather(); // Update immediately upon component completion
            console.log("timer initialised");
        }
    }

    function updateTimeAndWeather() {
        currentTimeText.text = "Time: " + getCurrentTime();

        if (new Date().getMinutes() == 0) {    // Update the weather every hour
            fetchWeather();
        }
    }
    
    // TODO: update regularly
    function getCurrentTime() {
        var currentTime = new Date();
        var hours = currentTime.getHours();
        var minutes = currentTime.getMinutes();
        
        // Format the time as HH:MM
        return (hours < 10 ? "0" : "") + hours + ":" + (minutes < 10 ? "0" : "") + minutes;
    }
    
    function getCurrentDate() {
        var currentDate = new Date();
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth() + 1;
        var day = currentDate.getDate();
        
        return day + "/" + (month < 10 ? "0" : "") + month + "/" + year;
    }

    function fetchWeather() {
        var weatherApiKey = "72a2a76b30dd2c83d3e9ca25905faa9c";     // TODO: store safely
        var weatherApiUrl = "http://api.openweathermap.org/data/2.5/weather?q=Geneva,Switzerland&appid=" + weatherApiKey;

        var request = new XMLHttpRequest();
        request.open("GET", weatherApiUrl);
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status === 200) {
                    var response = JSON.parse(request.responseText);

                    var description = response.weather[0].description;
                    var temperatureKelvin = response.main.temp;
                    var temperatureCelsius = (temperatureKelvin - 273.15).toFixed(2);

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
}
