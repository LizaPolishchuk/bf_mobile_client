import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/alerts/cancel_order_alert_widget.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class OrdersTileWidget extends StatelessWidget {
  OrdersTileWidget({
    Key? key,
    required this.order,
    required this.onPressedPin,
    required this.onPressedRemove,
  }) : super(key: key);

  final OrderEntity order;
  final Function(OrderEntity order) onPressedPin;
  final Function(OrderEntity order) onPressedRemove;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            margin: const EdgeInsets.only(bottom: 8),
            height: 95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Color(0x22222222),
                    blurRadius: 6,
                    offset: Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('${order.serviceName} в ${order.salonName}',
                          style: text16W600),
                    ),
                    Text(DateFormat('EE dd MMMM', "ru").format(DateTime.now()),
                        overflow: TextOverflow.clip, style: text12W600),
                    if (order.isPinned == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: SvgPicture.asset(
                          'assets/icons/pushpin.svg',
                          color: Colors.black,
                          width: 10,
                          height: 10,
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    imageWithPlaceholder(order.masterAvatar, masterPlaceholder),
                    marginHorizontal(8),
                    Text('Мастер ${order.masterName}', style: text12W500),
                    Spacer(),
                    Text('${order.price} грн', style: text12W600),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        OrderOptionsWidget(
          text: 'Закрепить',
          myIcon: order.isPinned
              ? 'assets/icons/deletepin.svg'
              : 'assets/icons/pushpin.svg',
          color: Color(0xFFF2C420),
          isRounded: false,
          onTap: () => onPressedPin(order),
        ),
        OrderOptionsWidget(
          text: 'Отменить запись',
          myIcon: 'assets/icons/cancel.svg',
          color: Color(0xFFE1440E),
          isRounded: true,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => CancelOrderAlertWidget(
                onPressedConfirm: () => onPressedRemove(order),
              ),
            );
          },
        ),
      ],
    );
  }
}

class OrderOptionsWidget extends StatelessWidget {
  const OrderOptionsWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.myIcon,
    required this.isRounded,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final Color color;
  final String myIcon;
  final bool isRounded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 95,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: isRounded
              ? BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(myIcon),
            SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
