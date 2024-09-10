import 'package:cloudy_app/models/weathericon_model.dart';
import 'package:cloudy_app/services/location.dart';
import 'package:cloudy_app/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

const apiKey = 'API_KEY';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    Position pos = await location.determinePosition();
    // await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${pos.latitude}&lon=${pos.longitude}&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  WeatherIcon getWeatherIcon(int condition) {
    if (condition < 300) {
      return new WeatherIcon(FontAwesomeIcons.bolt, Colors.yellow); //'🌩';
    } else if (condition < 400) {
      return new WeatherIcon(
          FontAwesomeIcons.cloudShowersHeavy, Colors.lightBlue); //'🌧';
    } else if (condition < 600) {
      return new WeatherIcon(
          FontAwesomeIcons.cloudRain, Colors.lightBlue); //'☔️';
    } else if (condition < 700) {
      return new WeatherIcon(
          FontAwesomeIcons.snowflake, Colors.lightBlue); //'☃️';
    } else if (condition < 800) {
      return new WeatherIcon(FontAwesomeIcons.smog, Colors.lightBlue); //'🌫';
    } else if (condition == 800) {
      return new WeatherIcon(Icons.wb_sunny, Colors.yellow); //'☀️';//'☀️';
    } else if (condition <= 804) {
      return new WeatherIcon(Icons.cloud, Colors.lightBlue); //'☁️';
    } else {
      return new WeatherIcon(
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
