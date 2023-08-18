from PyQt5.QtCore import QThread, pyqtSignal
import random
import time

GEN_TEMPERATURE_RANGE = (-60, 110)
GEN_PERCENTAGE_RANGE = (-10, 110)
GEN_PRESSURE_RANGE = (800, 1200)
GEN_BRIGHTNESS_RANGE = (-10, 1100)

class MessageThread(QThread):
    messageReceived = pyqtSignal(str)

    def __init__(self, backend):
        super().__init__()
        self.backend = backend

    def run(self):
        self.generate_dummy_data()

    def generate_dummy_data(self):
        measurements = ['T', 'H', 'P', 'B', 'C']

        while True:
            room_ids = self.backend.getRoomIds()
            if not room_ids:
                print("No room IDs available. Exiting.")
                return

            room_id = random.choice(room_ids)
            measurement = random.choice(measurements)

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

            self.messageReceived.emit(message)  # Emit the generated message

            time.sleep(10)
