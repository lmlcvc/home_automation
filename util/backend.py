import json
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal


class Backend(QObject):
    dataLoaded = pyqtSignal()  # Signal to notify QML about data loading

    def __init__(self):
        super().__init__()
        self.room_list = []
        self.load_room_list()

    def load_room_list(self):
        try:
            with open('../room_list.json', 'r') as file:
                room_json = json.load(file)
                self.room_list = [room['name'] for room in room_json]
                print("Loaded room names:", self.room_list)
        except FileNotFoundError:
            self.room_list = []
            print("Room list file not found.")

        return self.room_list

    def save_room_list(self):
        with open('../room_list.json', 'w') as file:
            json.dump(self.room_list, file)

    @pyqtSlot(str)
    def addRoom(self, room_name):
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

    @pyqtSlot(result=list)
    def loadData(self):
        self.load_room_list()
        self.dataLoaded.emit()
        return self.room_list
