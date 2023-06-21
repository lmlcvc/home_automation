import json
import os

from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal


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
                self.room_list = [room['name'] for room in room_json]
                print("Loaded room names:", self.room_list)
        except FileNotFoundError:
            self.room_list = []
            print("Room list file not found.")

        return self.room_list

    def save_room_list(self):
        with open('./room_list.json', 'w+') as file:
            json.dump(self.room_list, file)

    @pyqtSlot(str)
    def addRoom(self, room_name):
        json_file = 'room_list.json'
        if not os.path.exists(json_file):
            # Create an empty room list if the file doesn't exist
            with open(json_file, 'w') as file:
                json.dump([], file)

        # Load existing room list from JSON file
        with open(json_file, 'r') as file:
            existing_rooms = json.load(file)

        # Find the maximum ID in the existing rooms
        existing_ids = [room['id'] for room in existing_rooms]
        next_id = max(existing_ids) + 1 if existing_ids else 0

        # Create a new room dictionary
        room = {
            'id': next_id,
            'name': room_name
        }

        existing_rooms.append(room)

        with open(json_file, 'w') as file:
            json.dump(existing_rooms, file)

        self.room_list = [room['name'] for room in existing_rooms]

    @pyqtSlot(result=list)
    def loadData(self):
        self.load_room_list()
        self.dataLoaded.emit()
        return self.room_list
