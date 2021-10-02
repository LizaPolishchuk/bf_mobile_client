import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/categories/choose_category_page.dart';
import 'package:salons_app_mobile/prezentation/choose_service/choose_service_page.dart';
import 'package:salons_app_mobile/prezentation/home/home_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_page.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_state.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_page.dart';
import 'package:salons_app_mobile/prezentation/salons_list/search_salons_page.dart';

import 'nav_event.dart';

enum TabItem { home, search }

class NavBloc extends Bloc<NavEvent, NavState> {
  Map<TabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
  };
  var currentTab = TabItem.home;

  NavBloc() : super(InitialNavState());

  @override
  Stream<NavState> mapEventToState(NavEvent event) async* {
    var currentState = tabNavigatorKeys[currentTab]?.currentState;

    if (event is NavPopAll) {
      currentState?.popUntil((r) => r.isFirst);
    } else if (event is NavPop) {
      currentState?.pop();
    } else if (event is NavLogin) {
      currentState?.pushNamed(LoginPage.routeName, arguments: event.arguments);
    } else if (event is NavSalonDetails) {
      currentState?.pushNamed(SalonDetailsPage.routeName, arguments: event.arguments);
    } else if (event is NavChooseServicePage) {
      var navResult = await currentState?.pushNamed(ChooseServicePage.routeName, arguments: event.arguments);
      yield NavigationResultedState(navResult);
    } else if (event is NavChooseCategoryPage) {
       currentState?.pushNamed(ChooseCategoryPage.routeName, arguments: event.arguments);
    }

  }

  /// Nav bloc state handler
  Map<String, WidgetBuilder> getAllRoutes(RouteSettings settings) {
    List<Object> argsList = settings.arguments as List<Object>? ?? [];
    return {
      HomePage.routeName: (context) => HomePage(),
      SearchSalonsPage.routeName: (context) => SearchSalonsPage(),
      SalonDetailsPage.routeName: (context) => SalonDetailsPage((argsList.first as Salon)),
      LoginPage.routeName: (context) => LoginPage(),
      ChooseCategoryPage.routeName: (context) => ChooseCategoryPage(argsList.first as Salon),
      ChooseServicePage.routeName: (context) => ChooseServicePage(argsList.first as Salon, argsList[1] as String),
    };
  }

  MaterialPageRoute onGenerateRoutes(
      RouteSettings settings, Widget initialRoute) {
    print('tab build route for ${settings.name}, initialRoute: $initialRoute');

    var routes = getAllRoutes(settings);
    WidgetBuilder builder = settings.name == "/"
        ? (context) => initialRoute
        : routes[settings.name]!;
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
