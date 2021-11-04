import 'package:flutter/material.dart';
import 'package:weather_app/localization.dart';
import 'package:weather_app/weather_models.dart';
import 'package:weather_app/widgets/weather_widgets.dart';
import 'package:weather_app/widgets/hours_list.dart';
import 'package:weather_app/widgets/days_list.dart';
import 'package:weather_app/weather_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key ?key}): super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  bool hourly = true;

  bool ready = false;
  bool updating = false;

  List<WeatherHour> ?hours;
  List<WeatherDay> ?days;
  WeatherCurrent ?current;
  String ?city;

  void update() {
    if (mounted) {
      setState(() {
      ready = WeatherController.instance.ready;
      updating = WeatherController.instance.updating;
      hours = WeatherController.instance.hourly;
      days = WeatherController.instance.daily;
      current = WeatherController.instance.current;
      city = WeatherController.instance.city;
    });
    }
  }

  @override
  void initState() {
    super.initState();

    ready = WeatherController.instance.ready;
    updating = WeatherController.instance.updating;
    hours = WeatherController.instance.hourly;
    days = WeatherController.instance.daily;
    current = WeatherController.instance.current;
    city = WeatherController.instance.city;
    WeatherController.instance.onUpdate = update;
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (ready) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 5),
          if ((current != null) && (city != null)) WeatherCurrentWidget(current!, city!, loading: updating,),
          const SizedBox(height: 16),
          if (hourly) Text(Localization.getValue('Hourly forecast'), style: const TextStyle(color: Colors.white),),
          if (!hourly) Text(Localization.getValue('Daily forecast'), style: const TextStyle(color: Colors.white),),
          const SizedBox(height: 16),
          if ((hours!= null) && hourly) Expanded(child: HoursList(hours!)),
          if ((days!= null) && !hourly) Expanded(child: DaysList(days!)),
          const SizedBox(height: 3),
        ],
      );
    } else {
      body = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Localization.getValue('Loading data...'), style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            const CircularProgressIndicator()
          ],
        )
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(Localization.getValue('Weather')),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            enabled: true,
            onSelected: (item) {
              setState(() {
                hourly = (item == 0);
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text(Localization.getValue('Hourly'))
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(Localization.getValue('Daily'))
              ),
            ],
          )
        ]
      ),
      body: body
    );
  }
}

