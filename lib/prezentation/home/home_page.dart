import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/orders_tile_widget.dart';
import 'package:salons_app_mobile/prezentation/home/top_salons_carousel_widget.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<OrderEntity> orders = [
    OrderEntity(
        'id',
        'clientId',
        'clientName',
        'salonId',
        'Example Salon',
        'masterId',
        'Olha',
        'masterAvatar',
        'serviceId',
        'Маникюр',
        DateTime.now(),
        300,
        false),
    OrderEntity(
        'id2',
        'clientId',
        'clientName',
        'salonId',
        'Salon 2',
        'masterId',
        'Liza',
        'masterAvatar',
        'serviceId',
        'Стрижка',
        DateTime.now(),
        200,
        false),
    OrderEntity(
        'id3',
        'clientId',
        'clientName',
        'salonId',
        'Salon 3',
        'masterId',
        'Sofia',
        'masterAvatar',
        'serviceId',
        'Ресницы',
        DateTime.now(),
        100,
        true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: Colors.black),
        ),
        title: Text(
          tr(AppStrings.appName),
          style: text16W600.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(AppStrings.topSalons),
              style: text16W600,
            ),
            TopSalonsCarouselWidget(),
            marginVertical(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ближайшие записи', style: text16W600),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'Все',
                        style: text12W500.copyWith(color: Color(0xff6B7280)),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 18,
                        color: Color(0xff6B7280),
                      )
                    ],
                  ),
                ),
              ],
            ),
            marginVertical(16),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrdersTileWidget(
                    order: orders[index],
                    onPressedPin: (order) {
                      setState(() {
                        order.isPinned = !order.isPinned;
                        orders[index] = order;
                        
                        // orders.removeAt(index);
                      });
                    },
                    onPressedRemove: (order) {
                      setState(() {
                        // orders.removeAt(index);
                        // Navigator.pop(context);
                      });
                    },
                  );
                },
              ),
            ),
            // EmptyListImageWidget(),
          ],
        ),
      ),
    );
  }
}
