import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/utils/app_images.dart';

import 'app_colors.dart';
import 'app_strings.dart';
import 'app_styles.dart';

///TextInputs
Widget textFieldWithBorders(
  String labelText,
  TextEditingController controller, {
  String? errorStr,
  String? prefixText,
  bool enabled = true,
  TextInputType? keyboardType,
  int? maxLength,
  FormFieldValidator<String>? validator,
}) {
  return TextFormField(
    controller: controller,
    style: bodyText1,
    validator: validator,
    maxLength: maxLength,
    keyboardType: keyboardType ?? TextInputType.text,
    decoration: InputDecoration(
      prefixText: prefixText,
      labelText: labelText,
      errorText: errorStr,
      errorStyle: errorText,
      labelStyle: hintText1,
      prefixStyle: bodyText1,
      enabled: enabled,
      counterText: "",
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightGrey, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: lightGrey, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    ),
  );
}

Widget searchTextField(TextEditingController? controller,
    {String? hintText, double? topAndBottomPadding, bool isEnabled = true}) {
  return Material(
    color: bgGrey,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50))),
    elevation: 12.0,
    shadowColor: blurColor,
    child: TextFormField(
      controller: controller,
      enabled: isEnabled,
      textCapitalization: TextCapitalization.sentences,
      style: hintText2.copyWith(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText ?? tr(AppStrings.search),
        hintStyle: hintText2,
        prefixIcon: Padding(
            padding: EdgeInsets.only(
                top: topAndBottomPadding ?? 14,
                bottom: topAndBottomPadding ?? 14,
                right: 6,
                left: 22),
            // add padding to adjust icon
            child: SvgPicture.asset(icSearch)),
        contentPadding: const EdgeInsets.all(0),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x17000000), width: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x17000000), width: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x17000000), width: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
    ),
  );
}

///Buttons
Widget roundedButton(BuildContext context, String text, VoidCallback onPressed,
    {Color? buttonColor, double? height}) {
  return FittedBox(
    child: Container(
      height: height ?? 50,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonColor != null
            ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor))
            : Theme.of(context).elevatedButtonTheme.style,
        child: Text(text),
      ),
    ),
  );
}

Widget buttonMoreWithRightArrow(
    {required VoidCallback onPressed,
    String? text,
    Color? color,
    double? width}) {
  return InkWell(
    child: Row(
      children: [
        Text(text ?? tr(AppStrings.more),
            style: bodyText1.copyWith(color: color ?? primaryColor)),
        marginHorizontal(4),
        SvgPicture.asset(
          icArrowRight,
          color: color ?? primaryColor,
        ),
      ],
    ),
    onTap: onPressed,
  );
}

///Image
Widget imageWithPlaceholder(String? imageUrl, String placeholder) {
  return FadeInImage(
      imageErrorBuilder: (context, error, _) {
        return Image.asset(
          placeholder,
          fit: BoxFit.fill,
        );
      },
      fit: BoxFit.fill,
      image: NetworkImage(imageUrl ?? ""),
      placeholder: AssetImage(placeholder));
}

Widget emptyListPlaceholderW(String imagePlaceholder, String text) {
  return Column();
}

/// Margins
SizedBox marginVertical(double value) {
  return SizedBox(height: value);
}

SizedBox marginHorizontal(double value) {
  return SizedBox(width: value);
}
