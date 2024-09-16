import 'package:flutter/material.dart';

class ButtonRounded extends StatelessWidget {
  const ButtonRounded({
    super.key,
    required this.function,
    required this.text,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
  });

  final Function function;
  final String text;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> function(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(text,
              style: TextStyle(
                color: textColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }
}
