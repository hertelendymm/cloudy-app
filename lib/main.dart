import 'package:cloudy_app/constats.dart';
import 'package:cloudy_app/models/weather_model.dart';
import 'package:cloudy_app/models/weathericon_model.dart';
import 'package:cloudy_app/pages/forecast_page.dart';
import 'package:cloudy_app/pages/loading_page.dart';
import 'package:cloudy_app/pages/search_page.dart';
import 'package:cloudy_app/services/weather_helper.dart';
import 'package:cloudy_app/widgets/button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloudy ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WeatherModel forecastModel;
  var weatherData;
  bool _isLoading = true;
  String otherLocation = "";
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
    return Scaffold(
      backgroundColor: Colors.black,
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
                  backgroundColor: Colors.white.withOpacity(0.2),
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
                    backgroundColor: Colors.white.withOpacity(0.2),
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
          const SizedBox(height: 0.0),
        ],
      ),
    );
  }

  Widget _myAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              /// Change appTheme in SharedPref and refresh app
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 14.0),
              child: const Icon(FontAwesomeIcons.solidLightbulb,
                  color: Colors.white),
              // child: const Icon(FontAwesomeIcons.lightbulb, color: Colors.white),
            ),
          ),
          Text('Cloudy App',
              style: kCityTitleTextStyleNight.copyWith(
                  fontSize: 20.0, color: Colors.white)),
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
                child: const Icon(
                  FontAwesomeIcons.rotate,
                  color: Colors.white,
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
            style:
                kCityTextStyle.copyWith(fontSize: 20.0, color: Colors.white)),
        Text(forecastModel.description.toUpperCase(),
            textAlign: TextAlign.center,
            style:
                kCityTextStyle.copyWith(fontSize: 24.0, color: Colors.white)),
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
            const Icon(FontAwesomeIcons.temperatureHalf,
                color: Colors.white, size: 28),
            const SizedBox(width: 6.0),
            Text('${forecastModel.temperature}°C',
                style: kTempTextStyle.copyWith(
                    fontSize: 34.0, color: Colors.white))
          ],
        ),
        Text(
          forecastModel.cityName,
          style: kTempTextStyle.copyWith(fontSize: 20.0, color: Colors.white),
        ),
      ],
    );
  }
}
