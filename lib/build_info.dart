class BuildInfo {
  static final BuildInfo _instance = BuildInfo._internal();
  factory BuildInfo() {
    return _instance;
  }
  BuildInfo._internal();

  String? firebaseUserId;
  String? firebaseInstallationId;
  String? pushToken;
  bool isMasterMode = false;
}
