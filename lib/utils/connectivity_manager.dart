import 'package:connectivity/connectivity.dart';

class ConnectivityManager {
  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      throw(NoInternetException());
    }
  }
}

class NoInternetException implements Exception{
  String noInternetMessage = "No Internet Connection";
}
