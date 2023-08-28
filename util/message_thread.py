from PyQt5.QtCore import QThread, pyqtSignal
import random
import time

GEN_TEMPERATURE_RANGE = (-30, 50)
GEN_PERCENTAGE_RANGE = (-10, 110)
GEN_PRESSURE_RANGE = (800, 1200)
GEN_BRIGHTNESS_RANGE = (-10, 1100)

MEASUREMENT_NAMES = {
    'temperature': 'T',
    'humidity': 'H',
    'air pressure': 'P',
    'brightness': 'B',
    'power consumption': 'C'
}

class MessageThread(QThread):
    messageReceived = pyqtSignal(str)

    def __init__(self, backend):
        super().__init__()
        self.backend = backend

    def run(self):
        self.generate_dummy_data()

    def generate_dummy_data(self):
        while True:
            room_ids = self.backend.getRoomIds()
            if not room_ids:
                print("No room IDs available. Exiting.")
                return

            room_id = random.choice(room_ids)
            room_devices = self.backend.getDevicesForRoom(room_id)

            if not room_devices:
                continue

            device = random.choice(room_devices)
            device_state = device['state']  
            measurement = device['measurement']
            measurement_code = MEASUREMENT_NAMES.get(measurement, 'UNKNOWN')

            if device_state.lower() == 'on': 
                value = None
                if measurement == 'temperature':
                    value = random.uniform(
                        GEN_TEMPERATURE_RANGE[0], GEN_TEMPERATURE_RANGE[1])
                elif measurement == 'humidity' or measurement == 'brightness':
                    value = random.uniform(
                        GEN_PERCENTAGE_RANGE[0], GEN_PERCENTAGE_RANGE[1])
                elif measurement == 'air pressure':
                    value = random.uniform(
                        GEN_PRESSURE_RANGE[0], GEN_PRESSURE_RANGE[1])

                if value is not None:
                    message = f"{room_id} {measurement_code} {value:.2f}"
                    print("Generated message:", message)
                    self.messageReceived.emit(message)
                    self.backend.emitMeasurementsUpdated()

            time.sleep(1)
