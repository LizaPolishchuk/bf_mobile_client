import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_bloc.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_event.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_bloc.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_event.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_state.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';

enum ContentTab { INFO, PROMO, BONUSES }

class SalonDetailsPage extends StatefulWidget {
  static const routeName = '/salon-details';

  final String salonId;

  const SalonDetailsPage(this.salonId);

  @override
  _SalonDetailsPageState createState() => _SalonDetailsPageState();
}

class _SalonDetailsPageState extends State<SalonDetailsPage> {
  ContentTab _selectedTab = ContentTab.INFO;

  late SalonDetailsBloc _salonDetailsBloc;

  AlertBuilder _alertBuilder = AlertBuilder();

  @override
  void initState() {
    super.initState();

    _salonDetailsBloc = getItApp<SalonDetailsBloc>();
    _salonDetailsBloc.add(LoadSalonByIdEvent(widget.salonId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SalonDetailsBloc, SalonDetailsState>(
          bloc: _salonDetailsBloc,
          listener: (BuildContext _, state) {
            if (state is LoadingSalonDetailsState) {
              _alertBuilder.showLoaderDialog(context);
            } else {
              _alertBuilder.stopLoaderDialog(context);
            }

            if (state is ErrorSalonDetailsState) {
              _alertBuilder.showErrorDialog(context, state.failure.message);
            } else {
              _alertBuilder.stopErrorDialog(context);
            }
          },
          builder: (BuildContext context, SalonDetailsState state) {
            if (state is SalonDetailsLoadedState) {
              return _buildSalonDetails(state.salon);
            }
            return SizedBox.shrink();
          }),
    );
  }

  Widget _buildSalonDetails(Salon salon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          salon.photoPath ??
              "https://vjoy.cc/wp-content/uploads/2019/08/4-20.jpg",
          fit: BoxFit.fill,
          height: 280,
          width: MediaQuery.of(context).size.width,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salon.name,
                  style: titleText2.copyWith(color: primaryColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Short description",
                  style: hintText2.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                marginVertical(4),
                GestureDetector(
                  onTap: (){
                    //todo here is hardcode
                      openMap(49.4457819, 32.0564462);
                  },
                  child: Text(
                    "Хрещатик, 14 оф. 3",
                    style: hintText1.copyWith(
                      fontWeight: FontWeight.w300,
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                marginVertical(12),
                Container(
                  constraints: const BoxConstraints(maxHeight: 35),
                  child: ListView(
                    children: [
                      _buildTabItem(tr(AppStrings.aboutUs), ContentTab.INFO),
                      _buildTabItem(tr(AppStrings.promo), ContentTab.PROMO),
                      _buildTabItem(tr(AppStrings.bonuses), ContentTab.BONUSES),
                    ],
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                marginVertical(22),
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: _buildTabContent(salon),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          child: buttonWithText(
            context,
            tr(AppStrings.signUp),
            () {
              NavBloc navBloc = getItApp<NavBloc>();
              navBloc.add(NavChooseCategoryPage([salon]));
            },
            width: 255,
            height: 40,
          ),
          alignment: Alignment.center,
        ),
        marginVertical(12),
      ],
    );
  }

  Widget _buildTabContent(Salon salon) {
    switch (_selectedTab) {
      case ContentTab.INFO:
        return Text(
          salon.description ?? "",
          style: hintText2.copyWith(color: Colors.black),
        );
      case ContentTab.PROMO:
        return Text("Promos");
      case ContentTab.BONUSES:
        return Text("Bonuses");
    }
  }

  Widget _buildTabItem(String text, ContentTab contentTab) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = contentTab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        margin: const EdgeInsets.only(right: 5),
        constraints: const BoxConstraints(minWidth: 96),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: primaryColor,
          ),
        ),
        child: Text(
          text,
          style: contentTab == _selectedTab
              ? bodyText4.copyWith(color: primaryColor)
              : hintText2,
        ),
      ),
    );
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
