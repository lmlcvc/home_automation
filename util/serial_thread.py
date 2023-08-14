
from PyQt5.QtCore import QThread, pyqtSignal
import random
import time

GEN_TEMPERATURE_RANGE = (-60, 110)
GEN_PERCENTAGE_RANGE = (-10, 110)
GEN_PRESSURE_RANGE = (800, 1200)
GEN_BRIGHTNESS_RANGE = (-10, 1100)


def generate_dummy_data(backend):
    measurements = ['T', 'H', 'P', 'B', 'C']

    while True:
        room_ids = backend.getRoomIds()
        if not room_ids:
            print("No room IDs available. Exiting.")
            return

        room_id = random.choice(room_ids)
        measurement = random.choice(measurements)
        
         # Generate a value that sometimes falls out of the valid range defined in logger
        if measurement == 'T':
            value = random.uniform(GEN_TEMPERATURE_RANGE[0], GEN_TEMPERATURE_RANGE[1])
        elif measurement == 'H' or measurement == 'C':
            value = random.uniform(GEN_PERCENTAGE_RANGE[0], GEN_PERCENTAGE_RANGE[1])
        elif measurement == 'P':
            value = random.uniform(GEN_PRESSURE_RANGE[0], GEN_PRESSURE_RANGE[1])
        elif measurement == 'B':
            value = random.uniform(GEN_BRIGHTNESS_RANGE[0], GEN_BRIGHTNESS_RANGE[1])


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
