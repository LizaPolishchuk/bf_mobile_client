import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
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
  String? hintText,
  String? errorStr,
  String? prefixText,
  Widget? prefixIcon,
  TextCapitalization? textCapitalization,
  BoxConstraints? prefixIconConstraints,
  bool enabled = true,
  TextInputType? keyboardType,
  int? maxLength,
  FocusNode? focusNode,
  List<TextInputFormatter>? inputFormatters,
  FormFieldValidator<String>? validator,
}) {
  return TextFormField(
    controller: controller,
    style: bodyText1,
    validator: validator,
    maxLength: maxLength,
    textCapitalization: textCapitalization ?? TextCapitalization.none,
    focusNode: focusNode,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType ?? TextInputType.text,
    decoration: InputDecoration(
      prefixIconConstraints: prefixIconConstraints,
      prefixText: prefixText,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
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

Widget _buildButtonContainer({required Widget child, double? width}) {
  if (width == null) {
    return FittedBox(child: child);
  }
  return child;
}

Widget roundedButton(BuildContext context, String text, VoidCallback onPressed,
    {Color? buttonColor, Color? textColor, double? height, double? width}) {
  return _buildButtonContainer(
    width: width,
    child: Container(
      height: height ?? 50,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonColor != null
            ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor))
            : Theme.of(context).elevatedButtonTheme.style,
        child: Text(
          text,
          style:
              textColor != null ? buttonText.copyWith(color: textColor) : null,
        ),
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
  return ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: Image.network(
      imageUrl ?? "",
      height: 64,
      width: 64,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          child: const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Image.asset(
        placeholder,
        fit: BoxFit.cover,
      ),
    ),
  );
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
