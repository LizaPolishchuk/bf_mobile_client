// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:bf_network_module/bf_network_module.dart';
// import 'package:bf_mobile_client/injection_container_app.dart';
// import 'package:bf_mobile_client/prezentation/search_filters/search_filters_bloc.dart';
// import 'package:bf_mobile_client/utils/alert_builder.dart';
// import 'package:bf_mobile_client/utils/app_colors.dart';
// import 'package:bf_mobile_client/utils/app_components.dart';
// import 'package:bf_mobile_client/utils/app_images.dart';
// import 'package:bf_mobile_client/utils/app_styles.dart';
// import 'package:bf_mobile_client/utils/events/apply_search_filters_events.dart';
// import 'package:bf_mobile_client/utils/events/event_bus.dart';
//
// enum FilterType { categories, services, price }
//
// class SearchFiltersPage extends StatefulWidget {
//   final SearchFilters? searchFilters;
//
//   const SearchFiltersPage({Key? key, this.searchFilters}) : super(key: key);
//
//   @override
//   _SearchFiltersPageState createState() => _SearchFiltersPageState();
// }
//
// class _SearchFiltersPageState extends State<SearchFiltersPage> {
//   final AlertBuilder _alertBuilder = AlertBuilder();
//   late SearchFiltersBloc _filtersBloc;
//
//   late List<int> _selectedServices;
//   late RangeValues _priceRange;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _selectedServices = widget.searchFilters?.services ?? [];
//     _priceRange = RangeValues(widget.searchFilters?.priceFrom?.toDouble() ?? 0,
//         widget.searchFilters?.priceTo?.toDouble() ?? 5000);
//
//     _filtersBloc = getItApp<SearchFiltersBloc>();
//     _filtersBloc.loadSearchFilters();
//
//     _filtersBloc.errorMessage.listen((errorMsg) {
//       _alertBuilder.showErrorSnackBar(context, errorMsg);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Flexible(
//                   fit: FlexFit.tight,
//                   child: Text(
//                       AppLocalizations.of(context)!.filters,
//                     style: titleText2.copyWith(color: greyText),
//                   ),
//                 ),
//                 marginHorizontal(6),
//                 IconButton(
//                   icon: SvgPicture.asset(icCancel),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ],
//             ),
//             Flexible(
//               fit: FlexFit.tight,
//               child: StreamBuilder<Filters>(
//                 stream: _filtersBloc.filtersLoaded,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator.adaptive());
//                   } else if (snapshot.data != null) {
//                     return _buildPage(snapshot.data!);
//                   } else {
//                     return SizedBox.shrink();
//                   }
//                 },
//               ),
//             ),
//             roundedButton(
//               context,
//                 AppLocalizations.of(context)!.apply,
//               () {
//                 SearchFilters searchFilters = SearchFilters(
//                     services: _selectedServices,
//                     priceFrom: _priceRange.start.round(),
//                     priceTo: _priceRange.end.round());
//
//                 eventBus.fire(ApplySearchFiltersEvent(searchFilters));
//
//                 Navigator.of(context).pop();
//               },
//               width: MediaQuery.of(context).size.width,
//               height: 40,
//             ),
//             marginVertical(16),
//             roundedButton(
//               context,
//                 AppLocalizations.of(context)!.cancel,
//               () {
//                 eventBus.fire(ApplySearchFiltersEvent(null));
//                 Navigator.of(context).pop();
//               },
//               width: MediaQuery.of(context).size.width,
//               height: 40,
//               buttonColor: accentColor,
//               textColor: grey,
//             ),
//             marginVertical(40),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPage(Filters filters) {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         marginVertical(24),
//         Text(
//         AppLocalizations.of(context)!.services,
//           style: appBarText,
//         ),
//         marginVertical(8),
//         _buildMultipleSelector(filters.popularServices, FilterType.categories),
//         marginVertical(24),
//         Text(
//     AppLocalizations.of(context)!.price,
//           style: appBarText,
//         ),
//         marginVertical(16),
//         _buildPriceSelector(),
//       ],
//     );
//   }
//
//   Widget _buildPriceSelector() {
//     return Column(
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Expanded(
//                 child: _buildPriceTextField(
//                     "From", _priceRange.start.round().toString())),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Container(
//                 height: 2,
//                 width: 15,
//                 color: primaryColor,
//               ),
//             ),
//             Expanded(
//                 child: _buildPriceTextField(
//                     "To",
//                     _priceRange.end.round().toString() +
//                         (_priceRange.end.round() == 5000 ? "+" : ""))),
//           ],
//         ),
//         RangeSlider(
//           values: _priceRange,
//           max: 5000,
//           onChanged: (RangeValues values) {
//             setState(() {
//               _priceRange = values;
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPriceTextField(String label, String value) {
//     return TextField(
//       enabled: false,
//       maxLines: 1,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.only(left: 8),
//         labelText: label,
//         hintText: "$value ${AppLocalizations.of(context)!.uah}",
//         hintStyle: hintText2,
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         disabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.black, width: 0.2),
//           borderRadius: BorderRadius.all(Radius.circular(50)),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMultipleSelector(
//       Map<int, String>? items, FilterType filterType) {
//     if (items == null || items.isEmpty) {
//       return SizedBox.shrink();
//     }
//
//     List<Widget> filterItems = items.entries.map((entry) {
//       bool isSelected = _selectedServices.contains(entry.key);
//
//       return _buildChip(entry.value, isSelected, () {
//         isSelected = !isSelected;
//
//         setState(() {
//           if (isSelected) {
//             _selectedServices.add(entry.key);
//           } else {
//             _selectedServices.remove(entry.key);
//           }
//         });
//       });
//     }).toList();
//
//     return Wrap(
//       spacing: 6.0,
//       runSpacing: 6.0,
//       children: filterItems,
//     );
//   }
//
//   Widget _buildChip(String label, bool isSelected, VoidCallback onSelect) {
//     return InkWell(
//       onTap: onSelect,
//       child: Chip(
//         label: Text(
//           label,
//           style: bodyText6.copyWith(
//               color: isSelected ? Colors.white : primaryColor),
//         ),
//         backgroundColor: isSelected ? primaryColor : Colors.transparent,
//         shape: StadiumBorder(side: BorderSide(color: primaryColor)),
//       ),
//     );
//   }
// }
