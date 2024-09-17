import 'package:cloudy_app/models/forecast_model.dart';
import 'package:flutter/material.dart';

class ListTileWeatherHourly extends StatelessWidget {
  const ListTileWeatherHourly(
      {super.key, required this.forecast, required this.index});

  final ForecastModel forecast;
  final int index;

  @override
  Widget build(BuildContext context) {
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
