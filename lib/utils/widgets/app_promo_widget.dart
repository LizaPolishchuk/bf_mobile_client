

import 'package:flutter/material.dart';
import 'package:salons_app_mobile/utils/app_images.dart';

class AppPromoWidget extends StatelessWidget {
  const AppPromoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, index) => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(defaultActionImage),
            ),
          ),
          title: Text('Название акции'),
          subtitle: Text('Описание акции с троеточием...'),
        ),
      ),
    );
  }
}