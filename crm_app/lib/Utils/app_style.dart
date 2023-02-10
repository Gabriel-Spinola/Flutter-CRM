import 'package:flutter/material.dart';

Color primary = const Color(0xFF687daf);

class Styles {
  static Color primaryColor = primary;
  static Color textColor = const Color(0xFF3b3b3b);
  static Color bgColor = const Color(0xFFeeedf2);
  static Color orangeColor = const Color(0xFFF37B67);
  static Color kakiColor = const Color(0xFFd2bdd6);

  static TextStyle textStyle =
      TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle headLine1Style =
      TextStyle(fontSize: 26, color: textColor, fontWeight: FontWeight.bold);
  static TextStyle headLine2Style =
      TextStyle(fontSize: 21, color: textColor, fontWeight: FontWeight.bold);
  static TextStyle headLine3Style = TextStyle(
      fontSize: 17, color: Colors.grey.shade500, fontWeight: FontWeight.w500);
  static TextStyle headLine4Style = TextStyle(
      fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500);
}
