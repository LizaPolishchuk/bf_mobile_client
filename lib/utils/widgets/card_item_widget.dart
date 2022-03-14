import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class CardItemWidget extends StatelessWidget {

  final BaseEntity item;
  final VoidCallback onClick;

  const CardItemWidget(this.item, this.onClick);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 18),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: blurColor,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: bodyText4,
                ),
                marginVertical(6),
                Text(
                  item.description ?? "",
                  style: bodyText1.copyWith(color: Colors.black),
                ),
                Spacer(),
                buttonMoreWithRightArrow(onPressed: onClick),
              ],
            ),
            Spacer(),
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      // salon.photoPath ??
                      "https://vjoy.cc/wp-content/uploads/2019/08/4-20.jpg"),
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
