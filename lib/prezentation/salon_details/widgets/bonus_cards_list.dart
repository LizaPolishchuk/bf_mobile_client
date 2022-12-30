import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class BonusCardsList extends StatelessWidget {
  final Stream<List<BonusCard>> cardsStream;

  const BonusCardsList({Key? key, required this.cardsStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BonusCard>>(
      stream: cardsStream,
      builder: (context, snapshot) {
        var cards = snapshot.data ?? [];

        return GridView.count(
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.45,
          crossAxisCount: 2,
          children: cards.map((e) => _buildBonusCard(e)).toList(),
        );
      },
    );
  }

  Widget _buildBonusCard(BonusCard bonusCard) {
    return Container(
      // height: 60,
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(bonusCard.name, style: bodyText1.copyWith(color: Colors.white)),
          SizedBox(height: 12),
          Text("Discount: ${bonusCard.discount}", style: bodyText1.copyWith(color: Colors.white)),
        ]
      ),
    );
  }
}
