import 'package:flutter/material.dart';
import 'package:weather_app/weather_models.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/localization.dart';

double _toCelsius(double k) => k - 273.15;

String _getImageForCondition(WeatherCondition cond, [DateTime ?time]) {
  bool night = (time == null) ? false : (((time.hour >= 22) || (time.hour < 7)));
  switch (cond) {
    case WeatherCondition.ClearSky:
      return night ? 'assets/icons/01n@2x.png' : 'assets/icons/01d@2x.png';
    case WeatherCondition.FewClouds:
      return night ? 'assets/icons/02n@2x.png' : 'assets/icons/02d@2x.png';
    case WeatherCondition.ScatteredClouds:
      return night ? 'assets/icons/03n@2x.png' : 'assets/icons/03d@2x.png';
    case WeatherCondition.BrokenClouds:
      return night ? 'assets/icons/04n@2x.png' : 'assets/icons/04d@2x.png';
    case WeatherCondition.ShowerRain:
      return night ? 'assets/icons/09n@2x.png' : 'assets/icons/09d@2x.png';
    case WeatherCondition.Rain:
      return night ? 'assets/icons/10n@2x.png' : 'assets/icons/10d@2x.png';
    case WeatherCondition.Thunderstorm:
      return night ? 'assets/icons/11n@2x.png' : 'assets/icons/11d@2x.png';
    case WeatherCondition.Snow:
      return night ? 'assets/icons/13n@2x.png' : 'assets/icons/13d@2x.png';
    case WeatherCondition.Mist:
      return night ? 'assets/icons/50n@2x.png' : 'assets/icons/50d@2x.png';
    default:
      return 'assets/icons/09n@2x.png';
  }
}

String _getNameForCondition(WeatherCondition cond) {
  switch (cond) {
    case WeatherCondition.ClearSky:
      return Localization.getValue('Clear sky');
    case WeatherCondition.FewClouds:
      return Localization.getValue('Few clouds');
    case WeatherCondition.ScatteredClouds:
      return Localization.getValue('Scattered clouds');
    case WeatherCondition.BrokenClouds:
      return Localization.getValue('Broken clouds');
    case WeatherCondition.ShowerRain:
      return Localization.getValue('Shower rain');
    case WeatherCondition.Rain:
      return Localization.getValue('Rain');
    case WeatherCondition.Thunderstorm:
      return Localization.getValue('Thunderstorm');
    case WeatherCondition.Snow:
      return Localization.getValue('Snow');
    case WeatherCondition.Mist:
      return Localization.getValue('Mist');
    default:
      return Localization.getValue('Clear sky');
  }
}

class HourWidget extends StatelessWidget{

  final Function() ?onTap;
  final WeatherHour hour;
  final bool expanded;

  HourWidget({Key? key, @required WeatherHour ?hour, this.onTap, this.expanded = false}): hour = hour ?? WeatherHour(), super(key: key);

  @override
  Widget build(BuildContext context) {

    final base = Row(
      children: [
        Text(DateFormat('kk:mm').format(hour.time)),
        const SizedBox(width: 10),
        Text('${_toCelsius(hour.temp).toStringAsFixed(0)}°C'),
        const SizedBox(width: 10),
        Image(image: AssetImage(_getImageForCondition(hour.condition, hour.time)), height: 50,),
        // SizedBox(width: 10),
        Expanded(child: Center(child: Text(_getNameForCondition(hour.condition)))),
        const Image(image: AssetImage('assets/icons/wind.png'), height: 20,),
        const SizedBox(width: 10),
        Text('${hour.windSpeed.toStringAsFixed(0)} ${Localization.getValue('m/s')}'),
      ],
    );

    Widget ?additional;
    if (expanded) {
      additional = Column(
      children: [
        Row(
          children: [
            Text('${Localization.getValue('Feels like')}:'),
            const SizedBox(width: 10),
            Text('${_toCelsius(hour.feelsLike).toStringAsFixed(0)}°C')
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text('${Localization.getValue('Probability of percipitation')}:'),
            const SizedBox(width: 10),
            Text('${hour.pop.toStringAsFixed(0)}%')
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text('${Localization.getValue('Humidity')}:'),
            const SizedBox(width: 10),
            Text('${hour.humidity.toStringAsFixed(0)}%')
          ],
        ),
        const SizedBox(height: 5),
      ]
    ) ;
    }

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (onTap != null) onTap!();
        },
        child:ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: (additional != null) ? Column(
                children: [
                  base,
                  additional
                ],
              ) : base
          ),
        )
    );
  }
}

class DayWidget extends StatelessWidget{

  final Function() ?onTap;
  final WeatherDay day;
  final bool expanded;

  DayWidget({Key? key, @required WeatherDay ?day, this.onTap, this.expanded = false}): day = day ?? WeatherDay(), super(key: key);

  @override
  Widget build(BuildContext context) {

    final base = Column(
      children:[
        Row(
          children: [
            Text(DateFormat('dd-MM').format(day.time)),
            const SizedBox(width: 10),
            Image(image: AssetImage(_getImageForCondition(day.condition)), height: 50,),
            // SizedBox(width: 10),
            Expanded(child: Center(child: Text(_getNameForCondition(day.condition)))),
            const Image(image: AssetImage('assets/icons/rain.png'), height: 20,),
            const SizedBox(width: 10),
            Text('${day.pop.toStringAsFixed(0)}%'),
            const SizedBox(width: 10),
            const Image(image: AssetImage('assets/icons/wind.png'), height: 20,),
            const SizedBox(width: 10),
            Text('${day.windSpeed.toStringAsFixed(0)} ${Localization.getValue('m/s')}'),
          ],
        ),

        Row(children: [
          Padding(padding: const EdgeInsets.only(left: 10, right: 10), child:Text(Localization.getValue('Temperature'))),
          Expanded(
            child: Column(children: [
              Row(children:[
                Text('${Localization.getValue('Morning')}: ${_toCelsius(day.tempMorning).toStringAsFixed(0)}°C'),
                Expanded(child: Container()),
                Text('${Localization.getValue('Day')}: ${_toCelsius(day.tempDay).toStringAsFixed(0)}°C')
              ]),
              const SizedBox(height: 3),
              Row(children:[
                Text('${Localization.getValue('Evening')}: ${_toCelsius(day.tempEvening).toStringAsFixed(0)}°C'),
                Expanded(child: Container()),
                Text('${Localization.getValue('Night')}: ${_toCelsius(day.tempNight).toStringAsFixed(0)}°C')],),
              ]
            ),
          ),
          const SizedBox(width: 10)
        ]),
        const SizedBox(height: 5),
      ]
    );

    Widget ?additional;

    // additional = Column(children:[Text('12345')]);

    if (expanded) {
      additional = Column(
        children: [
          Row(children: [
            Expanded(
              child: Row(children: [
                Padding(padding: const EdgeInsets.only(left: 10, right: 10), child:Text(Localization.getValue('Feels like'))),
                Expanded(
                  child: Column(children: [
                    // Text('12345')
                    Row(children:[
                      Text('${Localization.getValue('Morning')}: ${_toCelsius(day.feelsLikeMorning).toStringAsFixed(0)}°C'),
                      Expanded(child: Container()),
                      Text('${Localization.getValue('Day')}: ${_toCelsius(day.feelsLikeDay).toStringAsFixed(0)}°C')
                    ]),
                    const SizedBox(height: 3),
                    Row(children:[
                      Text('${Localization.getValue('Evening')}: ${_toCelsius(day.feelsLikeEvening).toStringAsFixed(0)}°C'),
                      Expanded(child: Container()),
                      Text('${Localization.getValue('Night')}: ${_toCelsius(day.feelsLikeNight).toStringAsFixed(0)}°C')
                    ],),
                  ]),
                ),
                const SizedBox(width: 10)
              ]),
            ),
            const SizedBox(height: 5),
          ]),
          Row(
            children: [
              Padding(padding: const EdgeInsets.only(left: 10, right: 10), child:Text('${Localization.getValue('Humidity')}:')),
              const SizedBox(width: 10),
              Text('${day.humidity.toStringAsFixed(0)}%')
            ],
          ),
          const SizedBox(height: 5),
        ]
    ) ;
    }

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (onTap != null) onTap!();
        },
        child:ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10, right: 10),
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.blueAccent)
              // ),
              child: (additional != null) ? Column(
                children: [
                  base,
                  additional
                ],
              ) : base
          ),
        )
    );
  }
}

class WeatherCurrentWidget extends StatelessWidget {

  final WeatherCurrent current;
  final String city;
  final bool loading;

  const WeatherCurrentWidget(this.current, this.city, {this.loading = false, Key ?key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget loadWidget = loading ? CircularProgressIndicator() : Container();
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(city, style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),),
                  Container(height: 15, width: 15, child: loadWidget),
                  Text(
                    DateFormat('dd-MM kk:mm').format(current.time),
                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                  ),
                ],
              ),
              Row(
                children: [
                  // Text(DateFormat('dd-MM kk:mm').format(current.time)),
                  // SizedBox(width: 10),
                  Text('${_toCelsius(current.temp).toStringAsFixed(0)}°C'),
                  // SizedBox(width: 10),
                  // SizedBox(width: 10),
                  Expanded(child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage(_getImageForCondition(current.condition, current.time)), height: 50,),
                        const SizedBox(width: 5),
                        Center(child: Text(_getNameForCondition(current.condition))),
                      ],
                    )
                  ),
                  const Image(image: AssetImage('assets/icons/wind.png'), height: 20,),
                  const SizedBox(width: 10),
                  Text('${current.windSpeed.toStringAsFixed(0)} ${Localization.getValue('m/s')}'),
                ],
              ),
            ],
          )
      ),
    );
  }

}