import 'package:flutter/material.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';

class OrdersTileWidget extends StatelessWidget {
  const OrdersTileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      width: 340,
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Color(0x22222222), blurRadius: 6, offset: Offset(0, 2))]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Маникюр в Example Salon', style: text16W600),
              Text('Вт, 23 мая', style: text12W600),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.red,
                // child: Image.network('assets/images/'),
              ),
              SizedBox(width: 8),
              Text('Мастер Olha', style: text12W500),
              Spacer(),
              Text('300 грн', style: text12W600),
            ],
          ),
        ],
      ),
    );
  }
}