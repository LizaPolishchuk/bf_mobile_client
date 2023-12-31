import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_images.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class AppointmentsItemWidget extends StatelessWidget {
  AppointmentsItemWidget({
    Key? key,
    required this.appointment,
    required this.onPressedPin,
    required this.onPressedRemove,
    this.enableSlidebar = true,
  }) : super(key: key);

  final AppointmentEntity appointment;
  final Function(AppointmentEntity) onPressedPin;
  final Function(AppointmentEntity) onPressedRemove;
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
                        '${appointment.serviceName} ${AppLocalizations.of(context)!.inTxt} ${appointment.salonName}',
                        style: bodyText3.copyWith(fontSize: 16)),
                  ),
                  Text(DateFormat('EE dd MMMM', "ru").format(appointment.date),
                      overflow: TextOverflow.clip,
                      style: bodyText3.copyWith(fontSize: 12)),
                  // if (appointment.isPinned == true)
                  //   Padding(
                  //     padding: const EdgeInsets.only(left: 4),
                  //     child: SvgPicture.asset(
                  //       icPin,
                  //       color: Colors.black,
                  //       width: 10,
                  //       height: 10,
                  //     ),
                  //   ),
                ],
              ),
              Row(
                children: [
                  imageWithPlaceholder(appointment.masterPhoto, masterPlaceholder),
                  marginHorizontal(8),
                  Text('${AppLocalizations.of(context)!.master} ${appointment.masterName}',
                      style: bodyText3.copyWith(fontSize: 12)),
                  Spacer(),
                  // Text('${order.price} ${tr(AppStrings.uah)}',
                  //     style: bodyText3.copyWith(fontSize: 12)),
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
