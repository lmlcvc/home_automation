import os
from datetime import datetime, timedelta
from util.message_thread import MessageThread

LOG_THRESHOLD_HOURS = 24
TEMPERATURE_RANGE = (-20, 45)
HUMIDITY_RANGE = (0, 100)
POSITIVE_MIN = 0
BRIGHTNESS_RANGE = (0, 1000)


class MessageLogger:
    def __init__(self, backend):
        self.backend = backend

        self.log_dir = 'logs'
        if not os.path.exists(self.log_dir):
            os.makedirs(self.log_dir)

        self.message_thread = MessageThread(self.backend)
        self.message_thread.messageReceived.connect(self.handle_message)
        self.message_thread.start()

    def send_message(self, message):
        print(message)

    def handle_message(self, message):
        is_error = False
        current_time = datetime.now()
        print(f"{current_time} - Received message: {message}")

        parts = message.split()
        if len(parts) != 3:
            print(f"{current_time} - Invalid message: {message}")
            error_msg = f"{current_time}\tInvalid message\t{message}\n"
            self.log_error(error_msg)
            is_error = True
            return

        room_id = parts[0]
        measurement = parts[1]
        value = parts[2]

        if measurement not in ('T', 'H', 'P', 'B', 'C'):
            print(f"{current_time} - Invalid measurement: {measurement}")
            error_msg = f"{current_time}\tInvalid measurement\t{message}\n"
            self.log_error(error_msg)
            is_error = True
            return

        if not self.is_valid_value(measurement, value):
            print(f"{current_time} - Invalid {measurement} value: {value}")
            error_msg = f"{current_time}\tInvalid value\t{message}\n"
            self.log_error(error_msg)
            is_error = True

        measurement_names = {
            'T': 'temperature',
            'H': 'humidity',
            'P': 'air_pressure',
            'B': 'brightness',
            'C': 'power_consumption'
        }
        measurement_name = measurement_names[measurement]

        log_dir = os.path.join(os.getcwd(), self.log_dir, room_id)
        daily_log_dir = os.path.join(os.getcwd(), self.log_dir, "daily")
        daily_log_file = os.path.join(
            daily_log_dir, f"{current_time.strftime('%Y-%m-%d')}.log")
        specific_log_file = os.path.join(log_dir, f"{measurement_name}.log")
        os.makedirs(log_dir, exist_ok=True)
        os.makedirs(daily_log_dir, exist_ok=True)

        timestamp = current_time.strftime('%Y-%m-%d %H:%M:%S')
        log_entry = f"{timestamp}, {value}\n" if not is_error else f"{timestamp}, ERR\n"
        log_entry_daily = f"{timestamp}, {measurement}, {value}\n" if not is_error else f"{timestamp}, {measurement}, ERR\n"

        with open(specific_log_file, 'a') as file:
            file.write(log_entry)

        with open(daily_log_file, 'a') as file:
            file.write(log_entry_daily)

        self.remove_outdated_logs(specific_log_file, measurement)

    def log_error(self, err_entry):
        log_dir = os.path.join(os.getcwd(), self.log_dir)
        os.makedirs(log_dir, exist_ok=True)

        log_file = os.path.join(log_dir, "error.log")

        with open(log_file, 'a') as file:
            file.write(err_entry)

    def remove_outdated_logs(self, log_file, measurement):
        with open(log_file, 'r') as file:
            lines = file.readlines()

        if len(lines) == 0:
            return

        timestamp_format = '%Y-%m-%d %H:%M:%S'
        current_time = datetime.now()

        threshold = current_time - \
            timedelta(seconds=self.get_measurement_threshold(measurement))

        filtered_entries = [line for line in lines if
                            datetime.strptime(line.strip().split(',')[0], timestamp_format) >= threshold]

        with open(log_file, 'w') as file:
            file.write(''.join(filtered_entries))

    def is_valid_value(self, measurement, value):
        if measurement == 'T':
            value = float(value)
            return TEMPERATURE_RANGE[0] <= value <= TEMPERATURE_RANGE[1]
        elif measurement == 'H':
            value = float(value)
            return HUMIDITY_RANGE[0] <= value <= HUMIDITY_RANGE[1]
        elif measurement == 'P' or measurement == 'C':
            value = float(value)
            return value >= POSITIVE_MIN
        elif measurement == 'B':
            value = float(value)
            return BRIGHTNESS_RANGE[0] <= value <= BRIGHTNESS_RANGE[1]
        else:
            return False

    def get_measurement_threshold(self, measurement):
        measurement_thresholds = {
            'T': 300,   # 5 minutes
            'H': 300,   # 5 minutes
            'P': 600,   # 10 minutes
            'B': 30,    # 30 seconds
            'C': 600    # 10 minutes
        }
        return measurement_thresholds.get(measurement, 0)
