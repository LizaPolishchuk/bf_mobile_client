import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/search_filters/search_filters_bloc.dart';
import 'package:salons_app_mobile/prezentation/search_filters/search_filters_event.dart';
import 'package:salons_app_mobile/prezentation/search_filters/search_filters_state.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/events/apply_search_filters_events.dart';
import 'package:salons_app_mobile/utils/events/event_bus.dart';

enum FilterType { categories, services, price }

class SearchFiltersPage extends StatefulWidget {
  final SearchFilters? searchFilters;

  const SearchFiltersPage({Key? key, this.searchFilters}) : super(key: key);

  @override
  _SearchFiltersPageState createState() => _SearchFiltersPageState();
}

class _SearchFiltersPageState extends State<SearchFiltersPage> {
  final AlertBuilder _alertBuilder = AlertBuilder();
  late SearchFiltersBloc _filtersBloc;

  late List<int> _selectedServices;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();

    _selectedServices = widget.searchFilters?.services ?? [];
    _priceRange = RangeValues(widget.searchFilters?.priceFrom?.toDouble() ?? 0,
        widget.searchFilters?.priceTo?.toDouble() ?? 5000);

    _filtersBloc = getItApp<SearchFiltersBloc>();
    _filtersBloc.add(LoadFiltersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    tr(AppStrings.filters),
                    style: titleText2.copyWith(color: greyText),
                  ),
                ),
                marginHorizontal(6),
                IconButton(
                  icon: SvgPicture.asset(icCancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              child: BlocConsumer<SearchFiltersBloc, SearchFiltersState>(
                bloc: _filtersBloc,
                listener: (_, state) {
                  if (state is ErrorFiltersState) {
                    _alertBuilder.showErrorDialog(
                        context, state.failure.message);
                  } else {
                    _alertBuilder.stopErrorDialog(context);
                  }
                },
                builder: (context, state) {
                  if (state is FiltersLoadedState) {
                    return _buildPage(state.filters);
                  }

                  return Center(child: CircularProgressIndicator.adaptive());
                },
              ),
            ),
            roundedButton(
              context,
              tr(AppStrings.apply),
              () {
                SearchFilters searchFilters = SearchFilters(
                    services: _selectedServices,
                    priceFrom: _priceRange.start.round(),
                    priceTo: _priceRange.end.round());

                eventBus.fire(ApplySearchFiltersEvent(searchFilters));

                Navigator.of(context).pop();
              },
              width: MediaQuery.of(context).size.width,
              height: 40,
            ),
            marginVertical(16),
            roundedButton(
              context,
              tr(AppStrings.cancel),
              () {
                eventBus.fire(ApplySearchFiltersEvent(null));
                Navigator.of(context).pop();
              },
              width: MediaQuery.of(context).size.width,
              height: 40,
              buttonColor: accentColor,
              textColor: grey,
            ),
            marginVertical(40),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Filters filters) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        marginVertical(24),
        Text(
          tr(AppStrings.services),
          style: appBarText,
        ),
        marginVertical(8),
        _buildMultipleSelector(filters.popularServices, FilterType.categories),
        marginVertical(24),
        Text(
          tr(AppStrings.price),
          style: appBarText,
        ),
        marginVertical(16),
        _buildPriceSelector(),
      ],
    );
  }

  Widget _buildPriceSelector() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: _buildPriceTextField(
                    "From", _priceRange.start.round().toString())),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 2,
                width: 15,
                color: primaryColor,
              ),
            ),
            Expanded(
                child: _buildPriceTextField(
                    "To",
                    _priceRange.end.round().toString() +
                        (_priceRange.end.round() == 5000 ? "+" : ""))),
          ],
        ),
        RangeSlider(
          values: _priceRange,
          max: 5000,
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPriceTextField(String label, String value) {
    return TextField(
      enabled: false,
      maxLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 8),
        labelText: label,
        hintText: "$value ${tr(AppStrings.uah)}",
        hintStyle: hintText2,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
    );
  }

  Widget _buildMultipleSelector(
      Map<int, String>? items, FilterType filterType) {
    if (items == null || items.isEmpty) {
      return SizedBox.shrink();
    }

    List<Widget> filterItems = items.entries.map((entry) {
      bool isSelected = _selectedServices.contains(entry.key);

      return _buildChip(entry.value, isSelected, () {
        isSelected = !isSelected;

        setState(() {
          if (isSelected) {
            _selectedServices.add(entry.key);
          } else {
            _selectedServices.remove(entry.key);
          }
        });
      });
    }).toList();

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: filterItems,
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onSelect) {
    return InkWell(
      onTap: onSelect,
      child: Chip(
        label: Text(
          label,
          style: bodyText6.copyWith(
              color: isSelected ? Colors.white : primaryColor),
        ),
        backgroundColor: isSelected ? primaryColor : Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: primaryColor)),
      ),
    );
  }
}
