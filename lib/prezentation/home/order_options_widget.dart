import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salons_app_mobile/prezentation/home/order_alert_widget.dart';

class OrderOptionsWidget extends StatelessWidget {
  const OrderOptionsWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.icon,
    required this.isRounded,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final Color color;
  final IconData icon;
  final bool isRounded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 10,
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
            Icon(icon, color: Colors.white),
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
