import 'package:cloudy_app/constants.dart';
import 'package:cloudy_app/models/weather_model.dart';
import 'package:cloudy_app/models/weathericon_model.dart';
import 'package:cloudy_app/pages/forecast_page.dart';
import 'package:cloudy_app/pages/loading_page.dart';
import 'package:cloudy_app/pages/search_page.dart';
import 'package:cloudy_app/services/theme_provider.dart';
import 'package:cloudy_app/services/weather_helper.dart';
import 'package:cloudy_app/widgets/button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WeatherModel forecastModel;
  var weatherData;
  bool _isLoading = true;
  String otherLocation = "";
  bool isDarkThemeOn = true;
  WeatherIcon weatherIcon =
      WeatherIcon(FontAwesomeIcons.circleExclamation, Colors.red);

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    if (otherLocation != '') {
      /// Load other location's data
      weatherData = await WeatherHelper().getCityWeather(otherLocation);
    } else {
      /// Load currents location's data
      weatherData = await WeatherHelper().getLocationWeather();
    }
    await loadWeatherData();
  }

  Future<void> loadWeatherData() async {
    if (weatherData != null) {
      setState(() {
        forecastModel = WeatherModel.fromJson(weatherData);
        weatherIcon =
            WeatherHelper().getWeatherIcon(int.parse(forecastModel.condition));
      });
    } else {
      forecastModel = WeatherModel(
          lon: "0.0",
          lat: "0.0",
          temperature: "0",
          condition: "-1",
          description: "Unable to get weather data",
          cityName: "Error");
      weatherIcon = WeatherIcon(FontAwesomeIcons.circleExclamation, Colors.red);
    }
    setState(() {
      _isLoading = false;
      print('Loading is done.');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.surface,
      // statusBarIconBrightness: Theme.of(context).brightness,
    ));
    return Scaffold(
      appBar: null, // Remove the default app bar
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: _isLoading ? const LoadingPage() : _currentLocation()),
    );
  }

  Widget _currentLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _myAppBar(),
          _weatherTitle(),
          Icon(weatherIcon.iconData, color: weatherIcon.color, size: 140.0),
          _weatherDescription(),
          Row(
            children: [
              Flexible(
                child: ButtonRounded(
                  text: 'Forecast',
                  backgroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  textColor: Theme.of(context).colorScheme.primary,
                  function: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForecastPage(
                                cityName: forecastModel.cityName,
                                lat: forecastModel.lat,
                                lon: forecastModel.lon,
                              ))),
                ),
              ),
              const SizedBox(width: 24.0),
              // const SizedBox(height: 12.0),
              Flexible(
                child: ButtonRounded(
                    text: 'Search City',
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    textColor: Theme.of(context).colorScheme.primary,
                    function: () async {
                      var typedCityName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SearchPage();
                      }));
                      if (typedCityName != null) {
                        setState(() {
                          _isLoading = true;
                          otherLocation = typedCityName;
                        });
                        getLocationData();
                      }
                    }),
              )
            ],
          ),
          // const SizedBox(height: 0.0),
          Text('Made by hertelendymm',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Spartan MB',
              )),
        ],
      ),
    );
  }

  Widget _myAppBar() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.06),
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              /// Change appTheme  and refresh app
              setState(() {
                // isDarkThemeOn = !isDarkThemeOn;
                _isLoading = true;
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              });
              getLocationData();
              // saveSelectedCategory();
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 14.0),
              child: Icon(FontAwesomeIcons.solidLightbulb,
                  color: Theme.of(context).colorScheme.primary),
              // child: const Icon(FontAwesomeIcons.lightbulb, color: Colors.white),
            ),
          ),
          Text('Cloudy App',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Spartan MB',
                  color: Theme.of(context).colorScheme.primary)),
          GestureDetector(
              onTap: () async {
                /// Refresh Button
                setState(() {
                  otherLocation = '';
                  _isLoading = true;
                });
                getLocationData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 14.0),
                child: Icon(
                  FontAwesomeIcons.rotate,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )),
        ],
      ),
    );
  }

  Widget _weatherTitle() {
    return Column(
      children: [
        Text('Current weather:',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Spartan MB',
                fontSize: 20.0,
                color: Theme.of(context).colorScheme.primary)),
        Text(forecastModel.description.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Spartan MB',
                fontSize: 24.0,
                color: Theme.of(context).colorScheme.primary)),
      ],
    );
  }

  Widget _weatherDescription() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.temperatureHalf,
                color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 6.0),
            Text('${forecastModel.temperature}°C',
                style: TextStyle(
                    fontFamily: 'Spartan MB',
                    fontSize: 34.0,
                    color: Theme.of(context).colorScheme.primary))
          ],
        ),
        Text(
          forecastModel.cityName,
          style: TextStyle(
              fontFamily: 'Spartan MB',
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
