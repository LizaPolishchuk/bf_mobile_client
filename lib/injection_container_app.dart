import 'package:bf_mobile_client/prezentation/categories/categories_bloc.dart';
import 'package:bf_mobile_client/prezentation/choose_service/services_bloc.dart';
import 'package:bf_mobile_client/prezentation/login/code_verification_bloc.dart';
import 'package:bf_mobile_client/prezentation/login/login_bloc.dart';
import 'package:bf_mobile_client/prezentation/orders/appointment_bloc.dart';
import 'package:bf_mobile_client/prezentation/profile/profile_bloc.dart';
import 'package:bf_mobile_client/prezentation/registration/registration_bloc.dart';
import 'package:bf_mobile_client/prezentation/salon_details/salon_details_bloc.dart';
import 'package:bf_mobile_client/prezentation/salons_list/salons_bloc.dart';
import 'package:bf_mobile_client/prezentation/search_filters/search_filters_bloc.dart';
import 'package:get_it/get_it.dart';

import 'prezentation/notifications/notifications_bloc.dart';

final getItApp = GetIt.instance;

Future<void> init() async {
  ///Bloc
  getItApp.registerFactory(() => LoginBloc(getItApp(), getItApp()));
  getItApp.registerFactory(() => CodeVerifyBloc(getItApp()));
  getItApp.registerFactory(() => RegistrationBloc(getItApp()));
  getItApp.registerFactory(() => NotificationsBloc(getItApp()));
  getItApp.registerFactory(() => SalonsBloc(getItApp(), getItApp()));
  getItApp.registerFactory(
      () => OrdersBloc(getItApp(), getItApp(), getItApp(), getItApp()));
  getItApp.registerFactory(() => ServicesBloc(getItApp()));
  getItApp.registerFactory(() => CategoriesBloc(getItApp()));
  getItApp.registerFactory(
      () => SalonDetailsBloc(getItApp(), getItApp(), getItApp(), getItApp()));
  getItApp.registerFactory(
      () => ProfileBloc(getItApp(), getItApp(), getItApp(), getItApp()));
  getItApp.registerFactory(() => SearchFiltersBloc(getItApp()));
}
