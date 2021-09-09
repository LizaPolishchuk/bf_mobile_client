import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData mainTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(backgroundColor: Colors.white),
  colorScheme: ColorScheme.light(primary: primaryColor, secondary: accentColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
          // textStyle: MaterialStateProperty.all(buttonText1),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )))),
);

final TextStyle hintText1 = TextStyle(color: greyText, fontSize: 13);
final TextStyle bodyText1 = TextStyle(color: darkGreyText, fontSize: 13);

final TextStyle text12W500 = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1F2937));
final TextStyle text12W600 = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1F2937));
final TextStyle text14W600 = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937));
final TextStyle text16W600 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2937));
final TextStyle text16W400 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF1F2937));
final TextStyle text20W700 = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1F2937));
