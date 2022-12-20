import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_images.dart';

class AppDowlandPhoto extends StatelessWidget {
  const AppDowlandPhoto({
    Key? key,
    required this.onTap,
    required this.pickedAvatar,
    this.user,
  }) : super(key: key);

  final Function() onTap;
  final File? pickedAvatar;
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      width: 93,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          pickedAvatar != null
              ? ClipRRect(
                  child: Image.file(
                    pickedAvatar!,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(100),
                )
              : user?.avatar?.isNotEmpty == true
                  ? ClipRRect(
                      child: Image.network(
                        user!.avatar!,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    )
                  : SvgPicture.asset(
                      icProfilePlaceholder,
                      height: 50,
                      width: 50,
                    ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 24,
                width: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 1,
                    color: primaryColor,
                  ),
                ),
                child: SvgPicture.asset(icCamera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
