import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/prezentation/categories/choose_category_page.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_bloc.dart';
import 'package:salons_app_mobile/prezentation/salon_details/widgets/bonus_cards_list.dart';
import 'package:salons_app_mobile/prezentation/salon_details/widgets/promos_list.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/widgets/debounced_button.dart';
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
          context, AppLocalizations.of(context)!.noInternetConnection);
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
      children: [
        Column(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
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
                          _buildTabItem(AppLocalizations.of(context)!.aboutUs,
                              ContentTab.INFO),
                          _buildTabItem(AppLocalizations.of(context)!.promo,
                              ContentTab.PROMO),
                          _buildTabItem(AppLocalizations.of(context)!.bonuses,
                              ContentTab.BONUSES),
                        ],
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: _buildTabContent(salon),
                    ),
                  ],
                ),
              ),
            ),
            _buildButtons(salon),
            marginVertical(12),
          ],
        ),
        Positioned(
          child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: SvgPicture.asset(icArrowLeftWithShadow)),
          top: MediaQuery.of(context).padding.top + 10,
        ),
      ],
    );
  }

  Widget _buildButtons(Salon salon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: roundedButton(
              context,
              AppLocalizations.of(context)!.signUp,
              () async {
                Navigator.of(context)
                    .pushNamed(ChooseCategoryPage.routeName, arguments: salon);
              },
              width: double.infinity,
              padding: 0,
            ),
          ),
          marginHorizontal(8),
          DebouncedButton(
            onPressed: () {
              print("onPressed");

              // salon.isFavourite = !salon.isFavourite;
              // _salonDetailsBloc.updateSalon(salon);
            },
            child: Container(
              height: 50,
              width: 82,
              decoration: BoxDecoration(
                  color: Color(0xffBBB8B8).withAlpha(50),
                  borderRadius: BorderRadius.circular(25)),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                  salon.isFavourite ? icStarChecked : icStarUnchecked),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabContent(Salon salon) {
    switch (_selectedTab) {
      case ContentTab.INFO:
        return SingleChildScrollView(
          child: Text(
            salon.description ?? "",
            style: hintText2.copyWith(color: Colors.black),
          ),
        );
      case ContentTab.PROMO:
        return PromosList(promosStream: _salonDetailsBloc.promosLoaded);
      case ContentTab.BONUSES:
        return BonusCardsList(cardsStream: _salonDetailsBloc.bonusCardsLoaded);
    }
  }

  Widget _buildTabItem(String text, ContentTab contentTab) {
    return InkWell(
      onTap: () {
        if (contentTab == ContentTab.PROMO) {
          _salonDetailsBloc.loadPromos(widget.salon.id);
        } else if (contentTab == ContentTab.BONUSES) {
          _salonDetailsBloc.loadBonusCards(widget.salon.id);
        }
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
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
