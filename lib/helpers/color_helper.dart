import 'package:flutter/material.dart';

class ColorHelper {
  ColorHelper._();
  static const primaryColor = Color(0xff4dc9eb);
  static const secondaryColor = Color(0xffcee6f0);
  static const tertiaryColor = Color(0xffdfe0ff);
  static const errorColor = Color(0xffffdad6);
  static const backgroundColor = Color(0xfffbfcfe);
  static const primarySwatch = MaterialColor(
    0xff4dc9eb,
    <int, Color>{
      50: Color(0xffeaf9fd),
      100: Color(0xffcaeff9),
      200: Color(0xffa6e4f5),
      300: Color(0xff82d9f1),
      400: Color(0xff68d1ee),
      500: primaryColor,
      600: Color(0xff46c3e9),
      700: Color(0xff3dbce5),
      800: Color(0xff34b5e2),
      900: Color(0xff25a9dd),
    },
  );
}
