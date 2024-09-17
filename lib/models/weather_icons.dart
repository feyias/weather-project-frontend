class WeatherIcons {
  final String prefix;
  final String suffix;

  WeatherIcons({
    this.prefix = "assets/",
    this.suffix = ".png",
  });

  String getIcon(name) {
    switch (name) {
      case 'Thunderstorm':
        return '${prefix}thunderstorm$suffix';
      case 'Drizzle':
        return '${prefix}rain$suffix';
      case 'Rain':
        return '${prefix}rain$suffix';
      case 'Snow':
        return '${prefix}snow$suffix';
      case 'Clear':
        return '${prefix}sunny$suffix';
      case 'Clouds':
        return '${prefix}cloud$suffix';
      case 'Mist':
      case 'Smoke':
      case 'Haze':
      case 'Dust':
      case 'Fog':
      case 'Sand':
      case 'Ash':
      case 'Squall':
      case 'Tornado':
      default:
        return '${prefix}mist$suffix';
    }
  }
}