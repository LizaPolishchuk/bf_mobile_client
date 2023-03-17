import 'package:bf_mobile_client/injection_container_app.dart';
import 'package:bf_mobile_client/prezentation/appointments/appointment_bloc.dart';
import 'package:bf_mobile_client/prezentation/appointments/appointment_item_widget.dart';
import 'package:bf_mobile_client/utils/alert_builder.dart';
import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_images.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/date_utils.dart';
import 'package:bf_mobile_client/utils/widgets/calendar_widget.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsHistoryPage extends StatefulWidget {
  static const routeName = '/orders-history';

  const AppointmentsHistoryPage({Key? key}) : super(key: key);

  @override
  _AppointmentsHistoryPageState createState() => _AppointmentsHistoryPageState();
}

class _AppointmentsHistoryPageState extends State<AppointmentsHistoryPage> {
  late AppointmentsBloc _appointmentsBloc;
  final AlertBuilder _alertBuilder = AlertBuilder();
  bool _showCalendar = false;
  DateTime? _selectedDate;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    _appointmentsBloc.getAppointmentsForCurrentUser(
        dateFor: _selectedDate?.formatToYYYYMMdd());
  }

  @override
  void initState() {
    super.initState();

    _appointmentsBloc = getItApp<AppointmentsBloc>();

    _appointmentsBloc.errorMessage.listen((errorMsg) {
      _alertBuilder.showErrorSnackBar(context, errorMsg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.ordersHistory),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: _buildSearch(),
              onTap: () {
                setState(() {
                  _showCalendar = !_showCalendar;
                });
                if (!_showCalendar && _selectedDate != null) {
                  _selectedDate = null;
                  _onRefresh();
                }
              },
            ),
            marginVertical(_showCalendar ? 15 : 25),
            if (_showCalendar)
              Calendar(
                height: 140,
                calendarFormat: CalendarFormat.twoWeeks,
                onSelectDay: (selectedDay) {
                  _selectedDate = selectedDay;
                  _onRefresh();
                },
              ),
            if (_showCalendar) marginVertical(15),
            Flexible(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: _buildOrdersList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return StreamBuilder<List<AppointmentEntity>>(
        stream: _appointmentsBloc.appointmentsLoaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (_refreshController.isRefresh)
                _refreshController.refreshCompleted();
            });

            if (snapshot.data != null && snapshot.data!.length > 0) {
              var orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 118,
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: Opacity(
                                opacity: index > 0 ? 1 : 0,
                                child: Container(
                                  width: 1,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: primaryColor,
                              ),
                            ),
                            Flexible(
                              child: Opacity(
                                opacity: index < orders.length - 1 ? 1 : 0,
                                child: Container(
                                  width: 1,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        marginHorizontal(4),
                        Flexible(
                          child: AppointmentsItemWidget(
                            appointment: orders[index],
                            enableSlidebar: false,
                            onPressedPin: (order) {
                              _appointmentsBloc.pinAppointment(order, index);
                            },
                            onPressedRemove: (order) {
                              _appointmentsBloc.cancelAppointment(order);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return _buildEmptyList();
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildSearch() {
    return Material(
      color: bgGrey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      elevation: 22.0,
      shadowColor: blurColor,
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchByDate,
          hintStyle: hintText2,
          suffixIcon: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, right: 22, left: 6),
            // add padding to adjust icon
            child: SvgPicture.asset(
              _showCalendar ? icCancel : icCalendar,
              color: grey,
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 22),
          fillColor: Colors.white,
          filled: true,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x17000000), width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x17000000), width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(emptyListPlaceholder),
        Text(AppLocalizations.of(context)!.nothingFound),
      ],
    );
  }
}
