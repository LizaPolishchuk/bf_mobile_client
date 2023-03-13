import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/choose_service/services_bloc.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

import '../../injection_container_app.dart';

class ChooseServicePage extends StatefulWidget {
  static const routeName = '/choose-service';

  final String salonId;
  final String categoryId;
  final Service? chosenService;

  const ChooseServicePage(this.salonId, this.categoryId, this.chosenService);

  @override
  _ChooseServicePageState createState() => _ChooseServicePageState();
}

class _ChooseServicePageState extends State<ChooseServicePage> {
  late ServicesBloc _serviceBloc;
  final AlertBuilder _alertBuilder = AlertBuilder();

  late RefreshController _refreshController;
  Service? _chosenService;

  @override
  void initState() {
    super.initState();

    _serviceBloc = getItApp<ServicesBloc>();
    _serviceBloc.errorMessage.listen((error) {
      _alertBuilder.showErrorSnackBar(context, error);
    });

    _chosenService = widget.chosenService;

    _refreshController = RefreshController();

    _onRefresh();
  }

  void _onRefresh() async {
    _serviceBloc.getServices(widget.salonId, widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: SvgPicture.asset(
              icArrowLeftWithShadow,
              color: darkGreyText,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<List<Service>>(
                  stream: _serviceBloc.servicesLoaded,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
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
                          itemCount: services.length > 0 ? services.length : 1,
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
              child: roundedButton(
                context,
                AppLocalizations.of(context)!.next,
                () {
                  Navigator.of(context).pop(_chosenService);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                "${AppLocalizations.of(context)!.from} ${service.price?.toStringAsFixed(0) ?? 0} ${AppLocalizations.of(context)!.uah}",
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
}
