import 'package:bf_mobile_client/prezentation/salon_details/salon_details_page.dart';
import 'package:bf_mobile_client/prezentation/salons_list/salons_bloc.dart';
import 'package:bf_mobile_client/utils/alert_builder.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

//   var salons = [
//     Salon("","Good girl", null, null, "", "Nails studio. Cherkasy", true),
//     Salon("","Afrodita", null, null, "", "Cherkasy", true),
//     Salon("","BarberShop", null, null, "", "Barber for men", true),
//     Salon("","Anna Malinina", null, null, "", "Cherkasy", true),
//     Salon("","Diadema", null, null, "", "Cool studio", true),
//   ];

class TopSalonsWidget extends StatefulWidget {
  final SalonsBloc salonsBloc;

  const TopSalonsWidget(
    this.salonsBloc,
  );

  @override
  _TopSalonsWidgetState createState() => _TopSalonsWidgetState();
}

class _TopSalonsWidgetState extends State<TopSalonsWidget> {
  late SalonsBloc _salonsBloc;
  bool isEmptyList = false;
  AlertBuilder _alertBuilder = AlertBuilder();

  @override
  void initState() {
    super.initState();

    _salonsBloc = widget.salonsBloc;
    // _salonsBloc.add(LoadTopSalonsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Salon>>(
      stream: _salonsBloc.topSalonsLoaded,
      builder: (context, snapshot) {
        //todo add here animation to better showing

        if (snapshot.connectionState != ConnectionState.waiting) {
          if (snapshot.data != null && snapshot.data!.length > 0) {
            var salons = snapshot.data!;

            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.topSalons,
                    style: bodyText3,
                  ),
                  marginVertical(16),
                  Container(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: salons.length,
                        itemBuilder: (context, index) {
                          return _buildTopSalonItem(salons[index]);
                        },
                      )),
                ]);
          } else {
            return SizedBox.shrink();
          }
        } else {
          return SizedBox(height: 177);
        }
      },
    );
  }

  Widget _buildTopSalonItem(Salon salon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 120,
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(salon.photo ??
              "https://vjoy.cc/wp-content/uploads/2019/08/4-20.jpg"),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(SalonDetailsPage.routeName, arguments: salon);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Color(0x30000000),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                salon.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              marginVertical(8),
              Text(
                salon.description ?? "",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
