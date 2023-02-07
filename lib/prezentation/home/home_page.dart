import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/prezentation/home/coming_orders_widget.dart';
import 'package:salons_app_mobile/prezentation/home/top_salons_widget.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_bloc.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_bloc.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/date_utils.dart';
import 'package:salons_app_mobile/utils/master_mode.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late OrdersBloc _ordersBloc;
  late SalonsBloc _salonsBloc;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();

    _ordersBloc = getItApp<OrdersBloc>();
    _salonsBloc = getItApp<SalonsBloc>();

    Provider.of<MasterMode>(context, listen: false)
        .addListener(_masterModeListener);
  }

  _masterModeListener() {
    print("_masterModeListener");

    if (_refreshController.isRefresh) {
      _refreshController.refreshCompleted();
    }
    _refreshController.requestRefresh();
  }

  void _onRefresh() async {
    print(
        "_onRefresh: ${Provider.of<MasterMode>(context, listen: false).isMaster}");

    if (Provider.of<MasterMode>(context, listen: false).isMaster) {
      _ordersBloc.getOrdersForCurrentMaster(
          dateFrom: DateTime.now().formatToYYYYMMddWithTime());
    } else {
      _ordersBloc.getOrdersForCurrentUser(
          dateFrom: DateTime.now().formatToYYYYMMddWithTime());
      _salonsBloc.loadTopSalons();
    }
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
            AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Provider.of<MasterMode>(context).isMaster
                    ? _buildMasterHeader()
                    : TopSalonsWidget(_salonsBloc)),
            marginVertical(32),
            Expanded(
              child: ComingOrdersWidget(_ordersBloc, _refreshController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterHeader() {
    return Container(
      constraints: BoxConstraints(minHeight: 150, minWidth: double.infinity),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 27),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Hello, ${getItApp<LocalStorage>().getCurrentUser()?.name ?? ""}",
            style: buttonText,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          marginVertical(16),
          Text(
            "Твої записи кліентів на сьогодні, ${DateTime.now().formatToddMMYYYY()}!",
            style: hintText2.copyWith(color: Colors.white),
            maxLines: 3,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Provider.of<MasterMode>(context, listen: false)
    //     .removeListener(_masterModeListener);

    super.dispose();
  }
}
