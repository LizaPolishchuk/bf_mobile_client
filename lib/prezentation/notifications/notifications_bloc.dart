// import 'dart:async';
//
// import 'package:rxdart/subjects.dart';
// import 'package:bf_network_module/bf_network_module.dart';
//
// class NotificationsBloc {
//   final GetNotificationsListUseCase _getNotificationListUseCase;
//
//   NotificationsBloc(this._getNotificationListUseCase);
//
//   final _notificationsLoadedSubject =
//       PublishSubject<List<NotificationEntity>>();
//   final _errorSubject = PublishSubject<String>();
//   final _isLoadingSubject = PublishSubject<bool>();
//
//   // output stream
//   Stream<List<NotificationEntity>> get notificationsLoaded =>
//       _notificationsLoadedSubject.stream;
//
//   Stream<String> get errorMessage => _errorSubject.stream;
//
//   Stream<bool> get isLoading => _isLoadingSubject.stream;
//
//   loadNotifications(String masterId) async {
//     final response = await _getNotificationListUseCase(masterId);
//
//     if (response.isLeft) {
//       _errorSubject.add(response.left.message);
//     } else {
//       _notificationsLoadedSubject.add(response.right);
//     }
//   }
//
//   dispose() {
//     _notificationsLoadedSubject.close();
//     _isLoadingSubject.close();
//     _errorSubject.close();
//   }
// }
