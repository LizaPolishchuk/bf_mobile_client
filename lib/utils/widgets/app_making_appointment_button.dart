import 'package:flutter/material.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/utils/app_components.dart';

import '../app_colors.dart';
import '../app_strings.dart';

class AppMakingAppointmentButton extends StatelessWidget {
  const AppMakingAppointmentButton(
      {Key? key,
      required this.makingAppontmentPressed,
      required this.favoritePressed,
      required this.iconFaforiteColor})
      : super(key: key);

  final VoidCallback makingAppontmentPressed;
  final VoidCallback favoritePressed;
  final Color iconFaforiteColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        roundedButton(
          context,
          tr(AppStrings.signUp),
          makingAppontmentPressed,
          width: MediaQuery.of(context).size.width * 0.75,
        ),
        //* Maybe modify roundedButton?
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.2,
          child: ElevatedButton(
            onPressed: favoritePressed,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(lightGrey)),
            child: Icon(
              Icons.star,
              size: 30,
              color: iconFaforiteColor,
            ),
          ),
        ),
      ],
    );
  }
}
