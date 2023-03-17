import 'package:bf_mobile_client/utils/widgets/card_item_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

class PromosList extends StatelessWidget {
  final Stream<List<Promo>> promosStream;

  const PromosList({Key? key, required this.promosStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Promo>>(
      stream: promosStream,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            return CardItemWidget(
              snapshot.data![index],
              () {},
              smallSize: true,
            );
          },
        );
      },
    );
  }
}
