import json
import os
import datetime
import configparser

from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal


class Backend(QObject):
    dataLoaded = pyqtSignal()       # TODO: see if necessary
    measurementsUpdated = pyqtSignal()

    def __init__(self):
        super().__init__()
        self.room_list = []
        self.load_room_list()

    def load_room_list(self):
        try:
            with open('./room_list.json', 'r') as file:
                room_json = json.load(file)
                self.room_list = [room for room in room_json]
        except FileNotFoundError:
            self.room_list = []
            print("Room list file not found.")

        return self.room_list

    def save_room_list(self):
        with open('./room_list.json', 'w+') as file:
            json.dump(self.room_list, file)
        self.load_room_list()

    def getRoomIds(self):
        with open('./room_list.json', 'r') as file:
            room_json = json.load(file)
        return [room['roomId'] for room in room_json]

    def emitMeasurementsUpdated(self):
        self.measurementsUpdated.emit()

    @pyqtSlot(str)
    def addRoom(self, room_name):
        json_file = 'room_list.json'
        if not os.path.exists(json_file):
            with open(json_file, 'w') as file:
                json.dump([], file)

        existing_ids = [room['roomId'] for room in self.room_list]
        next_id = max(existing_ids) + 1 if existing_ids else 0

        new_room = {
            'roomId': next_id,
            'roomName': room_name,
            'devices': []  # Initialize with an empty devices list
        }

        self.room_list.append(new_room)
        self.save_room_list()

    @pyqtSlot(int, str)
    def editRoom(self, room_id, new_room_name):
        with open('./room_list.json', 'r+') as file:
            room_json = json.load(file)

            for room in room_json:
                if room['roomId'] == room_id:
                    room['roomName'] = new_room_name
                    print("Edited room:", room)
                    break

            file.seek(0)
            json.dump(room_json, file, indent=4)
            file.truncate()

            self.load_room_list()

    @pyqtSlot(result=list)
    def loadData(self):
        self.load_room_list()
        self.dataLoaded.emit()
        return self.room_list

    @pyqtSlot(int)
    def deleteRoom(self, room_id):
        with open('./room_list.json', 'r+') as file:
            room_json = json.load(file)

            index_to_delete = None
            for index, room in enumerate(room_json):
                if room['roomId'] == room_id:
                    index_to_delete = index
                    break

            if index_to_delete is not None:
                del room_json[index_to_delete]
                print("Deleted room with ID:", room_id)

                file.seek(0)
                json.dump(room_json, file, indent=4)
                file.truncate()

                self.load_room_list()
            else:
                print("Room with ID", room_id, "not found.")

    @pyqtSlot(int, str, str)
    def addDevice(self, room_id, device_name, measurement):
        found = False
        for room in self.room_list:
            if room['roomId'] == room_id:
                new_device = {
                    'name': device_name,
                    'measurement': measurement,
                    'state': "OFF"
                }
                room['devices'].append(new_device)
                self.save_room_list()

                found = True
                break

        if not found:
            print("Invalid room ID:", room_id)

    @pyqtSlot(int, str)
    def removeDevice(self, room_id, device_name):
        print(room_id, device_name)
        for room in self.room_list:
            if room['roomId'] == room_id:
                devices = room['devices']
                updated_devices = [
                    device for device in devices if device['name'] != device_name]
                print(f"Updated devices:\n{updated_devices}")

                room['devices'] = updated_devices
                print(f"Room[devices]:\n{room['devices']}")

                self.save_room_list()
                return
        print("Invalid room ID:", room_id)

    @pyqtSlot(int, list)
    def updateDevices(self, room_id, new_devices):
        for room in self.room_list:
            if room['roomId'] == room_id:
                room['devices'] = new_devices
                self.save_room_list()
                break
        else:
            print("Invalid room ID:", room_id)

    @pyqtSlot(int, result=list)
    def getDevicesForRoom(self, room_id):
        devices = []
        for room in self.room_list:
            if room['roomId'] == room_id:
                devices = room['devices']
                break
        return devices

    @pyqtSlot(int, result=list)
    def loadMeasurements(self, currentRoomId):
        measurement_units = {
            "temperature": "°C",
            "humidity": "%",
            "air pressure": "hPa",
            "power_consumption": "%",
            "brightness": "lux",
        }

        measurement_files = [
            filename for filename in os.listdir(f"./logs/{currentRoomId}")
        ]
        measurements = []

        for measurement_file in measurement_files:
            log_file_path = f"./logs/{currentRoomId}/{measurement_file}"

            if os.path.exists(log_file_path):
                with open(log_file_path, 'r') as log_file:
                    lines = log_file.readlines()
                    for line in reversed(lines):
                        timestamp_str, value = line.strip().split(', ')
                        measurement_name = measurement_file.replace(
                            ".log", "").replace("_", " ")

                        if 'err' not in value.lower():

                            measurements.append({
                                "name": measurement_name,
                                "value": value + " " + measurement_units.get(measurement_name, ""),
                            })

                            break
                        else:
                            measurements.append({
                                "name": measurement_name,
                                "value": "Error",
                            })
                            break
            else:
                measurements.append({
                    "name": measurement_file.replace(".log", "").replace("_", " "),
                    "value": "UNKNOWN",
                })

        return measurements

    @pyqtSlot(int, str, str)
    def updateDeviceState(self, room_id, device_name, new_state):
        for room in self.room_list:
            if room['roomId'] == room_id:
                for device in room['devices']:
                    if device['name'] == device_name:
                        device['state'] = new_state
                        self.save_room_list()
                        return
        print("Invalid room ID:", room_id)

    @pyqtSlot(result=list)
    def loadCitiesData(self):
        try:
            with open('./cities_data.json', 'r') as file:
                return json.load(file)
        except FileNotFoundError:
            print("Cities data file not found.")

    @pyqtSlot(float, float, str)
    def addLocation(self, latitude, longitude, locationData):
        config = configparser.ConfigParser()
        config.read('config.ini')

        if 'Location' not in config:
            config['Location'] = {}
        config['Location']['latitude'] = str(latitude)
        config['Location']['longitude'] = str(longitude)
        config['Location']['locationData'] = locationData

        with open('config.ini', 'w') as configfile:
            config.write(configfile)

    @pyqtSlot(result="QVariantList")
    def retrieveLocation(self):
        config = configparser.ConfigParser()
        config.read('config.ini')

        if 'Location' in config:
            latitude = config['Location'].getfloat('latitude', -1)
            longitude = config['Location'].getfloat('longitude', -1)
            locationData = config.get('Location', 'locationData', fallback='')
        else:
            latitude = longitude = -1
            locationData = ""

        return [latitude, longitude, locationData]
