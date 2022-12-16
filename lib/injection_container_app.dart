import 'package:get_it/get_it.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';


final getItApp = GetIt.instance;

Future<void> init() async {
  ///Bloc
  // getItApp.registerLazySingleton(() => NavBloc());
  getItApp.registerFactory(() =>
      LoginBloc(getItApp(), getItApp(), getItApp(), getItApp(), getItApp()));

}
