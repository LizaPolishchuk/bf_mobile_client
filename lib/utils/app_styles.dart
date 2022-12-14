import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData mainTheme = ThemeData(
  scaffoldBackgroundColor: bgGrey,
  appBarTheme: AppBarTheme(
    backgroundColor: bgGrey,
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    titleTextStyle: appBarText,
    centerTitle: true,
    elevation: 0,
  ),
  colorScheme: ColorScheme.light(primary: primaryColor, secondary: accentColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(primaryColor),
          textStyle: MaterialStateProperty.all(buttonText),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )))),
);

final TextStyle hintText1 = TextStyle(color: greyText, fontSize: 13);
final TextStyle hintText2 =
    TextStyle(color: greyText, fontSize: 16, fontWeight: FontWeight.w400);

final TextStyle bodyText1 = TextStyle(color: darkGreyText, fontSize: 13);
final TextStyle bodyText2 =
    TextStyle(color: greyText, fontSize: 18, fontWeight: FontWeight.w300);
final TextStyle bodyText3 =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600);
final TextStyle bodyText4 =
    TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
final TextStyle bodyText5 =
    TextStyle(color: darkGreyText, fontSize: 10, fontWeight: FontWeight.w500);
final TextStyle bodyText6 =
    TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500);

final TextStyle titleText1 =
    TextStyle(color: primaryColor, fontSize: 25, fontWeight: FontWeight.bold);
final TextStyle titleText2 =
    TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600);
final TextStyle titleText3 =
    TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700);

final TextStyle appBarText =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500);
final TextStyle buttonText =
    TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
final TextStyle calendarText =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400);

final TextStyle errorText = TextStyle(fontSize: 12, color: errorRed);

cardShadow({double? borderRadius}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius ?? 10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(color: blurColor, blurRadius: 8, offset: Offset(0, 3))
    ],
  );
}

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
