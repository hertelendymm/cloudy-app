import 'package:cloudy_app/models/forecast_model.dart';
import 'package:cloudy_app/pages/loading_page.dart';
import 'package:cloudy_app/services/weather_helper.dart';
import 'package:cloudy_app/widgets/appbar_secondary.dart';
import 'package:cloudy_app/widgets/list_tile_weather_daily.dart';
import 'package:cloudy_app/widgets/list_tile_weather_hourly.dart';
import 'package:cloudy_app/widgets/title_divider_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage(
      {super.key,
      required this.lon,
      required this.lat,
      required this.cityName});

  final String lon;
  final String lat;
  final String cityName;

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  var weatherData;
  var hourlyData;
  List<ForecastModel> _hourlyBank = [];
  List<Widget> _forecastBank = [];
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

    /// Get weatherData from OpenWeatherMap
    weatherData = await WeatherHelper().getWeatherForecast48h7d(
        exclude: 'hourly,daily', lat: widget.lat, lon: widget.lon);

    /// Collecting 3 Hourly data to hourly data
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
    }

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

    /// Add title widget for the ListView.builder
    _forecastBank.add(const TitleDividerTile(title: "DAILY FORECAST"));

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

      ForecastModel foreacastOfTheDay = ForecastModel(
        weatherIcon: mostFrequentForecast.weatherIcon,
        mainText: mostFrequentForecast.mainText,
        descriptionText: mostFrequentForecast.descriptionText,
        timeText: dayOfWeek,
        isDailyForecast: true,
        dateTime: [
          date.toLocal().year,
          date.toLocal().month,
          date.toLocal().day
        ],
        tempText: "${averageTemp.round()}°C",
      );
      _forecastBank.add(ListTileWeatherDaily(forecast: foreacastOfTheDay));
    });

    ///Add space between daily and hourlu data
    _forecastBank.add(const SizedBox(height: 40.0));

    /// Add title widget for the ListView.builder
    _forecastBank.add(const TitleDividerTile(title: "48 HOUR FORECAST"));

    /// Add hourly data to the _forecastBank
    for (int i = 0; i < 17; i++) {
      _forecastBank.add(ListTileWeatherHourly(forecast: _hourlyBank[i]));
    }

    _forecastBank.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
            child: Text('Data provided by OpenWeatherMap',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12.0,
                    fontFamily: 'Spartan MB'))),
      ),
    );

    /// refresh UI
    setState(() {
      _isLoading = false;
      print("Loading is done.");
    });
  }

  /// Finding the most frequent value for daily weatherIcon; mainText; descriptionText
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.surface));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(children: [
          AppBarSecondary(title: widget.cityName),
          _isLoading
              ? const Expanded(child: LoadingPage())
              : showForecastContent(),
        ]),
      ),
    );
  }

  Widget showForecastContent() {
    return Flexible(
      child: ListView.builder(
          itemCount: _forecastBank.length,
          itemBuilder: (BuildContext context, int index) {
            return _forecastBank[index];
          }),
    );
  }
}
