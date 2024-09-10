import 'package:flutter/material.dart';

class WeatherIcon {
  IconData _iconData;
  Color _color;

  WeatherIcon(this._iconData, this._color);

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }

  IconData get iconData => _iconData;

  set iconData(IconData value) {
    _iconData = value;
  }
}
