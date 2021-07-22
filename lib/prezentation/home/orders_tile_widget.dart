import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salons_app_mobile/prezentation/home/order_alert_widget.dart';
import 'package:salons_app_mobile/prezentation/home/order_options_widget.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';

class OrdersTileWidget extends StatelessWidget {
  ///todo Сюда на вход будет передаваться только обьект Order и с него все текстовки берем
  OrdersTileWidget({
    Key? key,
    required this.isPinned,
    required this.serviceName,
    required this.salonName,
    required this.orderDate,
    required this.masterImage,
    required this.masterName,
    required this.orderPrice,
    required this.onTap,
    required this.onPressed,
  }) : super(key: key);

  final String serviceName;
  final String salonName;
  final String orderDate;
  final String masterImage;
  final String masterName;
  final String orderPrice;
  final bool isPinned;
  VoidCallback onTap;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              width: 340,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$serviceName в $salonName', style: text16W600),
                      Text(orderDate,
                          overflow: TextOverflow.clip, style: text12W600),
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
            if (isPinned == true)
              Positioned(
                right: 20,
                top: 3,
                child: SvgPicture.asset(
                  'assets/icons/pushpin.svg',
                  color: Colors.black,
                  width: 10,
                  height: 10,
                ),
              ),
          ],
        ),
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          OrderOptionsWidget(
            text: 'Закрепить',
            myIcon: isPinned
                ? 'assets/icons/deletepin.svg'
                : 'assets/icons/pushpin.svg',
            color: Color(0xFFF2C420),
            isRounded: false,
            onTap: onTap,
          ),
          OrderOptionsWidget(
            text: 'Отменить запись',
            myIcon: 'assets/icons/cancel.svg',
            color: Color(0xFFE1440E),
            isRounded: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => OrderAlertWidget(
                  onPressed: onPressed,
                ),
              );
            },
          ),
        ],
      ),
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
        padding: EdgeInsets.all(14),
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
              style: GoogleFonts.inter(
                fontSize: 8,
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
