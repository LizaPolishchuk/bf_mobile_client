import 'package:bf_mobile_client/injection_container_app.dart';
import 'package:bf_mobile_client/prezentation/salon_details/salon_details_page.dart';
import 'package:bf_mobile_client/prezentation/salons_list/salons_bloc.dart';
import 'package:bf_mobile_client/utils/alert_builder.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_images.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/widgets/card_item_widget.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavouriteSalonsPage extends StatefulWidget {
  static const routeName = '/favourite-salons';

  const FavouriteSalonsPage({Key? key}) : super(key: key);

  @override
  _FavouriteSalonsPageState createState() => _FavouriteSalonsPageState();
}

class _FavouriteSalonsPageState extends State<FavouriteSalonsPage> {
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

    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (_refreshController.isRefresh) {
          _onRefresh();
        } else if (_refreshController.isLoading) {
          _onLoading();
        }
      }
    });

    _searchController.addListener(() {
      _loadSalonsList(_searchController.text);
    });

    _salonsBloc.errorMessage.listen((errorMsg) {
      _alertBuilder.showErrorSnackBar(context, errorMsg);
    });
  }

  void _onRefresh() async {
    _loadSalonsList(_searchController.text);
  }

  void _onLoading() async {
    if (!_salonsBloc.noMoreData) {
      _loadSalonsList(_searchController.text, nextPage: true);
    } else {
      _refreshController.loadComplete();
    }
  }

  _loadSalonsList(String searchKey, {bool nextPage = false}) async {
    var hasConnection = await ConnectivityManager.checkInternetConnection();
    if (hasConnection) {
      _salonsBloc.page = nextPage ? _salonsBloc.page + 1 : 1;
      _salonsBloc.loadFavouriteSalons(searchKey.trim());
    } else {
      _alertBuilder.showErrorSnackBar(
          context, AppLocalizations.of(context)!.noInternetConnection);
      // _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite salons"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchTextField(context, _searchController),
            marginVertical(24),
            Expanded(
              child: StreamBuilder<List<Salon>>(
                  stream: _salonsBloc.salonsLoaded,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting) {
                      var salons = snapshot.data ?? [];

                      SchedulerBinding.instance.addPostFrameCallback((_) {
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
                          String errorMsg = kDebugMode
                              ? snapshot.error.toString()
                              : AppLocalizations.of(context)!.somethingWentWrong;
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
                            return Container(
                              height: 55.0,
                              child: Center(child: body),
                            );
                          },
                        ),
                        child: salons.length > 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: salons.length,
                                itemBuilder: (context, index) {
                                  return CardItemWidget(
                                    salons[index],
                                    () {
                                      Navigator.of(context).pushNamed(
                                          SalonDetailsPage.routeName,
                                          arguments: salons[index]);
                                    },
                                    onClickStar: () {
                                      // var salonToUpdate = salons[index];
                                      // salonToUpdate.isFavourite =
                                      //     !salonToUpdate.isFavourite;
                                      // _salonsBloc.updateSalon(
                                      //     salonToUpdate, index);
                                    },
                                  );
                                },
                              )
                            : _buildEmptyList(),
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
    );
  }

  Widget _buildEmptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(emptyListPlaceholder),
        Text(
        AppLocalizations.of(context)!.nothingFound,
          style: bodyText3,
        )
      ],
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
