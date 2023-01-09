import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/event_bus_events/go_to_search_salons_event.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_bloc.dart';
import 'package:salons_app_mobile/prezentation/orders_history/orders_history_page.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/events/event_bus.dart';

import '../orders/order_item_widget.dart';

class ComingOrdersWidget extends StatefulWidget {
  final OrdersBloc ordersBloc;
  final RefreshController refreshController;

  const ComingOrdersWidget(this.ordersBloc, this.refreshController);

  @override
  _ComingOrdersWidgetState createState() => _ComingOrdersWidgetState();
}

class _ComingOrdersWidgetState extends State<ComingOrdersWidget> {
  late OrdersBloc _ordersBloc;
  final AlertBuilder _alertBuilder = AlertBuilder();

  @override
  void initState() {
    super.initState();

    _ordersBloc = widget.ordersBloc;

    _ordersBloc.errorMessage.listen((errorMsg) {
      _alertBuilder.showErrorSnackBar(context, errorMsg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.comingOrders, style: bodyText3),
            buttonMoreWithRightArrow(
                onPressed: () {
                  Navigator.of(context).pushNamed(OrdersHistoryPage.routeName);
                },
                text: AppLocalizations.of(context)!.all),
          ],
        ),
        marginVertical(16),
        Expanded(
          child: StreamBuilder<List<OrderEntity>>(
              stream: _ordersBloc.ordersLoaded,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (widget.refreshController.isRefresh)
                      widget.refreshController.refreshCompleted();
                  });

                  if (snapshot.data != null && snapshot.data!.length > 0) {
                    var orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return OrdersItemWidget(
                          order: orders[index],
                          onPressedPin: (order) {
                            _ordersBloc.pinOrder(order, index);
                          },
                          onPressedRemove: (order) {
                            _ordersBloc.cancelOrder(order);
                          },
                        );
                      },
                    );
                  } else {
                    return _buildEmptyList();
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        )
      ],
    );
  }

  Widget _buildEmptyList() {
    var words = AppLocalizations.of(context)!.noOrdersYet.split(" ");
    var lastWord = words.removeLast().replaceAll("!", "");

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          emptyOrdersPlaceholder,
          height: 188,
          width: 300,
        ),
        marginVertical(22),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: bodyText3,
              children: [
                TextSpan(text: words.join(" ")),
                TextSpan(
                    text: " " + lastWord,
                    style: bodyText3.copyWith(color: primaryColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        eventBus.fire(GoToSearchSalonsEvent());
                      }),
                TextSpan(text: "!"),
              ],
            )),
      ],
    );
  }

  @override
  void dispose() {
    _ordersBloc.dispose();
    super.dispose();
  }
}
