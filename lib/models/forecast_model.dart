import 'package:cloudy_app/models/weathericon_model.dart';

class ForecastModel {
  final WeatherIcon weatherIcon;
  final String mainText;
  final String descriptionText;
  final String timeText;
  final List<int> dateTime; /// [year, month, day]
  final String tempText;
  final bool isDailyForecast;

  ForecastModel({
    required this.weatherIcon,
    required this.mainText,
    required this.descriptionText,
    required this.timeText,
    required this.dateTime,
    required this.tempText,
    required this.isDailyForecast,
  });

  @override
  String toString() {
    return "ForecastModel {weatherIcon: $weatherIcon, mainText: $mainText, descriptionText: $descriptionText, timeText: $timeText, dateTime: $dateTime, tempText: $tempText, isDailyForecast: $isDailyForecast}\n";
  }
}
