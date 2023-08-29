import json
import random
import os


def run():
    city_data = []

    if not os.path.exists("cities_data.json"):
        with open("HR.txt", "r") as file:
            for line in file:
                parts = line.strip().split("\t")
                city_name, latitude, longitude = parts[2], parts[4], parts[5]
                city_data.append({"name": city_name, "latitude": latitude, "longitude": longitude})

        # Order alphabetically by name
        city_data.sort(key=lambda city: city["name"])

        # Filter city data based on a 10% chance
        filtered_city_data = [city for city in city_data if random.random() <= 0.1]

        with open("cities_data.json", "w") as json_file:
            json.dump(filtered_city_data, json_file, indent=4)

        print("Filtered city data saved to cities_data.json")
