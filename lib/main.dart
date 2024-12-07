import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/weather_app.dart';


void main() {
  // setting the background color of the system bottom navigation
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const WeatherApp());
}
