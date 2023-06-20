import serial
import json
from datetime import datetime

from PyQt5.QtCore import QObject, pyqtSlot


class Backend(QObject):
    def __init__(self):
        super().__init__()
        self.serial_port = None  # serial.Serial('COM1', 9600)  # Replace 'COM1' with the appropriate serial port
        self.room_list = self.load_room_list()

    def send_message(self, message):
        self.serial_port.write(message.encode())

    def receive_message(self):
        return self.serial_port.readline().decode().strip()

    def load_room_list(self):
        try:
            with open('room_list.json', 'r') as file:
                return json.load(file)
        except FileNotFoundError:
            return []

    def save_room_list(self):
        with open('room_list.json', 'w') as file:
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

    def log_room_data(self, room_id, size, value):
        reception_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        with open(f"{room_id}.txt", 'a') as file:
            file.write(f"{room_id}, {size}, {value}, {reception_time}\n")
