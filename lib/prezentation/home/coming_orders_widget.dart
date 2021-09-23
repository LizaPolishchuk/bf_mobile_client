import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_bloc.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_event.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_state.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

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

    // _ordersBloc = getItApp<OrdersBloc>();
    _ordersBloc = widget.ordersBloc;
    _ordersBloc.add(LoadOrdersForCurrentUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ordersBloc,
      child: BlocListener<OrdersBloc, OrdersState>(
        listener: (BuildContext context, state) {
          if (state is ErrorOrdersState) {
            _alertBuilder.showErrorDialog(context, state.failure.message);
          } else {
            _alertBuilder.stopErrorDialog(context);
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr(AppStrings.comingOrders), style: bodyText3),
                textWithArrowRight(tr(AppStrings.all), () {}),
              ],
            ),
            marginVertical(16),
            Expanded(
              child: StreamBuilder<List<OrderEntity>>(
                  stream: _ordersBloc.streamOrders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting) {
                      
                      SchedulerBinding.instance?.addPostFrameCallback((_) {
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
                                _ordersBloc.add(PinOrderEvent(order));
                              },
                              onPressedRemove: (order) {
                                _ordersBloc.add(CancelOrderEvent(order));
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
        ),
      ),
    );
  }

  Widget _buildEmptyList() {
    var words = tr(AppStrings.noOrdersYet).split(" ");
    var lastWord = words.removeLast().replaceAll("!", "");

    return Column(
      children: [
        Image.asset(emptyListPlaceholder),
        RichText(
            text: TextSpan(
          style: bodyText3,
          children: [
            TextSpan(text: words.join(" ")),
            TextSpan(
                text: " " + lastWord,
                style: bodyText3.copyWith(color: primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print('Terms of Service"');
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
