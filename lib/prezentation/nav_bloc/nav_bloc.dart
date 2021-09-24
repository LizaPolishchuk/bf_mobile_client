import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salons_app_mobile/prezentation/home/home_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_page.dart';
import 'package:salons_app_mobile/prezentation/salons_list/search_salons_page.dart';

import 'nav_event.dart';

enum TabItem { home, search }

class NavBloc extends Bloc<NavEvent, dynamic> {
  Map<TabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
  };
  var currentTab = TabItem.home;

  NavBloc() : super(0);

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(NavEvent event) async* {
    var currentState = tabNavigatorKeys[currentTab]?.currentState;

    if (event is NavPopAll) {
      currentState?.popUntil((r) => r.isFirst);
    } else if (event is NavPop) {
      currentState?.pop();
    } else if (event is NavLogin) {
      currentState?.pushNamed(LoginPage.routeName, arguments: event.arguments);
    }
    // else if (event is NavRatingDetails) {
    //   currentState?.pushNamed(RatingDetailsPage.routeName,
    //       arguments: event.arguments);
    // } else if (event is NavEditRatingDetails) {
    //   currentState?.pushNamed(EditRatingDetailsPage.routeName,
    //       arguments: event.arguments);
    // }
  }

  /// Nav bloc state handler
  Map<String, WidgetBuilder> getAllRoutes(RouteSettings settings) {
    List<Object> argsList = settings.arguments as List<Object>? ?? [];
    return {
      HomePage.routeName: (context) => HomePage(),
      SearchSalonsPage.routeName: (context) => SearchSalonsPage(),
      //     RatingDetailsPage(argsList.first, argsList[1]),
      LoginPage.routeName: (context) => LoginPage(),
    };
  }

  MaterialPageRoute onGenerateRoutes(
      RouteSettings settings, Widget initialRoute) {
    print('tab build route for ${settings.name}, initialRoute: $initialRoute');

    var routes = getAllRoutes(settings);
    WidgetBuilder builder = settings.name == "/" ? (context) => initialRoute : routes[settings.name]!;
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
