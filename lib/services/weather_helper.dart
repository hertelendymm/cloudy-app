import 'package:cloudy_app/models/weathericon_model.dart';
import 'package:cloudy_app/services/location_helper.dart';
import 'package:cloudy_app/services/networking_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// TODO remove apiKey
const apiKey = '4ef2575bccd3ceab784dcd713ba20758';
// const apiKey = 'API_KEY';
const openWeatherMapCURRENT = 'https://api.openweathermap.org/data/2.5/weather';
const openWeatherMap5dPer3h = 'https://api.openweathermap.org/data/2.5/forecast';

class WeatherHelper {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapCURRENT?q=$cityName&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    LocationHelper location = LocationHelper();
    Position pos = await location.determinePosition();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapCURRENT?lat=${pos.latitude}&lon=${pos.longitude}&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getWeatherForecast48h7d({
    required String exclude,
    required String lon,
    required String lat,
  }) async {
    /// Exclude: (String) --> current/minutely/hourly/daily/alerts (write one of these)
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMap5dPer3h?lat=$lat&lon=$lon&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    print('getWeatherForecast: \n${weatherData.toString()}');
    return weatherData;
  }

  WeatherIcon getWeatherIcon(int condition) {
    if (condition < 0) {
      /// Negative numbers in case weatherData loaded with an error
      return WeatherIcon( FontAwesomeIcons.faceGrinBeamSweat, Colors.yellow); //'🤷‍';
    }else if (condition < 300) {
      return WeatherIcon(FontAwesomeIcons.bolt, Colors.yellow); //'🌩';
    } else if (condition < 400) {
      return WeatherIcon(
          FontAwesomeIcons.cloudShowersHeavy, Colors.lightBlue); //'🌧';
    } else if (condition < 600) {
      return WeatherIcon(
          FontAwesomeIcons.cloudRain, Colors.lightBlue); //'☔️';
    } else if (condition < 700) {
      return WeatherIcon(
          FontAwesomeIcons.snowflake, Colors.lightBlue); //'☃️';
    } else if (condition < 800) {
      return WeatherIcon(FontAwesomeIcons.smog, Colors.lightBlue); //'🌫';
    } else if (condition == 800) {
      return WeatherIcon(Icons.wb_sunny, Colors.yellow); //'☀️';//'☀️';
    } else if (condition <= 804) {
      return WeatherIcon(Icons.cloud, Colors.lightBlue); //'☁️';
    } else {
      return WeatherIcon(
          FontAwesomeIcons.faceGrinBeamSweat, Colors.yellow); //'🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s ice cream time';
    } else if (temp >= 20) {
      return 'Time for shorts and t-shirt';
    } else if (temp < 10) {
      return 'You\'ll need scarf and glove';
    } else {
      return 'Bring a coat just in case';
    }
  }
}
