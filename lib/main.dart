import 'package:flutter/material.dart';
import 'package:flutter_application_1/Activity/home.dart';
import 'package:flutter_application_1/Activity/location.dart';
import 'package:flutter_application_1/Activity/loading.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => Loading(),
        "/home": (context) => Home(),
        "/location": (context) => Location(),
        "/loading": (context) => Loading(),
      },
    ),
  );
}
