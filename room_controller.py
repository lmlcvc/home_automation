import serial
import json
from datetime import datetime


class RoomController:
    def __init__(self):
        self.serial_port = None  # serial.Serial('COM1', 9600)  # Replace 'COM1' with the appropriate serial port
        self.room_list = []

    def send_message(self, message):
        self.serial_port.write(message.encode())

    def receive_message(self):
        return self.serial_port.readline().decode().strip()

    def add_room(self, room_id, room_name):
        self.room_list.append({
            'id': room_id,
            'name': room_name
        })
        self.update_room_list_file()

    def update_room_list_file(self):
        with open('room_list.json', 'w') as file:
            json.dump(self.room_list, file)

    def log_room_data(self, room_id, size, value):
        reception_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        with open(f"{room_id}.txt", 'a') as file:
            file.write(f"{room_id}, {size}, {value}, {reception_time}\n")
