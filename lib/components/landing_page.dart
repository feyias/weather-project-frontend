import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_project/components/app_drawer.dart';
import 'package:weather_app_project/components/network_utilities.dart';
// import 'package:weather_app_project/components/weather_display.dart';
import 'package:weather_app_project/models/weather_data.dart';
import 'package:weather_app_project/models/location.dart';

import '../models/weather_icons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

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

  Location mockCity3 = Location(
    lat: -12.9822499,
    lon: -38.4812772,
    city: "Salvador",
    country: "BR",
  );

  Location defaultCity = Location(
    lat: 0.0,
    lon: 0.0,
    city: ' - error -',
    country: '',
  );

  WeatherData emptyWeatherData = WeatherData(
    timestamp: 00000,
    temp: 0,
    feelsLike: 0,
    weekday: ' - ',
    weatherId: 0,
    name: ' - ',
    iconId: ' - ',
  );

  List<WeatherData> weatherForecast = List<WeatherData>.empty(growable: true);
  List<Location> savedLocations = List<Location>.empty(growable: true);
  WeatherIcons icons = WeatherIcons();

  @override
  void initState() {
    super.initState();
    _loadDefault();
    // _loadCity();
  }

  Future<void> _loadDefault() async {
    log("Loading default values");
    // Load default displayed city
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Get list of all Locations
      List<String>? allLocations = prefs.getStringList("locations");
      // Check if List exist
      if (allLocations != null) {
        // Parse Strings to Locations
        List<Location> parsedLocation = List<Location>.empty(growable: true);
        for (String str in allLocations) {
          parsedLocation.add(locationFromJson(str));
        }
        savedLocations = parsedLocation;

        // Set default city displayed
        int cityIndex = prefs.getInt('default_city') ?? 0;

        defaultCity = savedLocations[cityIndex];

      }
    });
    await getForecast();
  }

  Future<void> getForecast() async {
    // Fetch data
    List<WeatherData>? weatherData = await NetworkUtility.fetchForecast(defaultCity);

    if (weatherData != null) {
      setState(() {
        weatherForecast = weatherData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(child: Text("Weather App")),
        actions: [Container(width: 50,),],
        elevation: 0,
      ),
      drawer: AppDrawer(savedLocations: savedLocations,),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 900,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                ),
                Text(
                  defaultCity.city,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 32,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w300,
                    /*
                    fontFamily: "Montserrat",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.8,
                     */
                  ),
                ),
                IconButton(
                onPressed: () {},
                icon: Icon(
                Icons.refresh,
                color: Theme.of(context).primaryColor,
                ),
                ),
              ],
            ),
            Text(
              (weatherForecast.isNotEmpty ? weatherForecast.first.temp - 273.15 : 0.0).toStringAsFixed(0),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 86,
                fontWeight: FontWeight.w300,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Image(
                  image: AssetImage(icons.getIcon(weatherForecast.isNotEmpty ? weatherForecast.first.name : '')),
                  ),
                ),
                Text(
                  (weatherForecast.isNotEmpty ? weatherForecast.first.name : ' - ').toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Montserrat",
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WeatherDisplayElement(weatherForecast.isNotEmpty ? weatherForecast[0] : emptyWeatherData),
                WeatherDisplayElement(weatherForecast.isNotEmpty ? weatherForecast[1] : emptyWeatherData),
                WeatherDisplayElement(weatherForecast.isNotEmpty ? weatherForecast[2] : emptyWeatherData),
                WeatherDisplayElement(weatherForecast.isNotEmpty ? weatherForecast[3] : emptyWeatherData),
              ],
            )
            ],
          ),
        ),
      ),
    );
  }

  Widget WeatherDisplayElement(WeatherData wData) {
    return Column(
      children: [
        Text(
          wData.weekday,
          style: TextStyle(
              color: Theme.of(context).primaryColor
          ),
        ),
        Image(
          image: AssetImage(icons.getIcon(wData.name)),
          height: 80,
        ),
        Text(
          "${(wData.temp - 273.15).toStringAsFixed(0)} ",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            letterSpacing: 4,
          ),
        )
      ],
    );
  }
}

