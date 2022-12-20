import 'package:flutter/material.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class AppGestureDetectorPhoto extends StatelessWidget {
  const AppGestureDetectorPhoto(
      {Key? key, required this.onTap, required this.text})
      : super(key: key);
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: 58,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: buttonSheetText,
          ),
        ),
      ),
    );
  }
}
