import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

RandomColor _randomColor = RandomColor();
Color _color = _randomColor.randomColor();
Color _color2 = _randomColor.randomColor();

const List<Color> kpageGr = [
  Color(0xFFc31432),
  Color(0xFF240b36),
];

Gradient khomePageGr = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      _color,
      _color2,
    ]);
