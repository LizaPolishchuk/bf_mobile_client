import 'dart:async';

import 'package:bf_mobile_client/prezentation/choose_service/choose_service_page.dart';
import 'package:bf_mobile_client/prezentation/create_order/animated_container.dart';
import 'package:bf_mobile_client/prezentation/orders/appointment_bloc.dart';
import 'package:bf_mobile_client/utils/alert_builder.dart';
import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_images.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/widgets/calendar_widget.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  late OrdersBloc _ordersBloc;
  final AlertBuilder _alertBuilder = AlertBuilder();

  Service? _selectedService;
  DateTime? _selectedDay;
  AppointmentEntity? _selectedAppointment;
  Master? _selectedMaster;

  final _serviceKey = new GlobalKey<ErrorAnimatedContainerState>();
  final _masterKey = new GlobalKey<ErrorAnimatedContainerState>();
  final _dateKey = new GlobalKey<ErrorAnimatedContainerState>();

  bool _showAvailableTime = false;

  @override
  void initState() {
    super.initState();
    _ordersBloc = getItApp<OrdersBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
            top: 16 + MediaQuery.of(context).padding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildServiceSelector(),
            marginVertical(22),
            Text(
              AppLocalizations.of(context)!.chooseMaster,
              style: bodyText4,
            ),
            marginVertical(10),
            // _buildMasterSelector(widget.salon.mastersList),
            marginVertical(22),
            Text(
              AppLocalizations.of(context)!.chooseDate,
              style: bodyText4,
            ),
            marginVertical(10),
            Calendar(
              dateKey: _dateKey,
              onSelectDay: (selectedDay) {
                _selectedDay = selectedDay;
              },
            ),
            marginVertical(22),
            Center(
              child: SizedBox(
                width: 226,
                child: OutlinedButton(
                  onPressed: () {
                    _loadAvailableTime();
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0))),
                      side: MaterialStateProperty.all(BorderSide(
                          color: primaryColor,
                          width: 1.0,
                          style: BorderStyle.solid))),
                  child: Text(
                    AppLocalizations.of(context)!.chooseTime,
                    style: bodyText4,
                  ),
                ),
              ),
            ),
            if (_showAvailableTime) _buildTimeSelector(),
            marginVertical(16),
            // Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.sum,
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
              child: roundedButton(
                context,
                AppLocalizations.of(context)!.next,
                () {
                  if (_selectedAppointment == null) {
                    Fluttertoast.showToast(msg: "Please choose time");
                  } else {
                    UserEntity user = getIt<LocalStorage>().getCurrentUser();

                    _selectedAppointment!.clientId = user.id;
                    _selectedAppointment!.clientName = user.name;

                    _ordersBloc.updateAppointment(_selectedAppointment!);

                    Navigator.of(context).pop();
                  }
                },
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSelector() {
    return InkWell(
      onTap: () async {
        var result = await Navigator.of(context).pushNamed(
            ChooseServicePage.routeName,
            arguments: [widget.salon.id, widget.categoryId, _selectedService]);
        if (result != null && result is Service?) {
          setState(() {
            _selectedService = result as Service;
          });
        }
      },
      child: ErrorAnimatedContainer(
        key: _serviceKey,
        borderRadius: 10,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedService != null
                    ? "${_selectedService!.name} (${_selectedService!.price?.toStringAsFixed(0)} ${AppLocalizations.of(context)!.uah})"
                    : AppLocalizations.of(context)!.chooseSpecificCategory,
                style: hintText2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            marginHorizontal(6),
            buttonMoreWithRightArrow(context,
                onPressed: null, text: AppLocalizations.of(context)!.choose),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterSelector(List<Master> masters) {
    return Container(
      height: 94,
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
            child: ErrorAnimatedContainer(
              key: index == 0 ? _masterKey : null,
              width: 94,
              margin: const EdgeInsets.only(right: 8),
              padding: EdgeInsets.all(6),
              border: _selectedMaster == master
                  ? Border.all(color: primaryColor, width: 2)
                  : null,
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
                    master.name,
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

  Widget _buildTimeSelector() {
    return Column(
      children: [
        marginVertical(4),
        Text(
          AppLocalizations.of(context)!.ifTimeReservedDescription,
          style: bodyText5.copyWith(fontWeight: FontWeight.w400),
        ),
        marginVertical(12),
        StreamBuilder<List<OrderEntity>>(
            stream: _ordersBloc.ordersLoaded,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (snapshot.hasError) {
                    String errorMsg = snapshot.error.toString();
                    if (errorMsg == NoInternetException.noInternetCode) {
                      errorMsg =
                          AppLocalizations.of(context)!.noInternetConnection;
                    } else {
                      errorMsg =
                          AppLocalizations.of(context)!.somethingWentWrong;
                    }
                    _alertBuilder.showErrorSnackBar(context, errorMsg);
                  }
                });
                return _buildTimeList(snapshot.data ?? []);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ],
    );
  }

  Widget _buildTimeList(List<OrderEntity> orders) {
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
                        _selectedAppointment = order;
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
                      border: _selectedAppointment == order
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
                          DateFormat('hh:mm').format(order.date),
                          style: !isReserved
                              ? bodyText4
                              : bodyText4.copyWith(color: darkGreyText),
                        ),
                        if (isReserved)
                          Text(
                            AppLocalizations.of(context)!.reserved,
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

  Timer? _debounce;

  void _loadAvailableTime() {
    if (_selectedService == null) {
      _serviceKey.currentState?.showError();
    } else if (_selectedMaster == null) {
      _masterKey.currentState?.showError();
    } else if (_selectedDay == null) {
      _dateKey.currentState?.showError();
    } else {
      if (!_showAvailableTime) {
        setState(() {
          _showAvailableTime = true;
        });
      }

      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), () {
        String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay!);
        _ordersBloc.getAvailableOrdersByTime(widget.salon.id,
            _selectedService!.id, _selectedMaster!.id, formattedDate);
      });
    }
  }

  @override
  void dispose() {
    _ordersBloc.dispose();

    super.dispose();
  }
}
