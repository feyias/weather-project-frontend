import 'dart:convert';

WeatherData? weatherDataFromJson(String? str) {
  if (str != null){
    final jsonData = json.decode(str);
    return WeatherData.fromJson(jsonData);
  }
  return null;
}

String weatherDataToJson(WeatherData data) => json.encode(data.toJson());

class WeatherData {
  final int timestamp;
  final double temp;
  final double feelsLike;

  final String weekday;

  final int weatherId;
  final String name;
  final String iconId;

  WeatherData({
    required this.timestamp,
    required this.temp,
    required this.feelsLike,
    required this.weekday,
    required this.weatherId,
    required this.name,
    required this.iconId,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
    timestamp: json["timestamp"].toInt(),
    temp: json["temp"].toDouble(),
    feelsLike: json["feels_like"].toDouble(),
    weatherId: json["weatherId"].toInt(),
    name: json["name"],
    weekday: json["weekday"],
    iconId: json["iconId"],
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp,
    "temp": temp,
    "feels_like": feelsLike,
    "weekday": weekday,
    "weatherId": weatherId,
    "name": name,
    "iconId": iconId,
  };
}