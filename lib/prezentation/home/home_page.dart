import 'package:bf_mobile_client/injection_container_app.dart';
import 'package:bf_mobile_client/prezentation/appointments/appointment_bloc.dart';
import 'package:bf_mobile_client/prezentation/home/coming_appointments_widget.dart';
import 'package:bf_mobile_client/prezentation/home/top_salons_widget.dart';
import 'package:bf_mobile_client/prezentation/salons_list/salons_bloc.dart';
import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/date_utils.dart';
import 'package:bf_mobile_client/utils/master_mode.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppointmentsBloc _appointmentsBloc;
  late SalonsBloc _salonsBloc;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();

    _appointmentsBloc = getItApp<AppointmentsBloc>();
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
      _appointmentsBloc.getOrdersForCurrentMaster(
          dateFrom: DateTime.now().formatToYYYYMMddWithTime());
    } else {
      _appointmentsBloc.getAppointmentsForCurrentUser(
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
              child: ComingOrdersWidget(_appointmentsBloc, _refreshController),
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
