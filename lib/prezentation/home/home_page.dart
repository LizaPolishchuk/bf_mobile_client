import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salons_app_mobile/prezentation/home/empty_list_image.dart';
import 'package:salons_app_mobile/prezentation/home/orders_tile_widget.dart';
import 'package:salons_app_mobile/prezentation/home/top_salons_carousel_widget.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: Colors.black),
        ),
        title: Text(
          'Salons App',
          style: text16W600.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Топ салонов',
                style: text16W600,
              ),
            ),
          ),
          TopSalonsCarouselWidget(),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ближайшие записи', style: text16W600),
                TextButton(
                  onPressed: () {},
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
          OrdersTileWidget(
            orderText: 'Маникюр в Example Salon',
            orderDate: 'Вт. 23 мая',
            masterImage: 'assets/images/MasterImage.png',
            masterName: 'Olha',
            orderPrice: '300',
          ),
          EmptyListImageWidget(),
        ],
      ),
    );
  }
}


