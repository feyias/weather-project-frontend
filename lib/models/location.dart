import 'dart:convert';

Location locationFromJson(String? str) {
  Location emptyLocation = Location(
    lat: 0.0,
    lon: 0.0,
    city: '',
    country: '',
  );
  if (str != null){
    final jsonData = json.decode(str);
    return Location.fromJson(jsonData);
  }
  return emptyLocation;
}

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  final double lat;
  final double lon;
  final String city;
  final String country;
  final String? state;

  Location({
    required this.lat,
    required this.lon,
    required this.city,
    required this.country,
    this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    city: json["city"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    country: json["country"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lon": lon,
    "city": city,
    "country": country,
    "state": state,
  };
}