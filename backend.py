import serial
import json
from datetime import datetime

from PyQt5.QtCore import QObject, pyqtSlot, QThread, pyqtSignal


class SerialThread(QThread):
    messageReceived = pyqtSignal(str)

    def __init__(self, serial_port):
        super().__init__()
        self.serial_port = serial_port

    def run(self):
        while True:
            if self.serial_port.in_waiting > 0:
                message = self.serial_port.readline().decode().strip()
                self.messageReceived.emit(message)


class Backend(QObject):
    def __init__(self):
        super().__init__()
        self.serial_port = serial.Serial('COM1', 9600)  # Replace 'COM1' with the appropriate serial port
        self.send_message(f"{datetime.now()} - serial connected\n")

        self.room_list = self.load_room_list()

        self.serial_thread = SerialThread(self.serial_port)
        self.serial_thread.messageReceived.connect(self.handle_serial_message)
        self.serial_thread.start()

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

    @pyqtSlot(str)
    def handle_serial_message(self, message):
        print(f"Received message: {message}")
        # Do further processing or handle the received message as needed
