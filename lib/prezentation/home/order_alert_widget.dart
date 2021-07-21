import 'package:flutter/material.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';

class OrderAlertWidget extends StatelessWidget {
 OrderAlertWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 330,
        height: 290,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Отменить запись?', style: text20W700),
              Text(
                'Вы уверены, что хотите отменить данную запись? В случае согласия Ваш визит будет отменен.',
                style: text16W400.copyWith(color: Color(0xFF7A7E80)),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: onPressed,
                child: Text(
                  'Да',
                  style: text16W400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF6B4EFF)),
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24))),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 128, vertical: 16)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Закрыть',
                  style: text16W600.copyWith(
                      fontWeight: FontWeight.w500, color: Color(0xFF6B4EFF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
