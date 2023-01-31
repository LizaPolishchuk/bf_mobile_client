import 'package:flutter/widgets.dart';

class MasterMode with ChangeNotifier {
  bool isMaster;

  MasterMode({
    this.isMaster = false,
  });

  void setMasterMode(bool isMaster) {
    this.isMaster = isMaster;
    notifyListeners();
  }
}

class MasterData {
  bool isMaster;

  MasterData({this.isMaster = false});

// changeIsMaster (Color bgColor) {
//   backgroundColor = bgColor;
// }
}
