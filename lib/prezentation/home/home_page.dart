import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/empty_list_image.dart';
import 'package:intl/intl.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
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
    ),
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
    ),
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
    ),
  ];
  List<OrderEntity> pinnedOrders = [];
  late bool pinned;

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
          ),
          if (pinnedOrders.isNotEmpty)
            Container(
              height: 110 * pinnedOrders.length.toDouble(),
              child: ListView.builder(
                itemCount: pinnedOrders.length,
                itemBuilder: (context, index) {
                  return OrdersTileWidget(
                    isPinned: true,
                    serviceName: pinnedOrders[index].serviceName,
                    salonName: pinnedOrders[index].salonName,
                    orderDate:
                        DateFormat('EE dd-MM-yyyy').format(DateTime.now()),
                    masterImage: 'assets/images/MasterImage.png',
                    masterName: pinnedOrders[index].masterName,
                    orderPrice: '300',
                    onTap: () {
                      setState(() {
                        orders.add(pinnedOrders[index]);
                        pinnedOrders.removeAt(index);
                      });
                    },
                    onPressed: () {
                      setState(() {
                        orders.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              ),
            ),
          Container(
            height: 110 * orders.length.toDouble(),
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrdersTileWidget(
                  isPinned: false,
                  serviceName: orders[index].serviceName,
                  salonName: orders[index].salonName,
                  orderDate: DateFormat('EE dd-MM-yyyy').format(DateTime.now()),
                  masterImage: 'assets/images/MasterImage.png',
                  masterName: orders[index].masterName,
                  orderPrice: '300',
                  onTap: () {
                    setState(() {
                      pinnedOrders.add(orders[index]);
                      orders.removeAt(index);
                      pinned = true;
                    });
                  },
                  onPressed: () {
                    setState(() {
                      orders.removeAt(index);
                      Navigator.pop(context);
                    });
                  },
                );
              },
            ),
          ),
          // EmptyListImageWidget(),
        ],
            // marginVertical(16),
            // OrdersTileWidget(
            //   orderText: 'Маникюр в Example Salon',
            //   orderDate: 'Вт. 23 мая',
            //   masterImage: 'assets/images/MasterImage.png',
            //   masterName: 'Olha',
            //   orderPrice: '300',
            // ),
            // EmptyListImageWidget(),
          // ],
        ),
      ),
    );
  }
}
