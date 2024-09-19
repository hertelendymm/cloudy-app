import 'package:cloudy_app/models/forecast_model.dart';
import 'package:flutter/material.dart';

class ListTileWeatherDaily extends StatelessWidget {
  const ListTileWeatherDaily({
    super.key,
    required this.forecast,
  });

  final ForecastModel forecast;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(forecast.timeText,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 22.0,
                          fontFamily: 'Spartan MB',
                          // fontWeight: FontWeight.bold,
                        ))),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 20.0),
                    child: Icon(
                      forecast.weatherIcon.iconData,
                      color: forecast.weatherIcon.color,
                      size: 40.0,
                    )),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(forecast.tempText,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20.0,
                        fontFamily: 'Spartan MB',
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              // const SizedBox(width: 0.0),
            ],
          ),
        ],
      ),
    );
  }
}
