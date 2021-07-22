import 'package:flutter/material.dart';


Widget imageWithPlaceholder(String? imageUrl, String placeholder) {
  return FadeInImage(
        imageErrorBuilder: (context, error, _) {
          return Image.asset(placeholder);
        },
        image: NetworkImage(imageUrl ?? ""),
        placeholder: AssetImage(placeholder));
}

/// Margins
SizedBox marginVertical(double value) {
  return SizedBox(height: value);
}

SizedBox marginHorizontal(double value) {
  return SizedBox(width: value);
}

