from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

from util.backend import Backend

if __name__ == '__main__':
    app = QGuiApplication([])
    engine = QQmlApplicationEngine()

    # Create an instance of the Backend class
    backend = Backend()

    # Register the backend object as a context property
    engine.rootContext().setContextProperty("backend", backend)

    engine.load("qml/main.qml")

    app.exec_()
