import 'package:get_it/get_it.dart';
import 'package:salons_app_mobile/prezentation/categories/categories_bloc.dart';
import 'package:salons_app_mobile/prezentation/choose_service/services_bloc.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_bloc.dart';
import 'package:salons_app_mobile/prezentation/orders/orders_bloc.dart';
import 'package:salons_app_mobile/prezentation/profile/profile_bloc.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_bloc.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_bloc.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_bloc.dart';

final getItApp = GetIt.instance;

Future<void> init() async {
  ///Bloc
  getItApp.registerLazySingleton(() => NavBloc());

  getItApp.registerFactory(() => LoginBloc(getItApp(), getItApp(), getItApp(), getItApp(), getItApp()));
  getItApp.registerFactory(() => RegistrationBloc(getItApp()));
  getItApp.registerFactory(() => SalonsBloc(getItApp()));
  getItApp.registerFactory(() => OrdersBloc(getItApp(), getItApp(), getItApp(), getItApp()));
  getItApp.registerFactory(() => ServicesBloc(getItApp()));
  getItApp.registerFactory(() => CategoriesBloc(getItApp()));
  getItApp.registerFactory(() => SalonDetailsBloc(getItApp()));
  getItApp.registerFactory(() => ProfileBloc(getItApp(), getItApp(), getItApp()));
}
