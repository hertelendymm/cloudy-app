import 'package:cloudy_app/constats.dart';
import 'package:cloudy_app/models/forecast_model.dart';
import 'package:cloudy_app/models/weather_model.dart';
import 'package:cloudy_app/services/weather_helper.dart';
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
  List<ForecastModel> _dailyBank = [];

  @override
  void initState() {
    super.initState();
    getDataForecast();
  }

  void getDataForecast() async {
    weatherData = await WeatherHelper().getWeatherForecast48h7d(
      exclude: 'hourly,daily',
      lat: widget.lat,
      lon: widget.lon,
    );
    print('weatherData: $weatherData');

    setState(() {
        /// 3 Hourly data
        hourlyData = weatherData['list'];
        List jsonListHourly = hourlyData;
        for (var element in jsonListHourly) {
          int id = element['weather'][0]['id'];
          DateTime date = DateTime.fromMillisecondsSinceEpoch(element['dt'] * 1000);
          int hour = date.hour;
          String period = hour >= 12 ? 'PM' : 'AM';
          hour = hour % 12;
          hour = hour == 0 ? 12 : hour;
          String formattedTime = '${hour.toString().padLeft(2, '0')} $period';
          print(formattedTime);
          ForecastModel forecastModel = ForecastModel(
            weatherIcon: WeatherHelper().getWeatherIcon(id),
            mainText: element['weather'][0]['main'],
            descriptionText: element['weather'][0]['description'],
            timeText: formattedTime,
            // timeText: dateString,
            tempText: '${(element['main']['temp']).round()}°C',
          );
          _hourlyBank.add(forecastModel);
          print(forecastModel.timeText);
        }
        print('_hourlyBank: ${_hourlyBank.length}\n${_hourlyBank[0]}');
    });

    // setState(() {
    //   /// Hourly data
    //   hourlyData = weatherData['hourly'];
    //   List jsonListHourly = hourlyData;
    //   for (var element in jsonListHourly) {
    //     int id = element['weather'][0]['id'];
    //     DateTime date = DateTime.fromMillisecondsSinceEpoch(element['dt'] * 1000);
    //     // var format = DateFormat("j");
    //     // var dateString = format.format(date);
    //     ForecastModel forecastModel = ForecastModel(
    //       weatherIcon: WeatherHelper().getWeatherIcon(id),
    //       mainText: element['weather'][0]['main'],
    //       descriptionText: element['weather'][0]['description'],
    //       timeText: '$date',
    //       // timeText: dateString,
    //       tempText: '${(element['temp']).round()}°C',
    //     );
    //     _hourlyBank.add(forecastModel);
    //   }
    //   print('_hourlyBank: ${_hourlyBank.length}\n${_hourlyBank[0]}');

      // /// Daily data
      // _dailyBank = weatherData['daily'];
      // List jsonListDaily = hourlyData;
      // for (var element in jsonListDaily) {
      //   int id = element['weather'][0]['id'];
      //   DateTime date = DateTime.fromMillisecondsSinceEpoch(element['dt'] * 1000);
      //   // var format = DateFormat("EEEE");
      //   // var dateString = format.format(date);
      //   // print('dateString: $dateString');
      //   ForecastModel forecastModel = ForecastModel(
      //     weatherIcon: WeatherHelper().getWeatherIcon(id),
      //     mainText: element['weather'][0]['main'],
      //     descriptionText: element['weather'][0]['description'],
      //     timeText: '$date',
      //     // timeText: dateString,
      //     tempText: '${(element['temp']['day']).round()}°C',
      //   );
      //   _dailyBank.add(forecastModel);
      // }
    // });
    // print('_dailyBank: ${_dailyBank.length}\n${_dailyBank[0]}');

  }

  _switchView(){
    setState(() {
      isHourlyPage != isHourlyPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: ()=> Navigator.pop(context),
          icon: const Icon(
            FontAwesomeIcons.angleLeft,
            color: Colors.white,
            size: 40.0
          )
        ),
        title: const Text(
            'Forecast',
            style: kCityTitleTextStyleNight
        )
      ),
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: ButtonRounded(
                  function: ()=> _switchView(),
                  isNightMode: true,
                  isActive: isHourlyPage,
                  text: '48 hour'
                ),
              ),
              SizedBox(width: 20.0),
              Flexible(
                child: ButtonRounded(
                    function: ()=> _switchView(),
                    isNightMode: true,
                    isActive: !isHourlyPage,
                    text: '7 day'
                ),
              ),
            ],
          ),
        ),
          hourlyData == null ? loadingScreen() : showForecastContent(),
      ],
      ),),
    );
  }

  Widget loadingScreen() {
    return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
  }

  Widget showForecastContent() {
    return Flexible(
        child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 16,
                // itemCount: _hourlyBank.length,
                itemBuilder: (BuildContext context, int index) {
                  return weatherHourlyListTile(
                    forecast: _hourlyBank[index]
                  );
                }),
      )
          // : Expanded(
          //   child: ListView.builder(
          //       padding: const EdgeInsets.all(8),
          //       itemCount: _dailyBank.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         return weatherDailyListTile(
          //           forecast: _dailyBank[index],
          //         );
          //       })
          // ),
    ;
  }

  Widget weatherHourlyListTile({
    required ForecastModel forecast
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(8.0),
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
                          fontSize: 14.0,
                        )),
                    Text(forecast.descriptionText,
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.3,
                          // fontFamily: 'Spartan MB',
                          // fontSize: 14.0,
                          // fontWeight: FontWeight.w300,
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(forecast.tempText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            // fontSize: 20.0,
                            fontFamily: 'Spartan MB',
                            fontWeight: FontWeight.bold,
                          ))),
                ),
              ),
            ],
          ),
          (forecast.timeText == '10 PM' || forecast.timeText == '11 PM' ||forecast.timeText ==  '12 AM')
              ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 1.0,
                  color: Colors.white,
                ),
                const Text('Next Day',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Spartan MB',
                        fontWeight: FontWeight.bold)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 1.0,
                  color: Colors.white,
                ),
              ],
            ),
          ) : const SizedBox()
        ],
      ),
    );
  }

  Widget weatherDailyListTile({
    required ForecastModel forecast,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                forecast.weatherIcon.iconData,
                color: forecast.weatherIcon.color,
                size: 40.0,
              )),
          const SizedBox(width: 20.0),
          Expanded(
            flex: 2,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(forecast.timeText,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'Spartan MB',
                      // fontWeight: FontWeight.bold,
                    ))),
          ),
        ],
      ),
    );
  }
}
