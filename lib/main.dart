import 'package:flutter/material.dart';
import 'package:what_s_that_fruit/screens/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What\'s that fruit?',
      debugShowCheckedModeBanner: false,
      home: MySplashScreen(),
    );
  }
}
