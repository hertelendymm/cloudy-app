import 'package:cloudy_app/models/forecast_model.dart';
import 'package:flutter/material.dart';

class ListTileWeatherHourly extends StatelessWidget {
  const ListTileWeatherHourly({
    super.key,
    required this.forecast,
  });

  final ForecastModel forecast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                        child: Text(forecast.timeText,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16.0,
                              fontFamily: 'Spartan MB',
                              fontWeight: FontWeight.bold,
                            )))),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Icon(
                      forecast.weatherIcon.iconData,
                      color: forecast.weatherIcon.color,
                      size: 40.0,
                    )),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(forecast.mainText,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Spartan MB',
                            fontSize: 14.0)),
                    Text(forecast.descriptionText,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.3)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                // flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                      child: Text(forecast.tempText,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text('Next Day',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontFamily: 'Spartan MB',
                              fontWeight: FontWeight.bold)),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 1.0,
                        color: Theme.of(context).colorScheme.primary,
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
