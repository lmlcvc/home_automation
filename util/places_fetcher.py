import json

city_data = []

# TODO: order alphabetically by name
with open("HR.txt", "r") as file:
    for line in file:
        parts = line.strip().split("\t")
        city_name, latitude, longitude = parts[2], parts[4], parts[5]
        city_data.append({"name": city_name, "latitude": latitude, "longitude": longitude})

# Save the data to a JSON file
with open("cities_data.json", "w") as json_file:
    json.dump(city_data, json_file, indent=4)

print("City data saved to cities_data.json")
