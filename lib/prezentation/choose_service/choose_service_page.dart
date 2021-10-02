import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/choose_service/services_bloc.dart';
import 'package:salons_app_mobile/prezentation/choose_service/services_event.dart';
import 'package:salons_app_mobile/prezentation/choose_service/services_state.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

import '../../injection_container_app.dart';

class ChooseServicePage extends StatefulWidget {
  static const routeName = '/choose-service';

  final Salon salon;
  final String categoryId;

  const ChooseServicePage(this.salon, this.categoryId);

  @override
  _ChooseServicePageState createState() => _ChooseServicePageState();
}

class _ChooseServicePageState extends State<ChooseServicePage> {
  late Salon salon;

  late ServicesBloc _serviceBloc;
  final AlertBuilder _alertBuilder = AlertBuilder();

  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();

    salon = widget.salon;

    _serviceBloc = getItApp<ServicesBloc>();

    _refreshController = RefreshController();

    _onRefresh();
  }

  void _onRefresh() async {
    _serviceBloc.add(LoadServicesListEvent(salon.id, widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _serviceBloc,
      child: BlocListener<ServicesBloc, ServicesState>(
        listener: (BuildContext context, state) {},
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder<List<Service>>(
                      stream: _serviceBloc.streamServices,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState !=
                            ConnectionState.waiting) {
                          SchedulerBinding.instance?.addPostFrameCallback((_) {
                            if (_refreshController.isRefresh)
                              _refreshController.refreshCompleted();
                          });

                          var services = snapshot.data ?? [];
                          return SmartRefresher(
                            enablePullDown: true,
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return services.length > 0
                                    ? _buildServiceItem(services[index])
                                    : _buildEmptyList();
                              },
                              itemCount:
                                  services.length > 0 ? services.length : 1,
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: buttonWithText(context, tr(AppStrings.next), () {
                     Navigator.of(context).pop(_chosenService);
                  }, width: 255,
                    height: 40,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Service? _chosenService;

  Widget _buildServiceItem(Service service) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: blurColor, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
          child: Row(
            children: [
              SvgPicture.asset(_chosenService == service
                  ? icCheckBoxSelected
                  : icCheckBoxUnselected),
              marginHorizontal(8),
              Expanded(
                  child: Text(
                service.name,
                style: hintText2,
                overflow: TextOverflow.ellipsis,
              )),
              marginHorizontal(6),
              Text(
                "${tr(AppStrings.from)} ${service.price?.toStringAsFixed(0) ?? 0} ${tr(AppStrings.uah)}",
                style: hintText2.copyWith(color: Colors.black),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _chosenService = service;
            });
          }),
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
    _serviceBloc.dispose();
    super.dispose();
  }
}
