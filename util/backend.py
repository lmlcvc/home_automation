import json
import os

from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal

# TODO: implement function for adding device based on room ID
# TODO: implement function for editing device name based on room ID and current name


class Backend(QObject):
    dataLoaded = pyqtSignal()  # Signal to notify QML about data loading

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
                    'measurement': measurement
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
                updated_devices = [device for device in devices if device['name'] != device_name]
                print(f"Updated devices:\n{updated_devices}")

                room['devices'] = updated_devices
                print(f"Room[devices]:\n{room['devices']}")

                self.save_room_list()
                return
        print("Invalid room ID:", room_id)



