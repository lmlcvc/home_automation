import os
from datetime import datetime, timedelta
import serial
from util.serial_thread import SerialThread


def remove_outdated_logs(log_file):
    with open(log_file, 'r') as file:
        lines = file.readlines()

    if len(lines) == 0:
        return

    timestamp_format = '%Y-%m-%d %H:%M:%S'
    current_time = datetime.now()

    # Calculate the timestamp threshold for outdated logs (24 hours ago from the current time)
    threshold = current_time - timedelta(hours=24)

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
        return -50 <= value <= 100
    elif measurement == 'H':                            # within range
        value = float(value)
        return 0 <= value <= 100
    elif measurement == 'P' or measurement == 'C':      # positive
        value = float(value)
        return value >= 0
    elif measurement == 'B':                            # within range
        value = float(value)
        return 0 <= value <= 1000
    else:                                               # Unknown measurement type, consider it invalid
        return False


class SerialLogger:
    def __init__(self):
        self.serial_port = serial.Serial('COM1', 9600)  # Replace 'COM1' with the appropriate serial port
        self.send_message(f"{datetime.now()} - serial connected\n")
        self.log_dir = 'logs'
        if not os.path.exists(self.log_dir):
            os.makedirs(self.log_dir)

        self.serial_thread = SerialThread(self.serial_port)
        self.serial_thread.messageReceived.connect(self.handle_serial_message)
        self.serial_thread.start()

    def send_message(self, message):
        self.serial_port.write(message.encode())

    def receive_message(self):
        return self.serial_port.readline().decode().strip()

    def handle_serial_message(self, message):
        print(f"{datetime.now()} - Received message: {message}")

        parts = message.split()
        if len(parts) != 3:
            print(f"{datetime.now()} - Invalid serial message: {message}")
            self.log_error(message)
            return

        room_id = parts[0]
        measurement = parts[1]
        value = parts[2]

        if measurement not in ('T', 'H', 'P', 'B', 'C'):
            print(f"{datetime.now()} - Invalid measurement: {measurement}")
            self.log_error(message)
            return

        # Validity checks
        if not is_valid_value(measurement, value):
            print(f"{datetime.now()} - Invalid value: {value}")
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
        log_dir = os.path.join(os.getcwd(), self.log_dir, room_id)  # Use absolute path for log directory
        log_file = os.path.join(log_dir, f"{measurement_name}.log")  # Use absolute path for log file

        os.makedirs(log_dir, exist_ok=True)  # Create the log directory if it doesn't exist

        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log_entry = f"{timestamp}, {measurement}, {value}\n"

        with open(log_file, 'a') as file:  # Open the file in append mode
            file.write(log_entry)

        remove_outdated_logs(log_file)

    def log_error(self, message):
        room_id = message.split()[0]
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log_entry = f"{timestamp}, ERROR: {message}\n"

        log_dir = os.path.join(os.getcwd(), self.log_dir, room_id)  # Use absolute path for log directory
        os.makedirs(log_dir, exist_ok=True)  # Create the log directory if it doesn't exist

        log_file = os.path.join(log_dir, "error.log")  # Use absolute path for error log

        with open(log_file, 'a') as file:  # Open the error log file in append mode
            file.write(log_entry)
