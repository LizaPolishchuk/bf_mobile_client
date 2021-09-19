import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/home_bloc.dart';
import 'package:salons_app_mobile/prezentation/home/home_event.dart';
import 'package:salons_app_mobile/prezentation/home/home_state.dart';
import 'package:salons_app_mobile/prezentation/home/orders_tile_widget.dart';
import 'package:salons_app_mobile/prezentation/home/top_salons_carousel_widget.dart';
import 'package:salons_app_mobile/prezentation/login/login_page.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

import 'empty_list_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _homeBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AlertBuilder _alertBuilder = AlertBuilder();

  @override
  void initState() {
    super.initState();

    _homeBloc = getItApp<HomeBloc>();
    _homeBloc.add(LoadOrdersForCurrentUserEvent());
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
        title: Text(
          tr(AppStrings.appName),
          style: text16W600.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: _buildDrawerMenu(),
      body: BlocProvider(
        create: (context) => _homeBloc,
        child: BlocListener<HomeBloc, HomeState>(
          listener: (BuildContext context, state) {
            _alertBuilder.stopErrorDialog(context);

            if (state is LoggedOutState) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                  (Route<dynamic> route) => false);
            } else if (state is ErrorHomeState) {
              _alertBuilder.showErrorDialog(context, state.failure.message);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(AppStrings.topSalons),
                  style: text16W600,
                ),
                TopSalonsCarouselWidget(),
                marginVertical(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ближайшие записи', style: text16W600),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            'Все',
                            style:
                                text12W500.copyWith(color: Color(0xff6B7280)),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: 18,
                            color: Color(0xff6B7280),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                marginVertical(16),
                Expanded(
                  child: StreamBuilder<List<OrderEntity>>(
                    stream: _homeBloc.streamOrders,
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data!.length > 0) {
                        var orders = snapshot.data!;
                        return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return OrdersTileWidget(
                              order: orders[index],
                              onPressedPin: (order) {
                                _homeBloc.add(PinOrderEvent(order));
                              },
                              onPressedRemove: (order) {
                                _homeBloc.add(CancelOrderEvent(order));
                              },
                            );
                          },
                        );
                      } else {
                        return EmptyListImageWidget();
                      }
                    },
                  ),
                ),
              ],
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
              onClick: () => _homeBloc.add(SignOutEvent())),
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

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }
}
