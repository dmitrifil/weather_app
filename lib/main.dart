import 'package:flutter/material.dart';
import 'package:weather_app/splash_screen.dart';
import 'package:weather_app/home_screen.dart';
import 'package:weather_app/localization.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/weather_models.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:weather_app/weather_controller.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class Routes {
  static const splash = '/Splash';
  static const home = '/Home';
}

final routesMap = <String, WidgetBuilder>{
  Routes.splash : (_) => SplashScreen(Routes.home),
  Routes.home :   (_) => const HomeScreen(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  String ?localeStr = await Devicelocale.currentLocale;
  if (localeStr == null) {
    Localization.setLocale(const Locale('ru'));
  } else {
    Localization.setLocale((localeStr == 'ru_RU') ? const Locale('ru') : const Locale('en'));
  }

  Directory dir = await getApplicationDocumentsDirectory();
  var path = dir.path;  //Directory.current.path;
  Hive
    ..init(path)
    ..registerAdapter(WeatherHourAdapter())
    ..registerAdapter(WeatherDayAdapter())
    ..registerAdapter(WeatherConditionAdapter())
    ..registerAdapter(WeatherCurrentAdapter());
  // var box = await Hive.openBox('weather');

  // await box.put('test', hour);
  // final g = box.get('test');

  WeatherController.instance.start();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: routesMap,
      home: SplashScreen(Routes.home),
    );
  }
}

