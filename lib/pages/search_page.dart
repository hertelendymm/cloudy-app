import 'package:cloudy_app/widgets/appbar_secondary.dart';
import 'package:cloudy_app/widgets/button_rounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String cityName = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.surface));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSecondary(title: 'Search'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: TextField(
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              icon: Icon(
                                Icons.location_city,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              hintText: 'Enter City Name',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide.none)),
                          onChanged: (value) {
                            cityName = value;
                          })),
                  ButtonRounded(
                      text: 'Get Weather',
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      textColor: Theme.of(context).colorScheme.primary,
                      function: () => Navigator.pop(context, cityName)),
                  const SizedBox(height: 20.0),
                  Center(
                    child: Text('Data provided by OpenWeatherMap',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12.0,
                            fontFamily: 'Spartan MB')),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
