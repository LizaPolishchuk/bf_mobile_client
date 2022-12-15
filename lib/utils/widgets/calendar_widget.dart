import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salons_app_mobile/prezentation/create_order/animated_container.dart';
import 'package:salons_app_mobile/prezentation/create_order/create_order_page.dart';
import 'package:salons_app_mobile/utils/date_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../app_colors.dart';
import '../app_styles.dart';

class Calendar extends StatefulWidget {
  final Function(DateTime selectedDay)? onSelectDay;
  final CalendarFormat? calendarFormat;
  final double? height;
  final GlobalKey? dateKey;

  const Calendar({Key? key, this.onSelectDay, this.calendarFormat, this.height, this.dateKey}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return _buildCalendar();
  }

  Widget _buildCalendar() {
    return Align(
      alignment: Alignment.center,
      child: ErrorAnimatedContainer(
        key: widget.dateKey,
        height: widget.height ?? 255,
        width: 285,
        child: TableCalendar(
          calendarFormat: widget.calendarFormat ?? CalendarFormat.month,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          headerStyle: HeaderStyle(
            headerPadding: EdgeInsets.all(0),
            titleTextStyle: bodyText4,
            titleCentered: true,
            formatButtonVisible: false,
          ),
          onDaySelected: (selectedDay, focusedDay) {
            if (widget.calendarFormat == CalendarFormat.twoWeeks || !selectedDay.isDayBeforeNow()) {
              setState(() {
                _selectedDay = selectedDay;
              });
              if (widget.onSelectDay != null) {
                widget.onSelectDay!(selectedDay);
              }
            }
          },
          daysOfWeekHeight: 22,
          rowHeight: 29,
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              final text = DateFormat.E().format(day);
              return Align(
                alignment: Alignment.topCenter,
                child: Text(
                  text.toUpperCase(),
                  style: bodyText1.copyWith(
                      color: greyText, fontWeight: FontWeight.w600),
                ),
              );
            },
            headerTitleBuilder: (context, day) {
              final text = DateFormat.yMMMM().format(day);
              return Center(
                child: Text(
                  text,
                  style: bodyText4,
                ),
              );
            },
            defaultBuilder: (context, day, day2) {
              return _buildCalendarDay(day, CalendarDayType.DEFAULT);
            },
            todayBuilder: (context, day, day2) {
              return _buildCalendarDay(day, CalendarDayType.TODAY);
            },
            outsideBuilder: (context, day, day2) {
              return _buildCalendarDay(day, CalendarDayType.OUTSIDE);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day, CalendarDayType dayType) {
    var now = DateTime.now();

    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      dayType = CalendarDayType.TODAY;
    } else if (widget.calendarFormat != CalendarFormat.twoWeeks && day.isBefore(now)) {
      dayType = CalendarDayType.OUTSIDE;
    } else {
      dayType = CalendarDayType.DEFAULT;
    }

    return Container(
      decoration: _selectedDay == day
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: primaryColor,
            )
          : null,
      alignment: Alignment.center,
      child: Text(
        day.day.toString(),
        style: calendarText.copyWith(
            color: _selectedDay == day
                ? Colors.white
                : dayType == CalendarDayType.OUTSIDE
                    ? Color(0x4d3c3c43)
                    : dayType == CalendarDayType.TODAY
                        ? primaryColor
                        : Colors.black),
      ),
    );
  }
}
