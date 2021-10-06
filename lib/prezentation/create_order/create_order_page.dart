import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_bloc.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_event.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_state.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../injection_container_app.dart';

enum CalendarDayType { TODAY, DEFAULT, OUTSIDE }

class CreateOrderPage extends StatefulWidget {
  static const routeName = '/create-order';

  final Salon salon;
  final String categoryId;

  const CreateOrderPage(this.salon, this.categoryId);

  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  late NavBloc _navBloc;
  Service? _selectedService;

  var _mockedMasters = [
    Master("id1", "name", "description", "avatar", "avatarPath", "position", [],
        {}, "status"),
    Master("id2", "name", "description", "avatar", "avatarPath", "position", [],
        {}, "status"),
    Master("id3", "name", "description", "avatar", "avatarPath", "position", [],
        {}, "status"),
    Master("id4", "name", "description", "avatar", "avatarPath", "position", [],
        {}, "status"),
    Master("id5", "name", "description", "avatar", "avatarPath", "position", [],
        {}, "status")
  ];

  var mockedOrders = [
    OrderEntity(
        "id",
        "clientId",
        "clientName",
        "salonId",
        "salonName",
        "masterId",
        "masterName",
        "masterAvatar",
        "serviceId",
        "serviceName",
        DateTime.now(),
        100),
    OrderEntity(
        "id",
        "",
        "clientName",
        "salonId",
        "salonName",
        "masterId",
        "masterName",
        "masterAvatar",
        "serviceId",
        "serviceName",
        DateTime.now(),
        100),
    OrderEntity(
        "id",
        null,
        "clientName",
        "salonId",
        "salonName",
        "masterId",
        "masterName",
        "masterAvatar",
        "serviceId",
        "serviceName",
        DateTime.now(),
        100),
    OrderEntity(
        "id",
        "clientId",
        "clientName",
        "salonId",
        "salonName",
        "masterId",
        "masterName",
        "masterAvatar",
        "serviceId",
        "serviceName",
        DateTime.now(),
        100),
    OrderEntity(
        "id",
        "clientId",
        "clientName",
        "salonId",
        "salonName",
        "masterId",
        "masterName",
        "masterAvatar",
        "serviceId",
        "serviceName",
        DateTime.now(),
        100),
  ];

  @override
  void initState() {
    super.initState();
    _navBloc = getItApp<NavBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _navBloc,
      child: BlocBuilder<NavBloc, NavState>(
        builder: (BuildContext context, state) {
          if (state is NavigationResultedState) {
            if (state.result != null && state.result is Service?) {
              print("Result: chosenService: ${(state.result as Service).name}");
              _selectedService = state.result as Service;
            }
          }

          return _buildPage();
        },
      ),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: blurColor, blurRadius: 8, offset: Offset(0, 3))
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedService != null
                          ? "${_selectedService!.name} (${_selectedService!.price?.toStringAsFixed(0)} ${tr(AppStrings.uah)})"
                          : tr(AppStrings.chooseSpecificCategory),
                      style: hintText2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  marginHorizontal(6),
                  buttonMoreWithRightArrow(
                      onPressed: () => _navBloc.add(NavChooseServicePage(
                          [widget.salon, widget.categoryId])),
                      text: tr(AppStrings.choose)),
                ],
              ),
            ),
            marginVertical(22),
            Text(
              tr(AppStrings.chooseMaster),
              style: bodyText4,
            ),
            marginVertical(10),
            _buildMasterSelector(_mockedMasters),
            marginVertical(22),
            Text(
              tr(AppStrings.chooseDate),
              style: bodyText4,
            ),
            marginVertical(10),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 255,
                width: 285,
                child: _buildCalendar(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: blurColor, blurRadius: 8, offset: Offset(0, 3))
                  ],
                ),
              ),
            ),

            marginVertical(22),
            Text(
              tr(AppStrings.chooseTime),
              style: bodyText4,
            ),

            marginVertical(4),
            Text(
              tr(AppStrings.ifTimeReservedDescription),
              style: bodyText5.copyWith(fontWeight: FontWeight.w400),
            ),
            marginVertical(12),
            _buildTimeSelector(mockedOrders),
            marginVertical(16),
            // Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    tr(AppStrings.sum),
                    style: bodyText4,
                  ),
                ),
                Text(
                  "--",
                  style: bodyText4,
                ),
              ],
            ),
            marginVertical(35),
            Align(
              alignment: Alignment.center,
              child: buttonWithText(
                context,
                tr(AppStrings.next),
                () {
                  // Navigator.of(context).pop(_chosenService);
                },
                width: 255,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _selectedDay;
  DateTime? _selectedTime;
  Master? _selectedMaster;

  Widget _buildCalendar() {
    return TableCalendar(
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
        if (!_isDayBeforeNow(selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
          });
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
    );
  }

  Widget _buildCalendarDay(DateTime day, CalendarDayType dayType) {
    var now = DateTime.now();

    if (day.year == now.year && day.month == now.month && day.day == now.day) {
      dayType = CalendarDayType.TODAY;
    } else if (day.isBefore(now)) {
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

  Widget _buildTimeSelector(List<OrderEntity> orders) {
    return Container(
      height: 42,
      child: ListView.builder(
        itemBuilder: (context, index) {
          OrderEntity order = orders[index];

          bool isReserved = order.clientId?.isNotEmpty == true;

          return Container(
            width: isReserved ? 100 : 80,
            margin: const EdgeInsets.only(right: 6),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    if (!isReserved) {
                      setState(() {
                        _selectedTime = order.date;
                      });
                    } else {
                      print("click on notify");
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isReserved ? Color(0x807c797b) : accentColor,
                      borderRadius: BorderRadius.circular(10),
                      border: _selectedTime == order.date
                          ? Border.all(width: 2, color: primaryColor)
                          : null,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "13:00",
                          style: !isReserved
                              ? bodyText4
                              : bodyText4.copyWith(color: darkGreyText),
                        ),
                        if (isReserved)
                          Text(
                            tr(AppStrings.reserved),
                            style: bodyText5,
                          ),
                      ],
                    ),
                  ),
                ),
                if (order.clientId?.isNotEmpty == true)
                  Positioned(
                    right: -5,
                    child: GestureDetector(
                      child: SvgPicture.asset(icNotify),
                      onTap: () {
                        print("click on notify");
                      },
                    ),
                  ),
              ],
            ),
          );
        },
        itemCount: orders.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildMasterSelector(List<Master> masters) {
    return Container(
      height: 106,
      color: bgGrey,
      child: ListView.builder(
        itemBuilder: (context, index) {
          var master = masters[index];

          return InkWell(
            onTap: () {
              setState(() {
                _selectedMaster = master;
              });
            },
            child: Container(
              width: 94,
              margin: const EdgeInsets.only(right: 8, bottom: 6),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                border: _selectedMaster == master
                    ? Border.all(color: primaryColor, width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                      color: blurColor, blurRadius: 6, offset: Offset(0, 2))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: imageWithPlaceholder(
                          "https://vjoy.cc/wp-content/uploads/2019/08/4-20.jpg",
                          masterPlaceholder),
                    ),
                  ),
                  marginVertical(2),
                  Text(
                    "Liza Polishchuk dfdffddf",
                    style: bodyText4.copyWith(fontSize: 15),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: masters.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  bool _isDayBeforeNow(DateTime day) {
    var now = DateTime.now();

    return (!(day.year == now.year &&
            day.month == now.month &&
            day.day == now.day) &&
        day.isBefore(now));
  }
}
