from backend import Backend

# Create an instance of the Backend class
backend_instance = Backend()

# Expose the necessary properties or methods for QML access
backend_data_loaded = backend_instance.dataLoaded
backend_load_data = backend_instance.loadData
backend_add_room = backend_instance.addRoom
