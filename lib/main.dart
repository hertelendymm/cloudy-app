import 'package:cloudy_app/constats.dart';
import 'package:cloudy_app/models/forecast_model.dart';
import 'package:cloudy_app/models/weathericon_model.dart';
import 'package:cloudy_app/pages/forecast_page.dart';
import 'package:cloudy_app/pages/search_page.dart';
import 'package:cloudy_app/services/weather.dart';
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
  late ForecastModel forecastModel;
  var weatherData;
  bool _isLoading = true;
  // bool _isCurrentLocation = true;
  String otherLocation = "";
  WeatherIcon weatherIcon =
      WeatherIcon(FontAwesomeIcons.circleExclamation, Colors.red);

  @override
  void initState() {
    super.initState();
    print('Init State -------');
    // _isLoading = true;
    getLocationData();
    // if (_isCurrentLocation) {
    // getCurrentLocationData();
    // }
    // if(weatherData != null) {
    //   loadWeatherData();
    // }else{
    //   print("WEATHER DATA IS NULL HERE -------------------");
    // }
  }

  void getLocationData() async {
    if (otherLocation != '') {
      print('Other location: $otherLocation');
      /// TODO: Load other location's data
      weatherData = await WeatherServices().getCityWeather(otherLocation);
    } else {
      print('Current location');
      /// Load currents location's data
      weatherData = await WeatherServices().getLocationWeather();
    }

    print("$weatherData=====================");
    await loadWeatherData();
    // setState(() {
    //   _isLoading = false;
    // });
  }

  Future<void> loadWeatherData() async {
    if (weatherData != null) {
      setState(() {
        forecastModel = ForecastModel.fromJson(weatherData);
        weatherIcon = WeatherServices()
            .getWeatherIcon(int.parse(forecastModel.condition));
        print(forecastModel.toString());
        print("weatherIcon: ${weatherIcon.toString()}");
      });
    } else {
      print("WEATHER DATA IS NULL HERE -------------------");
      forecastModel = ForecastModel(
        lon: "0.0",
        lat: "0.0",
        temperature: "0",
        condition: "-1",
        description: "Unable to get weather data",
        cityName: "Error",
      );
      weatherIcon = WeatherIcon(FontAwesomeIcons.circleExclamation, Colors.red);
    }
    setState(() {
      _isLoading = false;
      print('Loading is done.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _loadingPage() : _currentLocation();
  }

  Widget _loadingPage() {
    return const Scaffold(
      backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white,)));
  }

  Widget _currentLocation() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            /// Refresh Button
            setState(() {
              otherLocation = '';
              _isLoading = true;
            });
            getLocationData();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Icon(
              FontAwesomeIcons.rotate,
              color: Colors.white,
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Cloudy App',
            style: kCityTitleTextStyleNight.copyWith(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          // GestureDetector(
          //   onTap: () async {
          //     // var weatherData = await weather.getLocationWeather();
          //     // updateUI(weatherData);
          //     // build(context);
          //     setState(() {
          //       _isLoading = true;
          //     });
          //   },
          //   child: ChangeThemeButtonWidget(),
          // ),
          // showThemeChangerButton(),
          GestureDetector(
            onTap: () async {
              var typedName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SearchPage();
                  },
                ),
              );
              if (typedName != null) {
                print('typeName: $typedName');
                setState(() {
                  _isLoading = true;
                  otherLocation = typedName;
                });
                getLocationData();
              }
            },
            child: const Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Icon(
                FontAwesomeIcons.magnifyingGlassLocation,
                color: Colors.white
              )
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _weatherTitle(),
            Icon(
              weatherIcon.iconData,
              color: weatherIcon.color,
              size: MediaQuery.of(context).size.width / 2.5,
            ),
            _weatherDescription(),
            ButtonRounded(
              text: 'Forecast',
              isNightMode: true,
              function: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ForecastPage(
                            lat: forecastModel.lat,
                            lon: forecastModel.lon,
                            // isNight: isNight,
                          ))
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _weatherTitle() {
    return Column(
      children: [
        Text('Current weather:',
            textAlign: TextAlign.center,
            style: kCityTextStyle.copyWith(
                fontSize: 20.0, color: Colors.white)),
        Text('${forecastModel.description.toUpperCase()}',
            textAlign: TextAlign.center,
            style: kCityTextStyle.copyWith(
                fontSize: 24.0, color: Colors.white)),
      ],
    );
  }

  Widget _weatherDescription(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              FontAwesomeIcons.temperatureHalf,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 6.0),
            Text(
              '${forecastModel.temperature}°C',
              style: kTempTextStyle.copyWith(
                fontSize: 34.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          forecastModel.cityName,
          style: kTempTextStyle.copyWith(
            fontSize: 20.0,
            color: Colors.white,
            // color: isNight ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
