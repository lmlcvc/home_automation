from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

from util import backend, serial_logger

if __name__ == '__main__':
    app = QGuiApplication([])
    engine = QQmlApplicationEngine()

    # Create an instance of the Backend class
    m_backend = backend.Backend()

    # Create an instance of the SerialLogger class
    m_logger = serial_logger.SerialLogger(m_backend) 

    # Register the backend object as a context property
    engine.rootContext().setContextProperty("backend", m_backend)

    # Load the QML file
    engine.load("qml/main.qml")

    app.exec_()
