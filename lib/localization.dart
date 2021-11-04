import 'package:flutter/material.dart';

class Localization {

  static String _languageCode = 'en';

  static void setLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'ru': _languageCode = 'ru'; break;
      default: _languageCode = 'en';
    }
  }

  static String getValue(String key) {
    Map<String, String> ?item = _localization[key];
    if (item == null) return ''; else {
      return item[_languageCode] ?? (item['en'] ?? '');
    }
  }

  static const Map<String, Map<String, String>> _localization = {
    'Weather' : {
      'en' : 'Weather',
      'ru' : 'Погода'
    },
    'Hourly forecast': {
      'ru' : 'Прогноз по часам',
      'en' : 'Hourly forecast'
    },
    'Daily forecast': {
      'ru' : 'Прогноз по дням',
      'en' : 'Daily forecast'
    },
    'Hourly': {
      'en' : 'Hourly',
      'ru' : 'По часам'
    },
    'Daily': {
      'en' : 'Daily',
      'ru' : 'По дням'
    },

    'Clear sky': {
      'en': 'Clear sky',
      'ru': 'Ясно'
    },
    'Few clouds': {
      'en': 'Few clouds',
      'ru': 'Маооблачно'
    },
    'Scattered clouds': {
      'en': 'Scattered clouds',
      'ru': 'Облачно'
    },
    'Broken clouds': {
      'en': 'Broken clouds',
      'ru': 'Сильная облачность'
    },
    'Shower rain': {
      'en': 'Shower rain',
      'ru': 'Ливень'
    },
    'Rain': {
      'en': 'Rain',
      'ru': 'Дождь'
    },
    'Thunderstorm': {
      'en': 'Thunderstorm',
      'ru': 'Гроза'
    },
    'Snow': {
      'en': 'Snow',
      'ru': 'Снег'
    },
    'Mist': {
      'en': 'Mist',
      'ru': 'Туман'
    },

    'Temperature': {
      'en': 'Temperature',
      'ru': 'Температура'
    },
    'Humidity': {
      'en': 'Humidity',
      'ru': 'Влажность'
    },
    'Feels like': {
      'en': 'Feels like',
      'ru': 'Ощущается как'
    },
    'Probability of percipitation': {
      'en': 'Probability of percipitation',
      'ru': 'Вероятность осадков'
    },
    'Morning': {
      'en': 'Morning',
      'ru': 'Утро'
    },
    'Day': {
      'en': 'Day',
      'ru': 'День'
    },
    'Evening': {
      'en': 'Evening',
      'ru': 'Вечер'
    },
    'Night': {
      'en': 'Night',
      'ru': 'Ночь'
    },

    'm/s': {
      'en': 'm/s',
      'ru': 'м/с'
    },

    'Loading data...': {
      'en': 'Loading data...',
      'ru': 'Загрузка данных...'
    },

  };

}