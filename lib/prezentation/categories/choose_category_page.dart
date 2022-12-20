import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/categories/categories_bloc.dart';
import 'package:salons_app_mobile/prezentation/create_order/create_order_page.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/widgets/card_item_widget.dart';

import '../../injection_container_app.dart';

class ChooseCategoryPage extends StatefulWidget {
  static const routeName = '/choose-category';

  final Salon salon;

  const ChooseCategoryPage(this.salon);

  @override
  _ChooseCategoryPageState createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  late Salon salon;

  late CategoriesBloc _categoriesBloc;

  final AlertBuilder _alertBuilder = AlertBuilder();
  late TextEditingController _searchController;

  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();

    salon = widget.salon;

    _categoriesBloc = getItApp<CategoriesBloc>();

    _refreshController = RefreshController();
    _searchController = TextEditingController();

    _onRefresh();

    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (_refreshController.isRefresh) {
          _onRefresh();
        }
      }
    });

    _searchController.addListener(() async {
      var hasConnection = await ConnectivityManager.checkInternetConnection();
      if (hasConnection) {
        _categoriesBloc.searchCategories(_searchController.text);
      } else {
        _alertBuilder.showErrorSnackBar(
            context, tr(AppStrings.noInternetConnection));
      }
    });
  }

  void _onRefresh() async {
    var hasConnection = await ConnectivityManager.checkInternetConnection();
    if (hasConnection) {
      if (_searchController.text.isEmpty) {
        _categoriesBloc.getCategories(salon.id);
      } else {
        _categoriesBloc.searchCategories(_searchController.text);
      }
    } else {
      _alertBuilder.showErrorSnackBar(
          context, tr(AppStrings.noInternetConnection));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: null,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.salon.photoPath ??
                        "https://vjoy.cc/wp-content/uploads/2019/08/4-20.jpg"),
                  ),
                ),
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0x50000000),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        salon.name,
                        style: titleText2.copyWith(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Short description",
                        style: bodyText2.copyWith(
                            color: Colors.white, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      marginVertical(12),
                      searchTextField(_searchController,
                          hintText: tr(AppStrings.searchService),
                          topAndBottomPadding: 8),
                    ],
                  ),
                ),
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
                        tr(AppStrings.chooseCategory),
                        style: titleText2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      marginVertical(16),
                      Flexible(
                        fit: FlexFit.loose,
                        child: StreamBuilder<List<Category>>(
                            stream: _categoriesBloc.categoriesLoaded,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.waiting) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (_refreshController.isRefresh)
                                    _refreshController.refreshCompleted();

                                  if (snapshot.hasError) {
                                    String errorMsg = snapshot.error.toString();
                                    if (errorMsg ==
                                        NoInternetException.noInternetCode) {
                                      errorMsg =
                                          tr(AppStrings.noInternetConnection);
                                    } else {
                                      errorMsg =
                                          tr(AppStrings.somethingWentWrong);
                                    }
                                    _alertBuilder.showErrorSnackBar(
                                        context, errorMsg);
                                  }
                                });

                                var categories = snapshot.data ?? [];
                                return SmartRefresher(
                                  enablePullDown: true,
                                  controller: _refreshController,
                                  onRefresh: _onRefresh,
                                  child: categories.length > 0
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: categories.length,
                                          itemBuilder: (context, index) {
                                            return CardItemWidget(
                                              categories[index],
                                              () => Navigator.of(context)
                                                  .pushNamed(
                                                      CreateOrderPage.routeName,
                                                      arguments: [
                                                    widget.salon,
                                                    categories[index].id
                                                  ]),
                                            );
                                          },
                                        )
                                      : _buildEmptyList(),
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                        // ],
                        // ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: SvgPicture.asset(icArrowLeftWithShadow)),
            top: MediaQuery.of(context).padding.top + 10,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(emptyListPlaceholder),
        Text(
          tr(AppStrings.nothingFound),
          style: bodyText3,
        )
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
