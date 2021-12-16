import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/categories/choose_category_page.dart';
import 'package:salons_app_mobile/prezentation/choose_service/choose_service_page.dart';
import 'package:salons_app_mobile/prezentation/create_order/create_order_page.dart';
import 'package:salons_app_mobile/prezentation/home/home_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_page.dart';
import 'package:salons_app_mobile/prezentation/orders_history/orders_history_page.dart';
import 'package:salons_app_mobile/prezentation/profile/settings_page.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_page.dart';
import 'package:salons_app_mobile/prezentation/salons_list/search_salons_page.dart';

MaterialPageRoute onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      return materialPageRoute(HomePage());
    case SearchSalonsPage.routeName:
      return materialPageRoute(SearchSalonsPage());
    case SalonDetailsPage.routeName:
      return materialPageRoute(SalonDetailsPage(settings.arguments as String));
    case LoginPage.routeName:
      return materialPageRoute(LoginPage());
    case ChooseCategoryPage.routeName:
      return materialPageRoute(ChooseCategoryPage(settings.arguments as Salon));
    case ChooseServicePage.routeName:
      return materialPageRoute(ChooseServicePage(
          (settings.arguments as List<dynamic>).first as String,
          (settings.arguments as List<dynamic>)[1] as String));
    case CreateOrderPage.routeName:
      return materialPageRoute(CreateOrderPage(
          (settings.arguments as List<dynamic>).first as Salon,
          (settings.arguments as List<dynamic>)[1] as String));
    case OrdersHistoryPage.routeName:
      return materialPageRoute(OrdersHistoryPage());
    case SettingsPage.routeName:
      return materialPageRoute(SettingsPage());
    default:
      return materialPageRoute(HomePage());
  }
}

MaterialPageRoute materialPageRoute(Widget page) {
  return MaterialPageRoute(builder: (context) => page);
}
