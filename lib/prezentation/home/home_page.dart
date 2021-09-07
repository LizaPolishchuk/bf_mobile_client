import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/home_bloc.dart';
import 'package:salons_app_mobile/prezentation/home/home_event.dart';
import 'package:salons_app_mobile/prezentation/home/orders_tile_widget.dart';
import 'package:salons_app_mobile/prezentation/home/top_salons_carousel_widget.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';
import 'package:salons_app_mobile/prezentation/login/login_event.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
//                  image: DecorationImage(
//                      image: AssetImage("images/header.jpeg"),
//                      fit: BoxFit.cover),
              ),
              child: Text("Header"),
            ),
            ListTile(
              title: Text("Home"),
            ),
            ListTile(
              title: Text("Выйти"),
              onTap: () {
                getIt<LoginBloc>().add(LogoutEvent());
              },
            ),
          ],
        ),
      ),
      body: Padding(
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
                        style: text12W500.copyWith(color: Color(0xff6B7280)),
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
    );
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }
}
