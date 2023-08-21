import json
import requests

def run():
    # Fetch country data
    country_response = requests.get("https://restcountries.com/v3.1/all")
    if country_response.ok:
        countries = json.loads(country_response.text)
    else:
        print("Failed to fetch country data")
        return

    # Fetch city data
    city_response = requests.get("https://api.teleport.org/api/urban_areas/")
    if city_response.ok:
        cities_data = json.loads(city_response.text)
        cities = [city["name"] for city in cities_data["_links"]["ua:item"]]
    else:
        print("Failed to fetch city data")
        return

    # Create a dictionary pairing each country with its cities
    # XXX: cities with spaces and extra symbols have issues
    country_city_mapping = {}
    for city in cities:
        country_response = requests.get(f"https://api.teleport.org/api/urban_areas/slug:{city.lower()}/")
        if country_response.ok:
            city_data = json.loads(country_response.text)
            # x._links["ua:countries"][0].name
            country_name = city_data["_links"]["ua:countries"][0]["name"]
            if country_name not in country_city_mapping:
                country_city_mapping[country_name] = []
            country_city_mapping[country_name].append(city_data["name"])
        else:
            print(f"Failed to fetch data for city: {city}")

    # Save the country-city mapping to a local JSON file
    with open("places_data.json", "w") as file:
        json.dump(country_city_mapping, file, indent=4)
