import 'package:flutter/material.dart';

class ButtonRounded extends StatelessWidget {
  ButtonRounded({
    // required this.isNightMode,
    required this.function,
    required this.text,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    // this.isActive = false,
  });

  // final bool isNightMode;
  final Function function;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  // final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> function(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80.0,
        color: backgroundColor,
        // height: MediaQuery.of(context).size.height * 0.1,
        // decoration: BoxDecoration(
        //     color: isNightMode
        //         ? Colors.white.withOpacity(0.1)
        //         : Colors.black.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(10.0),
        //     border: isActive
        //         ? Border.all(
        //       // width: isActive ? 5.0 : 0.0,
        //       width: 5.0,
        //       color: isNightMode
        //           ? Colors.white.withOpacity(0.2)
        //           : Colors.black.withOpacity(0.2),
        //     )
        //         : Border.all(
        //       width: 0.0,
        //       color: isNightMode
        //           ? Colors.white.withOpacity(0.1)
        //           : Colors.black.withOpacity(0.1),
        //     )),
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
