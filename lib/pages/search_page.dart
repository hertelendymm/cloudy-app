import 'package:cloudy_app/constats.dart';
import 'package:cloudy_app/widgets/button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(FontAwesomeIcons.angleLeft,
              color: Colors.white, size: 40.0),
        ),
        title: const Text('Search', style: kCityTitleTextStyleNight),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(24.0),
                    child: TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: kTextFieldInputDecorationNight,
                        onChanged: (value) {
                          cityName = value;
                        })),
                ButtonRounded(
                    text: 'Get Weather',
                    isNightMode: true,
                    function: () {
                      print('Close Serach Page');
                      Navigator.pop(context, cityName);
                      print('Search page closed');
                    })
              ],
            ),
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
    );
  }
}
