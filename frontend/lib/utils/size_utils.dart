import 'package:flutter/material.dart';


class SizeUtils {

  static double width(BuildContext context, double widthMultiplier) {
    return MediaQuery.of(context).size.width * widthMultiplier;
  } 

  static double height(BuildContext context, double heightMultiplier) {
    return MediaQuery.of(context).size.height * heightMultiplier;
  }
}