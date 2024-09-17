import 'package:flutter/material.dart';
import 'package:weather_app_project/models/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExampleWidgetWithSharedPreferences extends StatefulWidget {
  const ExampleWidgetWithSharedPreferences({super.key});

  @override
  State<ExampleWidgetWithSharedPreferences> createState() => _ExampleWidgetWithSharedPreferencesState();
}

class _ExampleWidgetWithSharedPreferencesState extends State<ExampleWidgetWithSharedPreferences> {

  // All this code is part from the app i did before


  // Create some objects from Location class
  Location mockCity1 = Location(
    lat: 51.5073219,
    lon: -0.1276474,
    city: "London",
    country: "GB",
  );

  Location mockCity2 = Location(
    lat: 52.5170365,
    lon: 13.3888599,
    city: "Berlin",
    country: "DE",
  );

  List<Location> savedLocations = List<Location>.empty(growable: true);

  // On first time load
  @override
  void initState() {
    super.initState();

    // Setup mock data --> convert <Location> to <String>
    // because the things in local storage cannot be custom class
    String mockJson1 = locationToJson(mockCity1);
    String mockJson2 = locationToJson(mockCity2);

      // Create empty list
    List<String> mockList = List<String>.empty(growable: true);
      // Add these locations to the list
    mockList.add(mockJson1);
    mockList.add(mockJson2);

    // Set mock data for Shared Preferences ( local storage )
    SharedPreferences.setMockInitialValues({
      'locations': mockList,
      'default_city': 1,
    });
  }

  // This is how to make function that will call from NetworkUtilities (fetch api data)
  // It needs to be async, because we need to wait for response (await)
  Future<void> _loadDefault() async {
    // This is how you can get local storage instance
    final prefs = await SharedPreferences.getInstance();

    // I would like to change 'savedLocations' value, so i need to do it inside
    // setState, so UI can re-render
    setState(() {
      // Get list of all Locations from local storage
      List<String>? allLocations = prefs.getStringList("locations");

      // Check if List exist - in not null
      if (allLocations != null) {

        // Create a list for where to put the Location from local storage
        List<Location> parsedLocation = List<Location>.empty(growable: true);

        // For each Location from local storage put it in that list ^
        // ... but locationFromJson is the function in model location.dart
        // this function allow us to convert <String> to <Location>
        // because, once again, things in local storage cannot be custom class
        for (String str in allLocations) {
          parsedLocation.add(locationFromJson(str));
        }

        // Finally replace the widget variable with the list
        savedLocations = parsedLocation;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
