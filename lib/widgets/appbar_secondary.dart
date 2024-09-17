import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarSecondary extends StatelessWidget {
  const AppBarSecondary({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Icon(FontAwesomeIcons.angleLeft,
                      color: Colors.white, size: 24.0),
                ),
              ),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontFamily: 'Spartan MB',
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 38.0)
            ],
          ),
        ),
        Container(
            width: double.infinity, height: 1, color: Colors.grey.shade900)
      ],
    );
  }
}
