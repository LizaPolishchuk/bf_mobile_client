import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/orders/order_item_widget.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_bloc.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_event.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_state.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/date_utils.dart';
import 'package:salons_app_mobile/utils/widgets/calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class OrdersHistoryPage extends StatefulWidget {
  static const routeName = '/orders-history';

  const OrdersHistoryPage({Key? key}) : super(key: key);

  @override
  _OrdersHistoryPageState createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  late OrdersBloc _ordersBloc;
  final AlertBuilder _alertBuilder = AlertBuilder();
  bool _showCalendar = false;
  DateTime? _selectedDate;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    _ordersBloc.add(LoadOrdersForCurrentUserEvent(
        dateFor: _selectedDate?.formatToYYYYMMdd()));
  }

  @override
  void initState() {
    super.initState();

    _ordersBloc = getItApp<OrdersBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _ordersBloc,
      child: BlocListener<OrdersBloc, OrdersState>(
        listener: (BuildContext context, state) {
          if (state is ErrorOrdersState) {
            _alertBuilder.showErrorDialog(context, state.failure.message);
          } else {
            _alertBuilder.stopErrorDialog(context);
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(AppStrings.ordersHistory),
                  style: titleText3,
                ),
                marginVertical(16),
                GestureDetector(
                  child: _buildSearch(),
                  onTap: () {
                    setState(() {
                      _showCalendar = !_showCalendar;
                    });
                    if(!_showCalendar && _selectedDate != null) {
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
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return StreamBuilder<List<OrderEntity>>(
        stream: _ordersBloc.streamOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (_refreshController.isRefresh)
                _refreshController.refreshCompleted();

              if (snapshot.hasError) {
                String errorMsg = snapshot.error.toString();
                if(errorMsg == NoInternetException.noInternetCode) {
                  errorMsg = tr(AppStrings.noInternetConnection);
                } else {
                  errorMsg = tr(AppStrings.somethingWentWrong);
                }
                _alertBuilder.showErrorSnackBar(context, errorMsg);
              }
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
                          child: OrdersItemWidget(
                            order: orders[index],
                            enableSlidebar: false,
                            onPressedPin: (order) {
                              _ordersBloc.add(PinOrderEvent(order));
                            },
                            onPressedRemove: (order) {
                              _ordersBloc.add(CancelOrderEvent(order));
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
          hintText: tr(AppStrings.searchByDate),
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
      children: [
        Image.asset(emptyListPlaceholder),
        Text(tr(AppStrings.nothingFound)),
      ],
    );
  }
}
