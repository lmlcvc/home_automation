from PyQt5.QtCore import QThread, pyqtSignal

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