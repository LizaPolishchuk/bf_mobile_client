import 'package:get_it/get_it.dart';
import 'package:salons_app_mobile/prezentation/home/home_bloc.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_bloc.dart';

final getItApp = GetIt.instance;

Future<void> init() async {
  ///Bloc
  // getItApp.registerLazySingleton(() => NavBloc());
  getItApp.registerFactory(() => LoginBloc(getItApp(), getItApp(), getItApp(), getItApp(), getItApp()));
  getItApp.registerFactory(() => HomeBloc(getItApp(), getItApp(), getItApp(), getItApp()));
  getItApp.registerFactory(() => RegistrationBloc(getItApp()));
}
