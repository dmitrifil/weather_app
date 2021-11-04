import 'package:flutter/material.dart';
import 'package:weather_app/weather_models.dart';
import 'package:weather_app/widgets/weather_widgets.dart';

class HoursList extends StatefulWidget {

  final List<WeatherHour> hours;

  const HoursList(this.hours, {Key ?key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _HoursListState();
}

class _HoursListState extends State<HoursList> {

  int expanded = -1;

  @override
  void didUpdateWidget(covariant HoursList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hours != widget.hours) {
      expanded = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.hours.length,
      itemBuilder: (context, index) {
        return  HourWidget(hour: widget.hours[index], expanded: (index == expanded), onTap: () {
          setState(() {
            expanded = (index == expanded) ? -1 : index;
          });
        },);
      },
      separatorBuilder: (context, index) {
        // return Divider();
        return const SizedBox(height: 3);
      },
    );
  }
}