import 'package:cloudy_app/models/weathericon_model.dart';
import 'package:flutter/material.dart';

class ForecastModel {
  final WeatherIcon weatherIcon;
  final String mainText;
  final String descriptionText;
  final String timeText;
  final DateTime dateTime;
  final String tempText;

  ForecastModel({
    required this.weatherIcon,
    required this.mainText,
    required this.descriptionText,
    required this.timeText,
    required this.dateTime,
    required this.tempText,
  });

  @override
  String toString() {
    return "ForecastModel {weatherIcon: $weatherIcon, mainText: $mainText, descriptionText: $descriptionText, timeText: $timeText, dateTime: $dateTime, tempText: $tempText}\n";
  }
}
