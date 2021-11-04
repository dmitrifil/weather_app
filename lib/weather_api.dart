import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:weather_app/weather_models.dart';

const String _key = '556f7397cd96f153108648b694c9417b';

_toDouble(dynamic v) => (v is int) ? (v as int).toDouble() : v;

Future<Map<String, Map>?> _get(String host, String path, [Map<String, dynamic>? parameters]) async {
  Uri _uri = Uri.http(host, path, parameters);
  try {
    Map<String, String> _headers = {"Content-type": "application/json"};
    final httpResponse = await http.get(_uri, headers: _headers);
    if (httpResponse.statusCode != 200) return null;
    return {'body': convert.jsonDecode(httpResponse.body), 'headers': httpResponse.headers};
  } on Exception catch (e) {
    return null;
  }
}

WeatherCondition decodeCondition(int code) {
  if ((code >= 200) && (code <= 299)) return WeatherCondition.Thunderstorm;
  if ((code >= 300) && (code <= 399)) return WeatherCondition.ShowerRain;
  if ((code >= 500) && (code <= 504)) return WeatherCondition.Rain;
  if (code == 511) return WeatherCondition.Snow;
  if ((code >= 520) && (code <= 599)) return WeatherCondition.ShowerRain;
  if ((code >= 600) && (code <= 699)) return WeatherCondition.Snow;
  if ((code >= 700) && (code <= 799)) return WeatherCondition.Mist;
  if (code == 800) return WeatherCondition.ClearSky;
  if (code == 801) return WeatherCondition.FewClouds;
  if (code == 802) return WeatherCondition.ScatteredClouds;
  if ((code >= 803) && (code <= 804)) return WeatherCondition.BrokenClouds;
  return WeatherCondition.ClearSky;
}

Future<Map<String, dynamic>?> getWeatherData(double latitude, double longitude) async {
  final responce = await _get('api.openweathermap.org', '/data/2.5/onecall', {'lat': latitude.toString(), 'lon': longitude.toString(), 'exclude': 'minute,alerts', 'appid': _key});
  if (responce == null) return null;
  final Map<String, dynamic> result = {};
  try {
    final hourly = responce['body']!['hourly'];
    if (hourly is! List<dynamic>) return null;
    List<WeatherHour> hours = (hourly as List).map((e) {
      final m = (e as Map);
      final hour = WeatherHour();
      hour.time = DateTime.fromMillisecondsSinceEpoch(m['dt'] * 1000);
      hour.temp = _toDouble(m['temp']);
      hour.condition = decodeCondition((m['weather'] as List).first['id']);
      hour.windSpeed = _toDouble(m['wind_speed']);
      hour.pop = _toDouble(m['pop']) * 100;
      hour.feelsLike = _toDouble(m['feels_like']);
      hour.humidity = _toDouble(m['humidity']);
      return hour;
    }).toList(growable: false);
    result['hourly'] = hours;

    final daily = responce['body']!['daily'];
    if (daily is! List<dynamic>) return null;
    List<WeatherDay> days = (daily as List).map((e) {
      final m = (e as Map);
      final day = WeatherDay();
      day.time = DateTime.fromMillisecondsSinceEpoch(m['dt'] * 1000);

      day.tempDay = _toDouble(m['temp']['day']);
      day.tempNight = _toDouble(m['temp']['night']);
      day.tempMorning = _toDouble(m['temp']['morn']);
      day.tempEvening = _toDouble(m['temp']['eve']);

      day.feelsLikeDay = _toDouble(m['feels_like']['day']);
      day.feelsLikeNight = _toDouble(m['feels_like']['night']);
      day.feelsLikeMorning = _toDouble(m['feels_like']['morn']);
      day.feelsLikeEvening = _toDouble(m['feels_like']['eve']);

      day.condition = decodeCondition((m['weather'] as List).first['id']);
      day.windSpeed = _toDouble(m['wind_speed']);
      day.humidity = _toDouble(m['humidity']);
      day.pop = _toDouble(m['pop']) * 100;
      return day;
    }).toList(growable: false);
    result['daily'] = days;

    final cw = responce['body']!['current'];
    if (cw is! Map<String, dynamic>) return null;
    final current = WeatherCurrent();
    current.time = DateTime.fromMillisecondsSinceEpoch(cw['dt'] * 1000);
    current.temp = _toDouble(cw['temp']);
    current.condition = decodeCondition((cw['weather'] as List).first['id']);
    current.windSpeed = _toDouble(cw['wind_speed']);
    current.feelsLike = _toDouble(cw['feels_like']);
    current.humidity = _toDouble(cw['humidity']);
    result['current'] = current;

    return result;
  }
  catch (e) {
    return null;
  }
}