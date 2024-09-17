
class WeatherModel {
  final String lon;
  final String lat;
  final String temperature;
  final String condition;
  final String description;
  final String cityName;

  WeatherModel({
    required this.lon,
    required this.lat,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.cityName,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      lon: json['coord']["lon"].toString(),
      lat: json['coord']["lat"].toString(),
      temperature: (json['main']['temp']).round().toString(),
      condition: json['weather'][0]['id'].toString(),
      description: json['weather'][0]['description'],
      cityName: json['name'],
    );
  }

  @override
  String toString() {
    return 'ForecastModel{lon: $lon, lat: $lat, temperature: $temperature, condition: $condition, description: $description, cityName: $cityName}\n';
  }
}