import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_images.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class CardItemWidget extends StatelessWidget {
  final BaseEntity item;
  final VoidCallback onClick;
  final VoidCallback? onClickStar;
  final bool smallSize;

  const CardItemWidget(this.item, this.onClick, {this.onClickStar, this.smallSize = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        height: smallSize ? 95 : 120,
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
                    height: smallSize ? 65 : 85,
                    width: smallSize ? 60 : 90,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            // salon.photoPath ??
                            "https://vjoy.cc/wp-content/uploads/2019/08/4-20.jpg"),
                      ),
                      borderRadius: BorderRadius.circular(smallSize ? 15 : 25),
                    ),
                  ),
                  marginHorizontal(20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: bodyText4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        marginVertical(6),
                        Text(
                          item.description ?? "",
                          style: bodyText1.copyWith(color: Colors.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
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
