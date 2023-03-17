import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CancelOrderAlertWidget extends StatelessWidget {
  CancelOrderAlertWidget({
    Key? key,
    required this.onPressedConfirm,
  }) : super(key: key);

  final VoidCallback onPressedConfirm;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 330,
        height: 290,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Отменить запись?', style: text20W700),
            SizedBox(height: 16),
            Text(
              'Вы уверены, что хотите отменить данную запись? В случае согласия Ваш визит будет отменен.',
              textAlign: TextAlign.center,
              style: text16W400.copyWith(color: Color(0xFF7A7E80)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onPressedConfirm();
                Navigator.of(context).pop();
              },
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
    );
  }
}
