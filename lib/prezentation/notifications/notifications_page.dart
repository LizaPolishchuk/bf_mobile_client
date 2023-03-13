// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
// import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
// import 'package:salons_app_mobile/injection_container_app.dart';
// import 'package:salons_app_mobile/prezentation/notifications/notifications_bloc.dart';
// import 'package:salons_app_mobile/utils/app_colors.dart';
// import 'package:salons_app_mobile/utils/app_styles.dart';
//
// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({Key? key}) : super(key: key);
//
//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState();
// }
//
// class _NotificationsPageState extends State<NotificationsPage> {
//   late NotificationsBloc _notificationsBloc;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _notificationsBloc = getItApp<NotificationsBloc>();
//     _notificationsBloc.loadNotifications("masterId");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 18),
//       child: StreamBuilder<List<NotificationEntity>>(
//           stream: _notificationsBloc.notificationsLoaded,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator.adaptive());
//             } else {
//               var notificationList = snapshot.data ?? [];
//               return ListView.builder(
//                 itemBuilder: (context, index) {
//                   return _buildNotificationItem(notificationList[index]);
//                 },
//                 itemCount: notificationList.length,
//               );
//             }
//           }),
//     );
//   }
//
//   Widget _buildNotificationItem(NotificationEntity notification) {
//     return Container(
//       // height: 125,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(color: blurColor, blurRadius: 8, offset: Offset(0, 3))
//           ]),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     notification.title,
//                     style: bodyText4,
//                   ),
//                 ),
//                 Text(DateFormat('EE dd MMMM', "uk").format(notification.date),
//                     overflow: TextOverflow.clip, style: hintText3),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Divider(
//               color: primaryColor,
//               height: 1,
//               thickness: 1,
//             ),
//           ),
//          Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 notification.message ?? "",
//                 style: hintText2.copyWith(fontSize: 14),
//               ),
//             ),
//
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _notificationsBloc.dispose();
//
//     super.dispose();
//   }
// }
