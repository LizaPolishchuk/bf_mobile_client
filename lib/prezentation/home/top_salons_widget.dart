import 'package:flutter/material.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_bloc.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_event.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';


//   var salons = [
//     Salon("","Good girl", null, null, "", "Nails studio. Cherkasy", true),
//     Salon("","Afrodita", null, null, "", "Cherkasy", true),
//     Salon("","BarberShop", null, null, "", "Barber for men", true),
//     Salon("","Anna Malinina", null, null, "", "Cherkasy", true),
//     Salon("","Diadema", null, null, "", "Cool studio", true),
//   ];

class TopSalonsWidget extends StatefulWidget {
  const TopSalonsWidget({
    Key? key,
  }) : super(key: key);

  @override
  _TopSalonsWidgetState createState() => _TopSalonsWidgetState();
}

class _TopSalonsWidgetState extends State<TopSalonsWidget> {
  late SalonsBloc _salonsBloc;

  @override
  void initState() {
    super.initState();

    _salonsBloc = getItApp<SalonsBloc>();
    _salonsBloc.add(LoadTopSalonsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(AppStrings.topSalons),
          style: bodyText3,
        ),
        marginVertical(16),
        Container(
          height: 140,
          child: StreamBuilder<List<Salon>>(
            stream: _salonsBloc.streamSalons,
            builder: (context, snapshot) {

              if (snapshot.data != null && snapshot.data!.length > 0) {
                var salons = snapshot.data!;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: salons.length,
                  itemBuilder: (context, index) {
                    return _buildTopSalonItem(salons[index]);
                  },
                );
              } else {
                return Text("empty");
              }
            },
          ),
        ),
      ],
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
          image: NetworkImage(salon.photoPath ?? "https://vjoy.cc/wp-content/uploads/2019/08/4-20.jpg"),
        ),
      ),
      child: InkWell(
        onTap: () {
          //todo open salon details page
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
