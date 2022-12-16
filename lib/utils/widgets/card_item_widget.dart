import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class CardItemWidget extends StatelessWidget {
  final BaseEntity item;
  final VoidCallback onClick;
  final VoidCallback? onClickStar;

  const CardItemWidget(this.item, this.onClick, {this.onClickStar});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    height: 85,
                    width: 90,
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
                  marginHorizontal(20),
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
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
            if (item is Salon)
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    onClickStar?.call();
                  },
                  child: Container(
                    height: 40,
                    width: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffEBEAEA),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    child: SvgPicture.asset(
                      (item as Salon).isFavourite
                          ? icStarChecked
                          : icStarUnchecked,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
