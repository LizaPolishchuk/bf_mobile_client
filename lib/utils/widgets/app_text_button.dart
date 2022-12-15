import 'package:flutter/material.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);
  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: buttonSheetText,
      ),
    );
  }
}
