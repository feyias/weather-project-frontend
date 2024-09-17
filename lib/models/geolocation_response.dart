import 'dart:convert';

// List<Geolocation> geolocationFromJson(String str) => List<Geolocation>.from(json.decode(str).map((x) => Geolocation.fromJson(x)));

List<Geolocation> geolocationFromJson(String str) {
  final jsonData = json.decode(str);
  if (jsonData is List) {
    return List<Geolocation>.from(jsonData.map((x) => Geolocation.fromJson(x as Map<String, dynamic>)));
  }
  return [];
}

String geolocationToJson(List<Geolocation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Geolocation {
  final String name;
  final Map<String, String?>? localNames;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  Geolocation({
    required this.name,
    required this.localNames,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
  });

  factory Geolocation.fromJson(Map<String, dynamic> json) => Geolocation(
    name: json["name"] ?? '-',
    localNames: (json["local_names"] as Map<String, dynamic>?)?.map((k, v) => MapEntry<String, String?>(k, v as String?)),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
    country: json["country"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "local_names": localNames,
    "lat": lat,
    "lon": lon,
    "country": country,
    "state": state,
  };
}
