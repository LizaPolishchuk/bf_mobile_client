import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/prezentation/home/coming_orders_widget.dart';
import 'package:salons_app_mobile/prezentation/home/top_salons_widget.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_bloc.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_bloc.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/date_utils.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late OrdersBloc _ordersBloc;
  late SalonsBloc _salonsBloc;

  @override
  void initState() {
    super.initState();

    _ordersBloc = getItApp<OrdersBloc>();
    _salonsBloc = getItApp<SalonsBloc>();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    _ordersBloc.getOrdersForCurrentUser(
        dateFrom: DateTime.now().formatToYYYYMMddWithTime());
    _salonsBloc.loadTopSalons();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopSalonsWidget(_salonsBloc),
            marginVertical(46),
            Expanded(
              child: ComingOrdersWidget(_ordersBloc, _refreshController),
            ),
          ],
        ),
      ),
    );
  }
}
