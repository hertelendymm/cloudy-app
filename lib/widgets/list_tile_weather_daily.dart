import 'package:cloudy_app/models/forecast_model.dart';
import 'package:flutter/material.dart';

class ListTileWeatherDaily extends StatelessWidget {
  const ListTileWeatherDaily(
      {super.key, required this.forecast, required this.index});

  final ForecastModel forecast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        children: [
          index == 0
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ),
    );
  }
}
