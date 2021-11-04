import 'package:flutter/material.dart';
import 'package:weather_app/localization.dart';

class SplashScreen extends StatefulWidget {
  String nextScreen;

  SplashScreen(this.nextScreen);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 3000), () {
      Navigator.of(context).pushReplacementNamed(widget.nextScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Image(image: AssetImage('assets/OpenWeather-Logo.jpg'))
      ),
    );
  }
}

