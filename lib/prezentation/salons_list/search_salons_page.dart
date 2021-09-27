import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_bloc.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_event.dart';
import 'package:salons_app_mobile/prezentation/salons_list/salons_state.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

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

    _onRefresh();

    _refreshController = RefreshController();
    _searchController = TextEditingController();
  }

  void _onRefresh() async {
    _salonsBloc.add(LoadSalonsEvent(""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _salonsBloc,
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
                        SchedulerBinding.instance?.addPostFrameCallback((_) {
                          if (_refreshController.isRefresh)
                            _refreshController.refreshCompleted();
                        });

                        var salons = snapshot.data ?? [];
                        return SmartRefresher(
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                // salons.length > 0 ? salons.length :
                                1,
                            itemBuilder: (context, index) {
                              return
                                  // salons.length > 0
                                  //   ? CardItemWidget(salons[index], () {})
                                  //   :
                                  _buildEmptyList();
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
}
