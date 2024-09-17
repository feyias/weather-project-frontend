import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_project/components/about_us_page.dart';
import 'package:weather_app_project/components/city_search_page.dart';
import 'package:weather_app_project/components/landing_page.dart';
import 'package:weather_app_project/components/settings_page.dart';
import 'package:weather_app_project/models/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  int? defaultCity = 0;

  // When app initializes
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

    _loadApp();
  }

  // Load app data from local storage
  Future<void> _loadApp() async {
    // Get local storage data
    final prefs = await SharedPreferences.getInstance();

    // In order to update UI
    setState(() {
      // Get list of all Locations from local storage
      List<String>? allLocations = prefs.getStringList("locations");
      int? defCity = prefs.getInt("default_city");

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
        defCity != null ? defaultCity = defCity : 0;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromRGBO(255, 255, 255, 1.0),
        hintColor: const Color.fromRGBO(162, 162, 162, 1.0),
        scaffoldBackgroundColor: const Color.fromRGBO(47, 53, 67, 1.0),
        fontFamily: "Montserrat",
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Color.fromRGBO(255, 255, 255, 1.0),
          ),
          backgroundColor:  Color.fromRGBO(47, 53, 67, 1.0),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color.fromRGBO(47, 53, 67, 1.0),
        ),
      ),
      home: (savedLocations.isNotEmpty ? const LandingPage() : const CitySearchPage(isHomePage: true) ), // Placeholder for either landing page or city search
      routes: {
        '/home': (context) => const LandingPage(), // Placeholder for landing page
        '/about': (context) => const AboutUsPage(),
        '/contact': (context) => const Scaffold(), // Placeholder for contact page
        '/new': (context) => const CitySearchPage(isHomePage: false),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
