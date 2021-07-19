import 'package:flutter/material.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';

class EmptyListImageWidget extends StatelessWidget {
  const EmptyListImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset('assets/images/MessageSent.png'),
          Text('У Вас пока что нет записей.', style: text16W600.copyWith(height: 0.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Самое время создать',
                style: text16W600.copyWith(height: 0.5),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'новую!',
                  style: text16W600.copyWith(
                      color: Colors.blue, height: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}