import 'package:flutter/material.dart';

abstract class CesType {
  abstract Color color;
  abstract String type;
}

class Donational extends CesType {
  @override
  Color color = const Color.fromARGB(255, 181, 245, 184);
  @override
  String type = "Donational";
}

class Educational extends CesType {
  @override
  Color color = const Color.fromARGB(255, 141, 183, 218);
  @override
  String type = "Educational";
}

class Outreach extends CesType {
  @override
  Color color = Color.fromARGB(255, 255, 220, 168);
  @override
  String type = "Outreach";
}

class Default extends CesType {
  @override
  Color color = const Color.fromARGB(255, 250, 169, 163);
  @override
  String type = "Default";
}


class CesManager { 
  
  
  static CesType getType(String type) { 
    switch(type) {
      case "Educational": return Educational();
      case "Donational": return Donational();
      case "Outreach": return Outreach();
    }
    return Default();
  }
}