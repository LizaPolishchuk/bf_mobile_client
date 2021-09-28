import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
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
                    widget.salon.name,
                    style: titleText2.copyWith(color: primaryColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Short description",
                    style: hintText2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  marginVertical(12),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 33),
                    child: ListView(
                      children: [
                        _buildTabItem(tr(AppStrings.aboutUs), ContentTab.INFO),
                        _buildTabItem(tr(AppStrings.promo), ContentTab.PROMO),
                        _buildTabItem(
                            tr(AppStrings.bonuses), ContentTab.BONUSES),
                      ],
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  marginVertical(22),
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      child: _buildTabContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            child: buttonWithText(context, tr(AppStrings.signUp), () {},
                width: 255, height: 40),
            alignment: Alignment.center,
          ),
          marginVertical(12),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case ContentTab.INFO:
        return Text(
          widget.salon.description ?? "",
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
}
