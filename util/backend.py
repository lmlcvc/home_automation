import json

from PyQt5.QtCore import QObject, pyqtSlot

from util.serial_logger import SerialLogger


class Backend(QObject):
    def __init__(self):
        super().__init__()
        self.room_list = self.load_room_list()
        self.serial_logger = SerialLogger()

    def load_room_list(self):
        try:
            with open('../room_list.json', 'r') as file:
                return json.load(file)
        except FileNotFoundError:
            return []

    def save_room_list(self):
        with open('../room_list.json', 'w') as file:
            json.dump(self.room_list, file)

    @pyqtSlot(str)
    def addRoom(self, room_name):
        # Find the next available ID
        next_id = 0
        if self.room_list:
            existing_ids = [room['id'] for room in self.room_list]
            next_id = max(existing_ids) + 1

        room = {
            'id': next_id,
            'name': room_name
        }
        self.room_list.append(room)
        self.save_room_list()
