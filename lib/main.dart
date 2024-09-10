import 'package:cloudy_app/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      title: 'Flutter Demo',
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
  var weatherData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // _isLoading = true;
    getLocationData();
  }

  void getLocationData() async {
    weatherData = await WeatherModel().getLocationWeather();
    print("$weatherData=====================");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _loadingPage() : _currentLocation();
    // return Scaffold(
    //   body: SafeArea(child: _isLoading ?
    //   const CircularProgressIndicator():
    //   Container(child: Text(weatherData.toString()),),
    //   ),
    // );
  }

  Widget _loadingPage(){
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _currentLocation(){
    return Scaffold(
      // backgroundColor: isNight ? Color(0xFF333B49) : Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor: isNight ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        // backgroundColor: isNight ? Color(0xFF333B49) : Colors.white,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // backgroundColor: isNight ? Colors.black : Colors.white,
        leading: GestureDetector(
          onTap: () async {
            var weatherData = await weather.getLocationWeather();
            updateUI(weatherData);
          },
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Icon(
              FontAwesomeIcons.syncAlt,
              color: Theme.of(context).iconTheme.color,
              // color: isNight ? Colors.white : Colors.black,
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Cloudy App',
            style: kCityTitleTextStyleNight.copyWith(
              fontSize: 20.0,
              color: Theme.of(context).iconTheme.color,
              // color: isNight ? Colors.white : Colors.black,
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              var weatherData = await weather.getLocationWeather();
              updateUI(weatherData);
              build(context);
            },
            child: ChangeThemeButtonWidget(),
          ),
          // showThemeChangerButton(),
          GestureDetector(
            onTap: () async {
              var typedName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CityScreen();
                    // return CityScreen(isNight: isNight);
                  },
                ),
              );
              if (typedName != null) {
                var weatherData = await weather.getCityWeather(typedName);
                updateUI(weatherData);
              }
            },
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Icon(
                FontAwesomeIcons.searchLocation,
                color: Theme.of(context).iconTheme.color,
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
                          color: Theme.of(context).iconTheme.color,
                          // color: isNight ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        '${description.toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: kCityTextStyle.copyWith(
                          fontSize: 20.0,
                          color: Theme.of(context).iconTheme.color,
                          // color: isNight ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    weatherIcon.iconData,
                    color: weatherIcon.color,
                    size: MediaQuery.of(context).size.width / 3,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.thermometerHalf,
                            color: Theme.of(context).iconTheme.color,
                            // color: isNight ? Colors.white : Colors.black,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            '$temperature°C',
                            style: kTempTextStyle.copyWith(
                              fontSize: 25.0,
                              color: Theme.of(context).iconTheme.color,
                              // color: isNight ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$cityName',
                        style: kTempTextStyle.copyWith(
                          fontSize: 16.0,
                          color: Theme.of(context).iconTheme.color,
                          // color: isNight ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  ButtonRounded(
                    isNightMode: themeProvider.isDarkMode,
                    function: () {
                      showInterstitialAd();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForecastScreen(
                              lat: lat,
                              lon: lon,
                              // isNight: isNight,
                            )),
                      );
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
