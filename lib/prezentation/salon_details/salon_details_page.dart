import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/categories/choose_category_page.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_bloc.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/widgets/app_bonus_widget.dart';
import 'package:salons_app_mobile/utils/widgets/app_making_appointment_button.dart';
import 'package:salons_app_mobile/utils/widgets/app_promo_widget.dart';
import 'package:url_launcher/url_launcher.dart';

enum ContentTab { INFO, PROMO, BONUSES }

class SalonDetailsPage extends StatefulWidget {
  static const routeName = '/salon-details';

  final Salon salon;

  const SalonDetailsPage(this.salon);

  @override
  _SalonDetailsPageState createState() => _SalonDetailsPageState();
}

class _SalonDetailsPageState extends State<SalonDetailsPage> {
  ContentTab _selectedTab = ContentTab.INFO;

  late SalonDetailsBloc _salonDetailsBloc;

  AlertBuilder _alertBuilder = AlertBuilder();

  Color _iconFaforiteColor = grey;

  @override
  void initState() {
    super.initState();

    _salonDetailsBloc = getItApp<SalonDetailsBloc>();
    _loadSalonDetails();

    _salonDetailsBloc.errorMessage.listen((errorMsg) {
      _alertBuilder.showErrorSnackBar(context, errorMsg);
    });

    _salonDetailsBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        _alertBuilder.showLoaderDialog(context);
      } else {
        _alertBuilder.stopLoaderDialog(context);
      }
    });
  }

  _loadSalonDetails() async {
    var hasConnection = await ConnectivityManager.checkInternetConnection();
    if (hasConnection) {
      _salonDetailsBloc.loadSalonById(widget.salon.id);
    } else {
      _alertBuilder.showErrorSnackBar(
          context, tr(AppStrings.noInternetConnection));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<Salon>(
      stream: _salonDetailsBloc.salonLoaded,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return _buildSalonDetails(snapshot.data!);
        }
        return _buildSalonDetails(widget.salon);
      },
    ));
  }

  Widget _buildSalonDetails(Salon salon) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.network(
          salon.photoPath ??
              "https://vjoy.cc/wp-content/uploads/2019/08/4-20.jpg",
          fit: BoxFit.fill,
          height: 280,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: SvgPicture.asset(icArrowLeftWithShadow)),
          top: MediaQuery.of(context).padding.top + 10,
        ),
        Positioned(
          top: 250,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height,
          child: Container(
            padding: EdgeInsets.only(top: 17, left: 17, right: 17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                      ],
                    ),
                    SvgPicture.asset(icBagIcon),
                  ],
                ),
                marginVertical(4),
                GestureDetector(
                  onTap: () {
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
        Positioned(
          child: Align(
            alignment: Alignment(0.0, 0.9),
            child: AppMakingAppointmentButton(
              makingAppontmentPressed: () async {
                var hasConnection =
                    await ConnectivityManager.checkInternetConnection();
                if (hasConnection) {
                  Navigator.of(context).pushNamed(ChooseCategoryPage.routeName,
                      arguments: salon);
                } else {
                  _alertBuilder.showErrorSnackBar(
                      context, tr(AppStrings.noInternetConnection));
                }
              },
              favoritePressed: () {
                setState(() {
                  if (_iconFaforiteColor == grey) {
                    _iconFaforiteColor = primaryColor;
                  } else {
                    _iconFaforiteColor = grey;
                  }
                });
              },
              iconFaforiteColor: _iconFaforiteColor,
            ),
          ),
        ),
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
        return AppPromoWidget();
      case ContentTab.BONUSES:
        return AppBonusWidget();
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
    Uri _googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(_googleUrl)) {
      await launchUrl(_googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
