import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

///TextInputs
Widget textFieldWithBorders(
  String labelText,
  TextEditingController controller, {
  String? errorText,
  String? prefixText,
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
      errorText: errorText,
      labelStyle: hintText1,
      prefixStyle: bodyText1,
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

///Buttons
Widget buttonWithText(BuildContext context, String text, VoidCallback onPressed,
    {Color? buttonColor, double? width}) {
  return SizedBox(
    height: 50,
    width: 226,
    child: ElevatedButton(
      onPressed: onPressed,
      style: buttonColor != null
          ? ButtonStyle(backgroundColor: MaterialStateProperty.all(buttonColor))
          : Theme.of(context).elevatedButtonTheme.style,
      child: Text(text),
    ),
  );
}

///Image
Widget imageWithPlaceholder(String? imageUrl, String placeholder) {
  return FadeInImage(
      imageErrorBuilder: (context, error, _) {
        return Image.asset(placeholder);
      },
      image: NetworkImage(imageUrl ?? ""),
      placeholder: AssetImage(placeholder));
}


/// Dialogs
showLoaderDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Text("Loading..."),
          ),
        ],
      ),
    ),
  );
}

stopLoaderDialog(BuildContext context) {
  Navigator.of(context).pop();
}

/// Margins
SizedBox marginVertical(double value) {
  return SizedBox(height: value);
}

SizedBox marginHorizontal(double value) {
  return SizedBox(width: value);
}
