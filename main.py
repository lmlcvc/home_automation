from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

if __name__ == '__main__':
    app = QGuiApplication([])
    engine = QQmlApplicationEngine()

    engine.load("main.qml")

    app.exec_()
