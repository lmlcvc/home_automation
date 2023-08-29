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

    # Register the backend object as a context property
    # XXX: instantiate somewhere else, not globally accessible

    # qmlRegisterType(backend.Backend, 'BackendModule', 1, 0, 'Backend')

    # engine.rootContext().setContextProperty("backend", m_backend)
    engine.rootContext().setContextProperty("weatherApiKey", WEATHER_API_KEY)

    # Load the QML file
    engine.load("qml/main.qml")

    app.exec_()
