import 'package:flutter/material.dart';
import 'package:weather_app/weather_models.dart';
import 'package:weather_app/widgets/weather_widgets.dart';

class DaysList extends StatefulWidget {

  final List<WeatherDay> days;

  const DaysList(this.days, {Key ?key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _DaysListState();
}

class _DaysListState extends State<DaysList> {

  int expanded = -1;

  @override
  void didUpdateWidget(covariant DaysList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days) {
      expanded = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.days.length,
      itemBuilder: (context, index) {
        return  DayWidget(day: widget.days[index], expanded: (index == expanded), onTap: () {
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