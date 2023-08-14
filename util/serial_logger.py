import os
from datetime import datetime, timedelta

import serial
from util.serial_thread import SerialThread


LOG_THRESHOLD_HOURS = 24
TEMPERATURE_RANGE = (-50, 100)
HUMIDITY_RANGE = (0, 100)
POSITIVE_MIN = 0
BRIGHTNESS_RANGE = (0, 1000)


def remove_outdated_logs(log_file):
    with open(log_file, 'r') as file:
        lines = file.readlines()

    if len(lines) == 0:
        return

    timestamp_format = '%Y-%m-%d %H:%M:%S'
    current_time = datetime.now()

    # Calculate the timestamp threshold for outdated logs
    threshold = current_time - timedelta(hours=LOG_THRESHOLD_HOURS)

    # Filter the log entries that are within the threshold
    filtered_entries = [line for line in lines if
                        datetime.strptime(line.strip().split(',')[0], timestamp_format) >= threshold]

    # Rewrite the log file with the filtered entries
    with open(log_file, 'w') as file:
        file.write(''.join(filtered_entries))


def is_valid_value(measurement, value):
    # Perform validity checks based on the measurement type and value
    if measurement == 'T':                              # within range
        value = float(value)
        return TEMPERATURE_RANGE[0] <= value <= TEMPERATURE_RANGE[1]
    elif measurement == 'H':                            # within range
        value = float(value)
        return HUMIDITY_RANGE[0] <= value <= HUMIDITY_RANGE[1]
    elif measurement == 'P' or measurement == 'C':      # positive
        value = float(value)
        return value >= POSITIVE_MIN
    elif measurement == 'B':                            # within range
        value = float(value)
        return BRIGHTNESS_RANGE[0] <= value <= BRIGHTNESS_RANGE[1]
    else:                                               # Unknown measurement type, consider it invalid
        return False


class SerialLogger:
    def __init__(self, backend):
        self.backend = backend

        # TODO: Redo or remove serial port init
        self.serial_port = None  # serial.Serial('/dev/ttyUSB0', 9600)
        # self.send_message(f"{datetime.now()} - serial connected\n")

        self.log_dir = 'logs'
        if not os.path.exists(self.log_dir):
            os.makedirs(self.log_dir)

        self.serial_thread = SerialThread(self.serial_port, self.backend)
        self.serial_thread.messageReceived.connect(self.handle_serial_message)
        self.serial_thread.start()

    def send_message(self, message):
        self.serial_port.write(message.encode())

    def receive_message(self):
        return self.serial_port.readline().decode().strip()

    def handle_serial_message(self, message):
        current_time = datetime.now()
        print(f"{current_time} - Received message: {message}")

        parts = message.split()
        if len(parts) != 3:
            print(f"{current_time} - Invalid serial message: {message}")
            self.log_error(message)
            return

        room_id = parts[0]
        measurement = parts[1]
        value = parts[2]

        if measurement not in ('T', 'H', 'P', 'B', 'C'):
            print(f"{current_time} - Invalid measurement: {measurement}")
            self.log_error(message)
            return

        # Validity checks
        if not is_valid_value(measurement, value):
            print(f"{current_time} - Invalid value: {value}")
            self.log_error(message)
            return

        measurement_names = {
            'T': 'temperature',
            'H': 'humidity',
            'P': 'air_pressure',
            'B': 'brightness',
            'C': 'power_consumption'
        }
        measurement_name = measurement_names[measurement]
        # Use absolute path for log directory
        log_dir = os.path.join(os.getcwd(), self.log_dir, room_id)
        # Use absolute path for log file
        log_file = os.path.join(log_dir, f"{measurement_name}.log")

        # Create the log directory if it doesn't exist
        os.makedirs(log_dir, exist_ok=True)

        timestamp = current_time.strftime('%Y-%m-%d %H:%M:%S')
        log_entry = f"{timestamp}, {measurement}, {value}\n"

        with open(log_file, 'a') as file:  # Open the file in append mode
            file.write(log_entry)

        remove_outdated_logs(log_file)

    def log_error(self, message):
        room_id = message.split()[0]
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log_entry = f"{timestamp}, ERROR: {message}\n"

        # Use absolute path for log directory
        log_dir = os.path.join(os.getcwd(), self.log_dir, room_id)
        # Create the log directory if it doesn't exist
        os.makedirs(log_dir, exist_ok=True)

        # Use absolute path for error log
        log_file = os.path.join(log_dir, "error.log")

        with open(log_file, 'a') as file:  # Open the error log file in append mode
            file.write(log_entry)
