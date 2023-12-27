import 'package:flutter/material.dart';
class ColorUtils{
  static const Color customcolor = Color(0xFF841C6E);
  static MaterialColor createMaterialColor(Color color)
  {
    List<int> strengths = <int> [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;
    for(int strength in strengths)
      {
        swatch[strength] = Color.fromRGBO(r, g, b, strength/700);

      }
    return MaterialColor(color.value, swatch);

  }

}