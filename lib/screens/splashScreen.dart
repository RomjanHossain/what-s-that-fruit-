import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:what_s_that_fruit/cons.dart';
import 'package:what_s_that_fruit/screens/homePage.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  Timer _timer;
  int _start = 5;

// init
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: _start,
      navigateAfterSeconds: MyHomePage(),
      title: Text(
        'Welcome to \n \t\t\t\t\t\tWTF',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 50,
          color: Color(0xFF2ecc71),
        ),
      ),
      imageBackground: AssetImage('assets/images/bg-tr.png'),
      loaderColor: Color(0xFFeb2f06),
      gradientBackground: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: kpageGr,
      ),
      loadingText: Text(
        '$_start',
        style: TextStyle(
          fontSize: 70,
          color: Color(0xFF2ecc71),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
