import 'package:flutter/material.dart';

class TopSalonsCarouselWidget extends StatelessWidget {
  const TopSalonsCarouselWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              width: 280,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  //TODO: Заменить на svg
                  image: AssetImage('assets/images/TopSalonCard.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
