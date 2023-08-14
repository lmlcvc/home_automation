
from PyQt5.QtCore import QThread, pyqtSignal
import random
import time


def generate_dummy_data(backend):
    measurements = ['T', 'H', 'P', 'B', 'C']

    while True:
        room_ids = backend.getRoomIds()
        if not room_ids:
            print("No room IDs available. Exiting.")
            return

        room_id = random.choice(room_ids)
        measurement = random.choice(measurements)
        value = random.uniform(0, 1000)         # FIXME: realistic ranges

        message = f"{room_id} {measurement} {value:.2f}"
        print("Generated message:", message)

        time.sleep(5)


class SerialThread(QThread):
    messageReceived = pyqtSignal(str)

    def __init__(self, serial_port, backend):
        super().__init__()
        self.serial_port = serial_port
        self.backend = backend

    def run(self):
        generate_dummy_data(self.backend)
        # if self.serial_port.in_waiting > 0:
        #    message = self.serial_port.readline().decode().strip()
        #    self.messageReceived.emit(message)
