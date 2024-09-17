import 'package:cloudy_app/constats.dart';
import 'package:cloudy_app/models/forecast_model.dart';
import 'package:cloudy_app/models/weather_model.dart';
import 'package:cloudy_app/pages/loading_page.dart';
import 'package:cloudy_app/services/weather_helper.dart';
import 'package:cloudy_app/widgets/appbar_secondary.dart';
import 'package:cloudy_app/widgets/button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/weathericon_model.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key, required this.lon, required this.lat});

  final String lon;
  final String lat;

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  var weatherData;
  var weatherDataLoading;
  bool isHourlyPage = true;
  var hourlyData;
  List<ForecastModel> _hourlyBank = [];

  // List<ForecastModel> _dailyBank = [];
  List<ForecastModel> _forecastBank = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getDataForecast();
  }

  void getDataForecast() async {
    // setState(() async {
    _forecastBank.clear();
    // _dailyBank.clear();
    _hourlyBank.clear();

    weatherData = await WeatherHelper().getWeatherForecast48h7d(
        exclude: 'hourly,daily', lat: widget.lat, lon: widget.lon);
    print('weatherData: $weatherData');

    // setState(() async {
    //   _forecastBank.clear();
    //   _forecastBank.add(await getDailyData());
    //   _forecastBank.add(await getHourlyData());
    // });

    /// Clear Forecast Data

    /// 3 Hourly data
    hourlyData = weatherData['list'];
    List jsonListHourly = hourlyData;
    for (var element in jsonListHourly) {
      int id = element['weather'][0]['id'];
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(element['dt'] * 1000);
      int hour = dateTime.hour;
      List<int> date = [dateTime.year, dateTime.month, dateTime.day];
      String period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      hour = hour == 0 ? 12 : hour;
      String formattedTime = '${hour.toString().padLeft(2, '0')} $period';
      ForecastModel forecastModel = ForecastModel(
        weatherIcon: WeatherHelper().getWeatherIcon(id),
        mainText: element['weather'][0]['main'],
        descriptionText: element['weather'][0]['description'],
        timeText: formattedTime,
        isDailyForecast: false,
        dateTime: date,
        tempText: '${(element['main']['temp']).round()}°C',
      );
      _hourlyBank.add(forecastModel);
      // print(forecastModel.toString());
    }
    print('_hourlyBank: ${_hourlyBank.length}\n${_hourlyBank[0]}');

    /// Group hourly forecasts by day using fold
    Map<DateTime, List<ForecastModel>> groupedForecasts =
        _hourlyBank.fold<Map<DateTime, List<ForecastModel>>>(
      {},
      (map, forecast) {
        final date = DateTime(
            forecast.dateTime[0], forecast.dateTime[1], forecast.dateTime[2]);
        if (map.containsKey(date)) {
          map[date]!.add(forecast);
        } else {
          map[date] = [forecast];
        }
        return map;
      },
    );

    /// Calculate average temperature and create daily forecasts
    groupedForecasts.forEach((date, hourlyForecasts) {
      double averageTemp = hourlyForecasts
              .map((forecast) => double.parse(
                  forecast.tempText.substring(0, forecast.tempText.length - 2)))
              .reduce((sum, temp) => sum + temp) /
          hourlyForecasts.length;
      String dayOfWeek = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ][date.toLocal().weekday - 1];
      ForecastModel mostFrequentForecast =
          findMostFrequentForecast(hourlyForecasts);

      _forecastBank.add(ForecastModel(
        weatherIcon: mostFrequentForecast.weatherIcon,
        mainText: mostFrequentForecast.mainText,
        descriptionText: mostFrequentForecast.descriptionText,
        timeText: dayOfWeek,
        // Set a consistent timeText for daily forecasts
        isDailyForecast: true,
        dateTime: [
          date.toLocal().year,
          date.toLocal().month,
          date.toLocal().day
        ],
        // Convert DateTime to [year, month, day]
        tempText: "${averageTemp.round()}°C",
      ));
      // _dailyBank.add(ForecastModel(
      //   weatherIcon: mostFrequentForecast.weatherIcon,
      //   mainText: mostFrequentForecast.mainText,
      //   descriptionText: mostFrequentForecast.descriptionText,
      //   timeText: dayOfWeek,
      //   // Set a consistent timeText for daily forecasts
      //   dateTime: [
      //     date.toLocal().year,
      //     date.toLocal().month,
      //     date.toLocal().day
      //   ],
      //   // Convert DateTime to [year, month, day]
      //   tempText: "${averageTemp.round()}°C",
      // ));
    });

    /// Add hourly data to the _forecastBank
    // for (var item in _hourlyBank) {
    for (int i = 0; i < 17; i++) {
      _forecastBank.add(_hourlyBank[i]);
      // _forecastBank.add(item);
    }
    /// refresh UI
    setState(() {
      _isLoading = false;
      print("Loading is done.");
    });
  }

  ForecastModel findMostFrequentForecast(List<ForecastModel> forecasts) {
    Map<ForecastModel, int> frequencyMap = {};
    forecasts.forEach((forecast) {
      frequencyMap[forecast] = (frequencyMap[forecast] ?? 0) + 1;
    });

    ForecastModel mostFrequentForecast = forecasts.first;
    int maxFrequency = 0;
    frequencyMap.forEach((forecast, frequency) {
      if (frequency > maxFrequency) {
        mostFrequentForecast = forecast;
        maxFrequency = frequency;
      }
    });

    return mostFrequentForecast;
  }

  @override
  Widget build(BuildContext context) {
    print("$_isLoading================");
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //     elevation: 0.0,
      //     backgroundColor: Colors.black,
      //     centerTitle: true,
      //     leading: IconButton(
      //         onPressed: () => Navigator.pop(context),
      //         icon: const Icon(FontAwesomeIcons.angleLeft,
      //             color: Colors.white, size: 40.0)),
      //     title: const Text('Forecast', style: kCityTitleTextStyleNight)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          // padding: const EdgeInsets.all(20.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBarSecondary(title: 'Forecast'),
              // SizedBox(height: 12.0),
              // _forecastBank.length < 40
              _isLoading ? LoadingPage() : showForecastContent(),
              // _forecastBank == [] ? loadingScreen() : showForecastContent(),
              // hourlyData == null ? loadingScreen() : showForecastContent(),
              // SizedBox(height: 12.0),
              // Container(
              //   decoration: BoxDecoration(
              //       color: Colors.grey.withOpacity(0.1),
              //       // borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.white.withOpacity(0.05),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Flexible(
              //             child: ButtonRounded(
              //                 function: () {
              //                   setState(() {
              //                     isHourlyPage = true;
              //                   });
              //                 },
              //                 backgroundColor: isHourlyPage
              //                     ? Colors.black
              //                     : Colors.transparent,
              //                 text: '48 hour')),
              //         // const SizedBox(width: 20.0),
              //         Flexible(
              //             child: ButtonRounded(
              //                 function: () {
              //                   setState(() {
              //                     isHourlyPage = false;
              //                   });
              //                 },
              //                 backgroundColor: isHourlyPage
              //                     ? Colors.transparent
              //                     : Colors.black,
              //                 // backgroundColor: Colors.white.withOpacity(0.2),
              //                 text: '5 day')),
              //       ],
              //     ),
              //   ),
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: 1.0,
              //   margin: EdgeInsets.fromLTRB(0, 20.0, 0.0, 8.0),
              //   color: Colors.white,
              // ),
              // SizedBox(height: 12.0),
              // hourlyData == null ? loadingScreen() : showForecastContent(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget loadingScreen() {
  //   return const Expanded(
  //     child: Center(
  //       child: CircularProgressIndicator(color: Colors.white),
  //     ),
  //   );
  // }

  Widget showForecastContent() {
    print('_forecastBank: $_forecastBank');
    print('length: ${_forecastBank.length}');
    return Flexible(
      child: ListView.builder(
        // padding: const EdgeInsets.all(8),
        itemCount: _forecastBank.length,
        itemBuilder: (BuildContext context, int index) {
          if (_forecastBank[index].isDailyForecast) {
            return weatherDailyListTile(
                forecast: _forecastBank[index], index: index);
          } else {
            return weatherHourlyListTile(
                forecast: _forecastBank[index], index: index);
          }
        },
      ),
    );
    // return Flexible(
    //     child: isHourlyPage
    //         ? ListView.builder(
    //             // padding: const EdgeInsets.all(8),
    //             itemCount: 16,
    //             itemBuilder: (BuildContext context, int index) {
    //               return weatherHourlyListTile(forecast: _hourlyBank[index]);
    //             })
    //         : ListView.builder(
    //             // padding: const EdgeInsets.all(8),
    //             itemCount: _dailyBank.length,
    //             itemBuilder: (BuildContext context, int index) {
    //               return weatherDailyListTile(forecast: _dailyBank[index]);
    //             }));
  }

  Widget weatherDailyListTile(
      {required ForecastModel forecast, required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        children: [
          index == 0
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text("Daily forecast",
                      Text("DAILY FORECAST",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20.0,
                            fontFamily: 'Spartan MB',
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 10.0),
                      Container(
                          width: double.infinity,
                          height: 5,
                          color: Colors.grey.shade400)
                    ],
                  ),
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(forecast.timeText,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'Spartan MB',
                          // fontWeight: FontWeight.bold,
                        ))),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  child: Icon(
                    forecast.weatherIcon.iconData,
                    color: forecast.weatherIcon.color,
                    size: 40.0,
                  )),
              Expanded(
                // flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Center(
                      child: Text(forecast.tempText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Spartan MB',
                            fontWeight: FontWeight.bold,
                          ))),
                ),
              ),
              // const SizedBox(width: 0.0),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Expanded(
          //       // flex: 1,
          //       child: Padding(
          //         padding: const EdgeInsets.all(0.0),
          //         child: Center(
          //             child: Text(forecast.tempText,
          //                 style: const TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 20.0,
          //                   fontFamily: 'Spartan MB',
          //                   fontWeight: FontWeight.bold,
          //                 ))),
          //       ),
          //     ),
          //     Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          //         child: Icon(
          //           forecast.weatherIcon.iconData,
          //           color: forecast.weatherIcon.color,
          //           size: 40.0,
          //         )),
          //     // const SizedBox(width: 0.0),
          //     Expanded(
          //       flex: 2,
          //       child: Padding(
          //           padding: const EdgeInsets.all(0.0),
          //           child: Text(forecast.timeText,
          //               textAlign: TextAlign.left,
          //               style: const TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 26.0,
          //                 fontFamily: 'Spartan MB',
          //                 // fontWeight: FontWeight.bold,
          //               ))),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget weatherHourlyListTile(
      {required ForecastModel forecast, required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          index == 6
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text("Daily forecast",
                      Text("48 HOUR FORECAST",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20.0,
                            fontFamily: 'Spartan MB',
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 10.0),
                      Container(
                          width: double.infinity,
                          height: 5,
                          color: Colors.grey.shade400)
                    ],
                  ),
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // flex: 2,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                        child: Text(forecast.timeText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Spartan MB',
                              fontWeight: FontWeight.bold,
                            )))),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Icon(
                    forecast.weatherIcon.iconData,
                    color: forecast.weatherIcon.color,
                    size: 40.0,
                  )),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(forecast.mainText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Spartan MB',
                            fontSize: 14.0)),
                    Text(forecast.descriptionText,
                        style: const TextStyle(
                            color: Colors.white, letterSpacing: 0.3)),
                  ],
                ),
              ),
              Expanded(
                // flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                      child: Text(forecast.tempText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Spartan MB',
                            fontWeight: FontWeight.bold,
                          ))),
                ),
              ),
            ],
          ),
          (forecast.timeText == '10 PM' ||
                  forecast.timeText == '11 PM' ||
                  forecast.timeText == '12 AM')
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 1.0,
                        color: Colors.white,
                      ),
                      const Text('Next Day',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Spartan MB',
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
