import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/alerts/cancel_order_alert_widget.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class OrdersItemWidget extends StatelessWidget {
  OrdersItemWidget({
    Key? key,
    required this.order,
    required this.onPressedPin,
    required this.onPressedRemove,
    this.enableSlidebar = true,
  }) : super(key: key);

  final OrderEntity order;
  final Function(OrderEntity order) onPressedPin;
  final Function(OrderEntity order) onPressedRemove;
  final bool enableSlidebar;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      height: 100,
      child: Slidable(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: blurColor, blurRadius: 8, offset: Offset(0, 3))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                        '${order.serviceName} ${tr(AppStrings.inTxt)} ${order.salonName}',
                        style: bodyText3.copyWith(fontSize: 16)),
                  ),
                  Text(DateFormat('EE dd MMMM', "ru").format(order.date),
                      overflow: TextOverflow.clip,
                      style: bodyText3.copyWith(fontSize: 12)),
                  if (order.isPinned == true)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SvgPicture.asset(
                        icPin,
                        color: Colors.black,
                        width: 10,
                        height: 10,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  imageWithPlaceholder(order.masterAvatar, masterPlaceholder),
                  marginHorizontal(8),
                  Text('${tr(AppStrings.master)} ${order.masterName}',
                      style: bodyText3.copyWith(fontSize: 12)),
                  Spacer(),
                  //Text('${order.price} ${tr(AppStrings.uah)}',
                  //style: bodyText3.copyWith(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        enabled: enableSlidebar,
        endActionPane: ActionPane(
          motion: SizedBox.shrink(),
          children: [
            //TODO: разкоментувати
            // _buildSlideOption(
            //   tr(AppStrings.pin),
            //   primaryColor,
            //   order.isPinned ? icUnpin : icPin,
            //   () => onPressedPin(order),
            // ),
            // _buildSlideOption(
            //   tr(AppStrings.cancelOrder),
            //   errorRed,
            //   icCancel,
            //   () {
            //     showDialog(
            //       context: context,
            //       builder: (context) => CancelOrderAlertWidget(
            //         onPressedConfirm: () => onPressedRemove(order),
            //       ),
            //     );
            //   },
            //   isRounded: true,
            // ),
          ],
        ),
      ),
    );
  }

  //TODO: пофіксити
  // Widget _buildSlideOption(
  //     String text, Color color, String icon, Function() onTap,
  //     {bool isRounded = false}) {
  //   return SlideAction(
  //     decoration: BoxDecoration(
  //       color: color,
  //       borderRadius: isRounded
  //           ? BorderRadius.only(
  //               topRight: Radius.circular(10), bottomRight: Radius.circular(10))
  //           : null,
  //     ),
  //     onTap: onTap,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         SvgPicture.asset(
  //           icon,
  //           height: 15,
  //           width: 15,
  //           color: Colors.white,
  //         ),
  //         marginVertical(6),
  //         Text(
  //           text,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 10,
  //             fontWeight: FontWeight.w400,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
