import 'package:cloudy_app/constats.dart';
import 'package:cloudy_app/models/forecast_model.dart';
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
  bool _isCurrentLoctaion = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (_isCurrentLoctaion) {
      getCurrentLocationData();
    }
    // if(weatherData != null) {
    //   loadWeatherData();
    // }else{
    //   print("WEATHER DATA IS NULL HERE -------------------");
    // }
  }

  void getCurrentLocationData() async {
    weatherData = await WeatherServices().getLocationWeather();
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
        print(forecastModel.toString());
      });
    } else {
      print("WEATHER DATA IS NULL HERE -------------------");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _loadingPage() : _currentLocation();
  }

  Widget _loadingPage() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _currentLocation() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () async {
            /// Refresh Button
            setState(() {
              _isCurrentLoctaion = false;
            });
            // var weatherData = await weather.getLocationWeather();
            // updateUI(weatherData);
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
                    return SearchPage();
                    // return CityScreen(isNight: isNight);
                  },
                ),
              );
              if (typedName != null) {
                WeatherServices newWeather = WeatherServices();
                weatherData = await newWeather.getCityWeather(typedName);
                setState(() {
                  _isCurrentLoctaion = false;
                });
                // updateUI(weatherData);
              }
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Icon(
                FontAwesomeIcons.magnifyingGlassLocation,
                color: Theme
                    .of(context)
                    .iconTheme
                    .color,
                // color: isNight ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Current weather:',
                        textAlign: TextAlign.center,
                        style: kCityTextStyle.copyWith(
                          fontSize: 16.0,
                          color: Theme
                              .of(context)
                              .iconTheme
                              .color,
                          // color: isNight ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        '${forecastModel.description.toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: kCityTextStyle.copyWith(
                          fontSize: 20.0,
                          color: Theme
                              .of(context)
                              .iconTheme
                              .color,
                          // color: isNight ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    WeatherServices().getWeatherIcon(int.parse(forecastModel.condition)) as IconData ,
                    color: weatherData.weatherIcon.color,
                    size: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.thermometerHalf,
                            color: Theme
                                .of(context)
                                .iconTheme
                                .color,
                            // color: isNight ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            '$forecastModel.temperature°C',
                            style: kTempTextStyle.copyWith(
                              fontSize: 25.0,
                              color: Theme
                                  .of(context)
                                  .iconTheme
                                  .color,
                              // color: isNight ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        forecastModel.cityName,
                        style: kTempTextStyle.copyWith(
                          fontSize: 16.0,
                          color: Theme
                              .of(context)
                              .iconTheme
                              .color,
                          // color: isNight ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  ButtonRounded(
                    text: 'Forecast',
                    isNightMode: true,
                    function: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           ForecastScreen(
                      //             lat: lat,
                      //             lon: lon,
                      //             // isNight: isNight,
                      //           )),
                      // );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
