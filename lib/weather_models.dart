
import 'package:hive/hive.dart';

enum WeatherCondition {
  ClearSky,
  FewClouds,
  ScatteredClouds,
  BrokenClouds,
  ShowerRain,
  Rain,
  Thunderstorm,
  Snow,
  Mist,
}

class WeatherConditionAdapter extends TypeAdapter<WeatherCondition> {
  @override
  final typeId = 1;

  @override
  WeatherCondition read(BinaryReader reader) {return WeatherCondition.values[reader.read()];}

  @override
  void write(BinaryWriter writer, WeatherCondition obj) {writer.write(obj.index);}
}

class WeatherDay {
  DateTime time;

  WeatherCondition condition;

  double tempDay;
  double tempNight;
  double tempEvening;
  double tempMorning;
  double tempMin;
  double tempMax;

  double feelsLikeDay;
  double feelsLikeNight;
  double feelsLikeEvening;
  double feelsLikeMorning;

  double humidity;
  double windSpeed;
  double pop;

  WeatherDay({
    time,
    this.condition = WeatherCondition.ClearSky,
    this.tempDay = 0,
    this.tempNight = 0,
    this.tempEvening = 0,
    this.tempMorning = 0,
    this.tempMin = 0,
    this.tempMax = 0,
    this.feelsLikeDay = 0,
    this.feelsLikeNight = 0,
    this.feelsLikeEvening = 0,
    this.feelsLikeMorning = 0,
    this.humidity = 0,
    this.windSpeed = 0,
    this.pop = 0
  }): time = time ?? DateTime.fromMillisecondsSinceEpoch(0);

}

class WeatherDayAdapter extends TypeAdapter<WeatherDay> {
  @override
  final typeId = 2;

  @override
  WeatherDay read(BinaryReader reader) {
    final map = reader.read();
    return WeatherDay(
        time: map['time'],
        condition: map['condition'],
        tempDay: map['tempDay'],
        tempNight: map['tempNight'],
        tempEvening: map['tempEvening'],
        tempMorning: map['tempMorning'],
        tempMin: map['tempMin'],
        tempMax: map['tempMax'],
        feelsLikeDay: map['feelsLikeDay'],
        feelsLikeNight: map['feelsLikeNight'],
        feelsLikeEvening: map['feelsLikeEvening'],
        feelsLikeMorning: map['feelsLikeMorning'],
        humidity: map['humidity'],
        windSpeed: map['windSpeed'],
        pop: map['pop'],
    );
  }

  @override
  void write(BinaryWriter writer, WeatherDay obj) {
    final map = {
      'time': obj.time,
      'condition': obj.condition,
      'tempDay': obj.tempDay,
      'tempNight': obj.tempNight,
      'tempEvening': obj.tempEvening,
      'tempMorning': obj.tempMorning,
      'tempMin': obj.tempMin,
      'tempMax': obj.tempMax,
      'feelsLikeDay': obj.feelsLikeDay,
      'feelsLikeNight': obj.feelsLikeNight,
      'feelsLikeEvening': obj.feelsLikeEvening,
      'feelsLikeMorning': obj.feelsLikeMorning,
      'humidity': obj.humidity,
      'windSpeed': obj.windSpeed,
      'pop': obj.pop,
    };
    writer.write(map);
  }
}

class WeatherHour {
  DateTime time;
  WeatherCondition condition;
  double temp;
  double feelsLike;
  double humidity;
  double windSpeed;
  double pop;

  WeatherHour({
    time,
    this.condition = WeatherCondition.ClearSky,
    this.temp = 0,
    this.feelsLike = 0,
    this.humidity = 0,
    this.windSpeed = 0,
    this.pop = 0,
  }) :time = time ?? DateTime.fromMillisecondsSinceEpoch(0);

}

class WeatherHourAdapter extends TypeAdapter<WeatherHour> {
  @override
  final typeId = 3;

  @override
  WeatherHour read(BinaryReader reader) {
    final map = reader.read();
    return WeatherHour(
      time: map['time'],
      condition: map['condition'],
      temp: map['temp'],
      feelsLike: map['feelsLike'],
      humidity: map['humidity'],
      windSpeed: map['windSpeed'],
      pop: map['pop']
    );
  }

  @override
  void write(BinaryWriter writer, WeatherHour obj) {
    final map = {
      'time': obj.time,
      'condition': obj.condition,
      'temp': obj.temp,
      'feelsLike': obj.feelsLike,
      'humidity': obj.humidity,
      'windSpeed': obj.windSpeed,
      'pop': obj.pop
    };
    writer.write(map);
  }
}

class WeatherCurrent {
  DateTime time;
  WeatherCondition condition;
  double temp;
  double feelsLike;
  double humidity;
  double windSpeed;

  WeatherCurrent({
    time,
    this.condition = WeatherCondition.ClearSky,
    this.temp = 0,
    this.feelsLike = 0,
    this.humidity = 0,
    this.windSpeed = 0,
  }) :time = time ?? DateTime.fromMillisecondsSinceEpoch(0);

}

class WeatherCurrentAdapter extends TypeAdapter<WeatherCurrent> {
  @override
  final typeId = 4;

  @override
  WeatherCurrent read(BinaryReader reader) {
    final map = reader.read();
    return WeatherCurrent(
        time: map['time'],
        condition: map['condition'],
        temp: map['temp'],
        feelsLike: map['feelsLike'],
        humidity: map['humidity'],
        windSpeed: map['windSpeed'],
    );
  }

  @override
  void write(BinaryWriter writer, WeatherCurrent obj) {
    final map = {
      'time': obj.time,
      'condition': obj.condition,
      'temp': obj.temp,
      'feelsLike': obj.feelsLike,
      'humidity': obj.humidity,
      'windSpeed': obj.windSpeed
    };
    writer.write(map);
  }
}
