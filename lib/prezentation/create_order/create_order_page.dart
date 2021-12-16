import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/create_order/animated_container.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_bloc.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_event.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_state.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_bloc.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_event.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/widgets/calendar_widget.dart';

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
  late OrdersBloc _ordersBloc;

  Service? _selectedService;
  DateTime? _selectedDay;
  OrderEntity? _selectedOrder;
  Master? _selectedMaster;

  final _serviceKey = new GlobalKey<ErrorAnimatedContainerState>();
  final _masterKey = new GlobalKey<ErrorAnimatedContainerState>();
  final _dateKey = new GlobalKey<ErrorAnimatedContainerState>();

  bool _showAvailableTime = false;

  @override
  void initState() {
    super.initState();
    _navBloc = getItApp<NavBloc>();
    _ordersBloc = getItApp<OrdersBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _navBloc,
      child: BlocBuilder<NavBloc, NavState>(
        builder: (BuildContext context, state) {
          if (state is NavigationResultedState) {
            if (state.result != null && state.result is Service?) {
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
            _buildServiceSelector(),
            marginVertical(22),
            Text(
              tr(AppStrings.chooseMaster),
              style: bodyText4,
            ),
            marginVertical(10),
            _buildMasterSelector(widget.salon.mastersList),
            marginVertical(22),
            Text(
              tr(AppStrings.chooseDate),
              style: bodyText4,
            ),
            marginVertical(10),
            Calendar(key: _dateKey, onSelectDay: (selectedDay) {
              _selectedDay = selectedDay;

            },),
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
                    tr(AppStrings.chooseTime),
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
              child: roundedButton(
                context,
                tr(AppStrings.next),
                () {
                  if (_selectedOrder == null) {
                    Fluttertoast.showToast(msg: "Please choose time");
                  } else {
                    UserEntity user = getIt<LocalStorage>().getCurrentUser();

                    _selectedOrder!.clientId = user.id;
                    _selectedOrder!.clientName = user.name;

                    _ordersBloc.add(UpdateOrderEvent(_selectedOrder!));

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
    return ErrorAnimatedContainer(
      key: _serviceKey,
      borderRadius: 10,
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
              onPressed: () => _navBloc.add(
                  NavChooseServicePage([widget.salon.id, widget.categoryId])),
              text: tr(AppStrings.choose)),
        ],
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
          tr(AppStrings.ifTimeReservedDescription),
          style: bodyText5.copyWith(fontWeight: FontWeight.w400),
        ),
        marginVertical(12),
        StreamBuilder<List<OrderEntity>>(
            stream: _ordersBloc.streamOrders,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
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
                        _selectedOrder = order;
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
                      border: _selectedOrder == order
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
        _ordersBloc.add(LoadAvailableOrdersByTimeEvent(widget.salon.id,
            _selectedService!.id, _selectedMaster!.id, formattedDate));
      });
    }
  }

  @override
  void dispose() {
    _ordersBloc.dispose();

    super.dispose();
  }
}
