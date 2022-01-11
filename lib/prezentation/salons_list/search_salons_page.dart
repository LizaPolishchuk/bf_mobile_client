import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/salon_details/salon_details_page.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_bloc.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_event.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_state.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/events/apply_search_filters_events.dart';
import 'package:salons_app_mobile/utils/events/event_bus.dart';
import 'package:salons_app_mobile/utils/widgets/card_item_widget.dart';

class SearchSalonsPage extends StatefulWidget {
  static const routeName = '/search-salons';

  const SearchSalonsPage({Key? key}) : super(key: key);

  @override
  _SearchSalonsPageState createState() => _SearchSalonsPageState();
}

class _SearchSalonsPageState extends State<SearchSalonsPage> {
  late SalonsBloc _salonsBloc;
  final AlertBuilder _alertBuilder = AlertBuilder();
  late TextEditingController _searchController;

  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();

    _salonsBloc = getItApp<SalonsBloc>();

    _refreshController = RefreshController();
    _searchController = TextEditingController();

    _onRefresh();

    _searchController.addListener(() {
      _salonsBloc.page = 1;
      _salonsBloc.add(LoadSalonsEvent(_searchController.text));
    });

    eventBus.on<ApplySearchFiltersEvent>().listen((event) {
      _salonsBloc.page = 1;
      _salonsBloc.add(LoadSalonsEvent(_searchController.text,
          searchFilters: event.searchFilters));
    });
  }

  void _onRefresh() async {
    _salonsBloc.page = 1;
    _salonsBloc.add(LoadSalonsEvent(_searchController.text));
  }

  void _onLoading() async {
    if (!_salonsBloc.noMoreData) {
      _salonsBloc.page += 1;
      _salonsBloc.add(LoadSalonsEvent(_searchController.text));
    } else {
      _refreshController.loadComplete();
    }

    // Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _salonsBloc,
      child: BlocListener<SalonsBloc, SalonsState>(
        listener: (BuildContext context, state) {
          if (state is ErrorSalonsState) {
            _alertBuilder.showErrorDialog(context, state.failure.message);
          } else {
            _alertBuilder.stopErrorDialog(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchTextField(_searchController),
              marginVertical(24),
              Text(
                tr(AppStrings.salons),
                style: bodyText3,
              ),
              marginVertical(14),
              Expanded(
                child: StreamBuilder<List<Salon>>(
                    stream: _salonsBloc.streamSalons,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.waiting) {
                        var salons = snapshot.data ?? [];

                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                          if (_refreshController.isRefresh)
                            _refreshController.refreshCompleted();
                          if (_refreshController.isLoading) {
                            if (salons.length > 0) {
                              _refreshController.loadComplete();
                            } else {
                              _refreshController.loadNoData();
                            }
                          }

                          if (snapshot.hasError) {
                            String errorMsg = snapshot.error.toString();
                            if(errorMsg == NoInternetException.noInternetCode) {
                              errorMsg = tr(AppStrings.noInternetConnection);
                            } else {
                              errorMsg = tr(AppStrings.somethingWentWrong);
                            }
                            _alertBuilder.showErrorSnackBar(context, errorMsg);
                          }
                        });

                        return SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          footer: CustomFooter(
                            builder: (BuildContext? context, LoadStatus? mode) {
                              Widget body;
                              if (mode == LoadStatus.loading) {
                                body = CupertinoActivityIndicator();
                              } else {
                                body = SizedBox.shrink();
                              }
                              // else if (mode == LoadStatus.failed) {
                              //   body = Text("Load Failed!Click retry!");
                              // } else {
                              //   body = Text("No more Data");
                              // }
                              return Container(
                                height: 55.0,
                                child: Center(child: body),
                              );
                            },
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: salons.length > 0 ? salons.length : 1,
                            itemBuilder: (context, index) {
                              return salons.length > 0
                                  ? CardItemWidget(salons[index], () {
                                      Navigator.of(context).pushNamed(
                                          SalonDetailsPage.routeName,
                                          arguments: salons[index].id);
                                    })
                                  : _buildEmptyList();
                            },
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
                // ],
                // ),
              )
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
    _salonsBloc.dispose();
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
