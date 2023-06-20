import json

from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
import os

class Backend(QObject):
    def __init__(self):
        QObject.__init__(self)

    @pyqtSlot(str, str)
    def addRoom(self, roomId, roomName):
        # Create a new room object
        room = {
            'roomId': roomId,
            'roomName': roomName
        }

        # Write the room details to a JSON file
        filename = roomId + '.json'
        with open(filename, 'w') as file:
            json.dump(room, file)

if __name__ == '__main__':
    app = QGuiApplication([])
    engine = QQmlApplicationEngine()

    # Create an instance of the Backend class
    backend = Backend()

    # Register the backend object as a context property
    engine.rootContext().setContextProperty("backend", backend)

    engine.load("qml/main.qml")

    app.exec_()
