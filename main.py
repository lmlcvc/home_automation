from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType
import os
import configparser
from util import message_logger, backend, places_fetcher


config = configparser.ConfigParser()
config.read('config.ini')
config = config['default']

WEATHER_API_KEY = config['weatherApiKey']

if __name__ == '__main__':
    os.environ['QML_XHR_ALLOW_FILE_READ'] = '1'
    app = QGuiApplication([])
    engine = QQmlApplicationEngine()

    # Create instances of used classes
    m_backend = backend.Backend()
    m_logger = message_logger.MessageLogger(m_backend)

    # Fetch places for city picker
    if not os.path.isfile("cities_data.json"):
        places_fetcher.run()

    engine.rootContext().setContextProperty("backend", m_backend)       # TODO: make QML object
    engine.rootContext().setContextProperty("weatherApiKey", WEATHER_API_KEY)

    # Load the QML file
    engine.load("qml/main.qml")

    app.exec_()