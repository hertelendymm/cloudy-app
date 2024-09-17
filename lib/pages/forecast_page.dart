import 'package:cloudy_app/constats.dart';
import 'package:cloudy_app/models/forecast_model.dart';
import 'package:cloudy_app/models/weather_model.dart';
import 'package:cloudy_app/pages/loading_page.dart';
import 'package:cloudy_app/services/weather_helper.dart';
import 'package:cloudy_app/widgets/appbar_secondary.dart';
import 'package:cloudy_app/widgets/button_rounded.dart';
import 'package:cloudy_app/widgets/list_tile_weather_daily.dart';
import 'package:cloudy_app/widgets/list_tile_weather_hourly.dart';
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
    /// Clear Forecast Data
    _forecastBank.clear();
    _hourlyBank.clear();

    weatherData = await WeatherHelper().getWeatherForecast48h7d(
        exclude: 'hourly,daily', lat: widget.lat, lon: widget.lon);
    print('weatherData: $weatherData');

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
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBarSecondary(title: 'Forecast'),
            // SizedBox(height: 12.0),
            // _forecastBank.length < 40
            _isLoading ? const LoadingPage() : showForecastContent(),
          ],
        ),
      ),
    );
  }


  Widget showForecastContent() {
    print('_forecastBank: $_forecastBank');
    print('length: ${_forecastBank.length}');
    return Flexible(
      child: ListView.builder(
        // padding: const EdgeInsets.all(8),
        itemCount: _forecastBank.length,
        itemBuilder: (BuildContext context, int index) {
          if (_forecastBank[index].isDailyForecast) {
            return ListTileWeatherDaily(forecast: _forecastBank[index], index: index);
            // return weatherDailyListTile(
            //     forecast: _forecastBank[index], index: index);
          } else {
            return ListTileWeatherHourly(forecast: _forecastBank[index], index: index);
            // return weatherHourlyListTile(
            //     forecast: _forecastBank[index], index: index);
          }
        },
      ),
    );
  }
}
