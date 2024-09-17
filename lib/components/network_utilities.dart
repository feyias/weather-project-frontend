import 'package:http/http.dart' as http;
import 'package:weather_app_project/constrains.dart';
import 'package:weather_app_project/models/weather_data.dart';
import 'package:weather_app_project/models/forecast_response.dart';
import 'package:weather_app_project/models/geolocation_response.dart';
import 'package:weather_app_project/models/location.dart';

class NetworkUtility {

  // Fetch Url
  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      throw Exception('Failed to fetch Url: ${e.toString()}');
    }
    return null;
  }

  // Decode JSON geolocation response and cast new data into Location class
  static Future<List<Location>?> fetchGeolocation(String cityName) async {
    // Create URL
    Uri uri = Uri.http(
      'api.openweathermap.org',
      'geo/1.0/direct',
      {
        "q": cityName,
        "limit": "5",
        "appid": apiKey,
      },
    );

    // Fetch the response
    String? response = await fetchUrl(uri);
    List<Location> locations = List<Location>.empty(growable: true);

    if (response != null) {
      // Decode JSON to Geolocation
      final geolocationList = geolocationFromJson(response);

      // Clean data -> select features we want
      for (var element in geolocationList) {
        locations.add(Location(
          lat: element.lat,
          lon: element.lon,
          city: element.name,
          country: element.country,
          state: element.state,
        ));
      }
    }

    return locations;
  }

  // Fetch, decode and clean data from forecast API
  static Future<List<WeatherData>?> fetchForecast(Location location) async {
    // Create URL
    Uri uri = Uri.http(
      'api.openweathermap.org',
      'data/2.5/forecast',
      {
        "lat": location.lat.toString(),
        "lon": location.lon.toString(),
        "appid": apiKey,
      },
    );
    // Fetch the response
    String? response = await fetchUrl(uri);

    if (response != null) {
      final forecast = forecastFromJson(response);
      var firstGivenDayTime = DateTime.fromMillisecondsSinceEpoch(forecast.list[0].dt * 1000);
      var firstGivenDayIndex = firstGivenDayTime.weekday;

      List<WeatherData> weatherData = List<WeatherData>.empty(growable: true);

      for (int i = 0; i < forecast.list.length; i++) {
        var element = forecast.list[i];
        // Get time of the element
        DateTime time = DateTime.fromMillisecondsSinceEpoch(element.dt * 1000);

        // Get 1 element for each given weekday (preferably at 12 AM)
        if ((time.hour == 12 && time.weekday != firstGivenDayIndex) || i == 0) {
          String weekdayName = '';

          switch(time.weekday){
            case 2:
              weekdayName = "Tuesday";
              break;
            case 3:
              weekdayName = "Wednesday";
              break;
            case 4:
              weekdayName = "Thursday";
              break;
            case 5:
              weekdayName = "Friday";
              break;
            case 6:
              weekdayName = "Saturday";
              break;
            case 7:
              weekdayName = "Sunday";
              break;
            case 1:
            default:
              weekdayName = "Monday";
              break;
          }

          if (i == 0) {
            weekdayName = "Today";
          }

          weatherData.add(WeatherData(
            timestamp: element.dt,
            temp: element.main.temp,
            feelsLike: element.main.feelsLike,
            weekday: weekdayName,
            weatherId: element.weather.first.id,
            name: element.weather.first.main,
            iconId: element.weather.first.icon,
          ));
        }
      }
      return weatherData;
    }
    return null;
  }

  // Send contact page info to our server
  static Future<List<Location>?> sendContactInfo(String cityName) async {
    // Create URL
    Uri uri = Uri.http(
      '127.0.0.1',
      'contact',
      {
        "author": cityName,
        "limit": "5",
        "appid": apiKey,
      },
    );

    // Fetch the response
    String? response = await fetchUrl(uri);

    if (response != null) {
      //     - / / -
    }
  }

}