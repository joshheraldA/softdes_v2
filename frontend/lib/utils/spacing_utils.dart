import 'package:flutter/material.dart';


class SpacingUtils {

  static double widthSpacing(BuildContext context, double widthMultiplier) {
    return MediaQuery.of(context).size.width * widthMultiplier;
  } 

  static double heightSpacing(BuildContext context, double heightMultiplier) {
    return MediaQuery.of(context).size.height * heightMultiplier;
  }
}