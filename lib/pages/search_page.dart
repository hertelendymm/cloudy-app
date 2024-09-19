import 'package:cloudy_app/constats.dart';
import 'package:cloudy_app/widgets/appbar_secondary.dart';
import 'package:cloudy_app/widgets/button_rounded.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String cityName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSecondary(title: 'Search'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                // padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: kTextFieldInputDecorationNight,
                          onChanged: (value) {
                            cityName = value;
                          })),
                  ButtonRounded(
                      text: 'Get Weather',
                      backgroundColor: Colors.white.withOpacity(0.2),
                      // isNightMode: true,
                      function: () {
                        Navigator.pop(context, cityName);
                      }),
                  const SizedBox(height: 20.0),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Made by hertelendymm',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                        Text('Data provided by OpenWeatherMap',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
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
