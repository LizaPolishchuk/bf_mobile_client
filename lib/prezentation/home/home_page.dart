import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/coming_orders_widget.dart';
import 'package:salons_app_mobile/prezentation/home/top_salons_widget.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';
import 'package:salons_app_mobile/prezentation/login/login_event.dart';
import 'package:salons_app_mobile/prezentation/login/login_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_state.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_bloc.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_event.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_bloc.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_event.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LoginBloc _loginBloc;
  late OrdersBloc _ordersBloc;
  late SalonsBloc _salonsBloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AlertBuilder _alertBuilder = AlertBuilder();

  @override
  void initState() {
    super.initState();

    _loginBloc = getItApp<LoginBloc>();
    _ordersBloc = getItApp<OrdersBloc>();
    _salonsBloc = getItApp<SalonsBloc>();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: true);

  void _onRefresh() async{
    _ordersBloc.add(LoadOrdersForCurrentUserEvent());
    _salonsBloc.add(LoadTopSalonsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.black),
        ),
        title: Text(tr(AppStrings.appName)),
      ),
      drawer: _buildDrawerMenu(),
      body: BlocProvider(
        create: (context) => _loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (BuildContext context, state) {
            if (state is ErrorLoginState) {
              _alertBuilder.showErrorDialog(context, state.failure.message);
            } else {
              _alertBuilder.stopErrorDialog(context);
            }

            if (state is LoggedOutState) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  (Route<dynamic> route) => false);
            }
          },
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopSalonsWidget(_salonsBloc),
                  marginVertical(46),
                  Expanded(child: ComingOrdersWidget(_ordersBloc, _refreshController))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerMenu() {
    return Drawer(
      child: Column(
        children: [
          Container(
              padding:
                  EdgeInsets.only(top: 56, bottom: 20, left: 16, right: 16),
              decoration: BoxDecoration(color: accentColor),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        tr(AppStrings.appName),
                        style: titleText2.copyWith(color: greyText),
                      ),
                      Spacer(),
                      InkWell(
                        child: SvgPicture.asset(icCancel),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  marginVertical(42),
                  Row(
                    children: [
                      imageWithPlaceholder("", avatarPlaceholder),
                      marginHorizontal(10),
                      Expanded(
                        child: Text("Имя пользователя",
                            style: bodyText3,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              )),
          marginVertical(40),
          _buildDrawerItem(tr(AppStrings.history), icHistory),
          _buildDrawerItem(tr(AppStrings.promo), icPromo),
          _buildDrawerItem(tr(AppStrings.bonusCards), icBonusCards),
          _buildDrawerItem(tr(AppStrings.settings), icSettings),
          _buildDrawerItem(tr(AppStrings.exit), icExit,
              onClick: () => _loginBloc.add(LogoutEvent())),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, String icon,
      {Widget? widgetToOpen, Function()? onClick}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28, left: 16, right: 16),
      child: InkWell(
        onTap: () {
          if (widgetToOpen != null)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => widgetToOpen));
          else if (onClick != null) onClick();
        },
        child: Row(
          children: [
            SvgPicture.asset(icon),
            marginHorizontal(8),
            Text(
              title,
              style: bodyText3.copyWith(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
