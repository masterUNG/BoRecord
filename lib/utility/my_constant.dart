import 'package:flutter/material.dart';

class MyConstant {
  // General
  static String appName = 'Bo Record';
  static String domain = 'https://5a3bdf815b44.ngrok.io';

  // Route
  static String routeAuthen = '/authen';
  static String routeServiceApp = '/serviceApp';
  static String routeAddData = '/addData';

  // Color
  static Color primary = Color(0xff3A64C2);
  static Color dark = Color(0xff003b91);
  static Color light = Color(0xff7391f5);

  // Image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';

  // Style
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: dark,
      );
  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: dark,
      );
  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: dark,
      );
}
