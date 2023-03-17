import 'package:bf_mobile_client/prezentation/categories/choose_category_page.dart';
import 'package:bf_mobile_client/prezentation/choose_service/choose_service_page.dart';
import 'package:bf_mobile_client/prezentation/create_order/create_order_page.dart';
import 'package:bf_mobile_client/prezentation/home/home_page.dart';
import 'package:bf_mobile_client/prezentation/individual_appointments/create_individual_appointment_page.dart';
import 'package:bf_mobile_client/prezentation/login/login_page.dart';
import 'package:bf_mobile_client/prezentation/orders_history/orders_history_page.dart';
import 'package:bf_mobile_client/prezentation/profile/settings_page.dart';
import 'package:bf_mobile_client/prezentation/salon_details/salon_details_page.dart';
import 'package:bf_mobile_client/prezentation/salons_list/favourite_salons_page.dart';
import 'package:bf_mobile_client/prezentation/salons_list/search_salons_page.dart';
import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

MaterialPageRoute onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      return materialPageRoute(HomePage());
    case SearchSalonsPage.routeName:
      return materialPageRoute(SearchSalonsPage());
    case SalonDetailsPage.routeName:
      return materialPageRoute(SalonDetailsPage(settings.arguments as Salon));
    case LoginPage.routeName:
      return materialPageRoute(LoginPage());
    case ChooseCategoryPage.routeName:
      return materialPageRoute(ChooseCategoryPage(settings.arguments as Salon));
    case ChooseServicePage.routeName:
      return materialPageRoute(ChooseServicePage(
          (settings.arguments as List<dynamic>).first as String,
          (settings.arguments as List<dynamic>)[1] as String,
          (settings.arguments as List<dynamic>)[2] as Service?));
    case CreateOrderPage.routeName:
      return materialPageRoute(CreateOrderPage(
          (settings.arguments as List<dynamic>).first as Salon,
          (settings.arguments as List<dynamic>)[1] as String));
    case OrdersHistoryPage.routeName:
      return materialPageRoute(OrdersHistoryPage());
    case SettingsPage.routeName:
      return materialPageRoute(SettingsPage());
    case FavouriteSalonsPage.routeName:
      return materialPageRoute(FavouriteSalonsPage());
    case CreateIndividualAppointmentPage.routeName:
      return materialPageRoute(CreateIndividualAppointmentPage());
    default:
      return materialPageRoute(HomePage());
  }
}

MaterialPageRoute materialPageRoute(Widget page) {
  return MaterialPageRoute(builder: (context) => page);
}
