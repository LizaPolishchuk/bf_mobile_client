import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/categories/categories_bloc.dart';
import 'package:salons_app_mobile/prezentation/categories/categories_event.dart';
import 'package:salons_app_mobile/prezentation/categories/categories_state.dart';
import 'package:salons_app_mobile/prezentation/create_order/create_order_page.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
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

    _searchController.addListener(() {
      _categoriesBloc.add(SearchCategoriesEvent(_searchController.text));
    });
  }

  void _onRefresh() async {
    if (_searchController.text.isEmpty) {
      _categoriesBloc.add(LoadCategoriesListEvent(salon.id));
    } else {
      _categoriesBloc.add(SearchCategoriesEvent(_searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoriesBloc,
      child: BlocListener<CategoriesBloc, CategoriesState>(
        listener: (BuildContext context, state) {},
        child: Scaffold(
          bottomNavigationBar: null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 280,
                width: MediaQuery.of(context).size.width,
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
                            stream: _categoriesBloc.streamCategories,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.waiting) {
                                SchedulerBinding.instance
                                    ?.addPostFrameCallback((_) {
                                  if (_refreshController.isRefresh)
                                    _refreshController.refreshCompleted();
                                });

                                var categories = snapshot.data ?? [];
                                return SmartRefresher(
                                  enablePullDown: true,
                                  controller: _refreshController,
                                  onRefresh: _onRefresh,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: categories.length > 0
                                        ? categories.length
                                        : 1,
                                    itemBuilder: (context, index) {
                                      return categories.length > 0
                                          ? CardItemWidget(
                                              categories[index],
                                              () => Navigator.of(context)
                                                  .pushNamed(
                                                      CreateOrderPage.routeName,
                                                      arguments: [
                                                    widget.salon,
                                                    categories[index].id
                                                  ]),
                                            )
                                          : _buildEmptyList();
                                    },
                                  ),
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
        ),
      ),
    );
  }

  Widget _buildEmptyList() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      alignment: Alignment.center,
      child: Text("Empty list"),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoriesBloc.dispose();
    super.dispose();
  }
}
