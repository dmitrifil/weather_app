import 'package:weather_app/weather_models.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/localization.dart';
import 'package:weather_app/weather_api.dart';
import 'package:hive/hive.dart';

class WeatherController {

  static WeatherController ?_instance;
  static WeatherController get instance{
    if (_instance == null) _instance = WeatherController();
    return _instance!;
  }

  bool ready = false;
  bool updating = true;

  List<WeatherDay> ?daily;
  List<WeatherHour> ?hourly;
  WeatherCurrent ?current;
  String ?city;

  void Function() ?onUpdate;

  double lat = 0;
  double lon = 0;

  WeatherController();

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _retryData() async {

    await Future.delayed(Duration(milliseconds: 10000), (){});

    final data = await getWeatherData(lat, lon);
    if (data != null) {
      hourly = data['hourly'];
      daily = data['daily'];
      current = data['current'];

      var box = await Hive.openBox('data');
      box.put('daily', daily);
      box.put('hourly', hourly);
      box.put('current', current);
      box.put('city', city);

      ready = true;
      updating = false;
      onUpdate?.call();
    } else {
      _retryData();
    }
  }

  void start() async {

    var box = await Hive.openBox('data');

    daily = box.get('daily')?.cast<WeatherDay>();
    hourly = box.get('hourly')?.cast<WeatherHour>();
    current = box.get('current');
    city = box.get('city');

    // final List<dynamic> ld = box.get('daily');
    // if (ld != null) daily = ld.cast<WeatherDay>();
    // final List<dynamic> lh = box.get('hourly');
    // if (lh != null) hourly = lh.cast<WeatherHour>();
    // current = box.get('current');
    // city = box.get('city');

    if ((daily != null) && (hourly != null) && (current != null) && (city != null)) {
      ready = true;
      onUpdate?.call();
    }

    bool located = false;
    try {
      final position = await _determinePosition();
      lat = position.latitude;
      lon = position.longitude;
      located = true;
    } catch (e) {}

    if (located) {
      try {
        final placemarks = await placemarkFromCoordinates(lat, lon);
        if (placemarks.isNotEmpty) {
          city = placemarks.first.locality;
          if (city == null) located = false;
        }
        else {
          located = false;
        }
      } catch (e) {located = false;}
    }

    if (!located) {
      city = 'Kiev';
      lat = 50.4547;
      lon = 30.5238;
    }

    final data = await getWeatherData(lat, lon);
    if (data != null) {
      hourly = data['hourly'];
      daily = data['daily'];
      current = data['current'];

      box.put('daily', daily);
      box.put('hourly', hourly);
      box.put('current', current);
      box.put('city', city);

      ready = true;
      updating = false;
      onUpdate?.call();
    }
    else {
      _retryData();
    }

  }
}