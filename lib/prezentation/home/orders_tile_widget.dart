import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:salons_app_mobile/prezentation/home/order_alert_widget.dart';
import 'package:salons_app_mobile/prezentation/home/order_options_widget.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class OrdersTileWidget extends StatelessWidget {
  ///todo Сюда на вход будет передаваться только обьект Order и с него все текстовки берем
  const OrdersTileWidget({
    Key? key,
    required this.orderText,
    required this.orderDate,
    required this.masterImage,
    required this.masterName,
    required this.orderPrice,
  }) : super(key: key);

  final String orderText;
  final String orderDate;
  final String masterImage;
  final String masterName;
  final String orderPrice;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        height: 95,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color(0x22222222), blurRadius: 6, offset: Offset(0, 2))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(orderText, style: text16W600),
                Text(orderDate, style: text12W600),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                imageWithPlaceholder(masterImage, masterPlaceholder),
                marginHorizontal(8),
                Text('Мастер $masterName', style: text12W500),
                Spacer(),
                Text('$orderPrice грн', style: text12W600),
              ],
            ),
          ],
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        OrderOptionsWidget(
          text: 'Закрепить',
          icon: Icons.push_pin_outlined,
          color: Color(0xFFF2C420),
          isRounded: false,
          onTap: () {},
        ),
        OrderOptionsWidget(
          text: 'Отменить запись',
          icon: Icons.cancel,
          color: Color(0xFFE1440E),
          isRounded: true,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => OrderAlertWidget(),
            );
          },
        ),
      ],
    );
  }
}
