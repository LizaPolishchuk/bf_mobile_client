import 'dart:async';

import 'package:bf_mobile_client/event_bus_events/go_to_search_salons_event.dart';
import 'package:bf_mobile_client/injection_container_app.dart';
import 'package:bf_mobile_client/prezentation/appoinments_history/orders_history_page.dart';
import 'package:bf_mobile_client/prezentation/home/home_page.dart';
import 'package:bf_mobile_client/prezentation/individual_appointments/create_individual_appointment_page.dart';
import 'package:bf_mobile_client/prezentation/login/login_bloc.dart';
import 'package:bf_mobile_client/prezentation/profile/settings_page.dart';
import 'package:bf_mobile_client/prezentation/salons_list/favourite_salons_page.dart';
import 'package:bf_mobile_client/prezentation/salons_list/search_salons_page.dart';
import 'package:bf_mobile_client/utils/alert_builder.dart';
import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_images.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/events/apply_search_filters_events.dart';
import 'package:bf_mobile_client/utils/events/event_bus.dart';
import 'package:bf_mobile_client/utils/master_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

enum TabItem { home, search, notifications }

enum DrawerItem { history, favourites, promo, bonusCards, settings, exit }

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  TabItem _currentTab = TabItem.home;
  DrawerItem? _currentDrawerItem;

  // ValueNotifier<bool> _isMasterModeNotifier = ValueNotifier<bool>(false);
  // late LocalStorage _localStorage;

  final List _children = [
    const HomePage(),
    const SearchSalonsPage(),
    // const NotificationsPage()
  ];

  late LoginBloc _loginBloc;
  late UserEntity _currentUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AlertBuilder _alertBuilder = AlertBuilder();

  // SearchFilters? _searchFilters;

  @override
  void initState() {
    super.initState();

    _currentUser = getIt<LocalStorage>().getCurrentUser();

    print("_currentUser : $_currentUser");

    _loginBloc = getItApp<LoginBloc>();

    eventBus.on<GoToSearchSalonsEvent>().listen((event) {
      setState(() => _currentTab = TabItem.search);
    });

    eventBus.on<ApplySearchFiltersEvent>().listen((event) {
      print("catch in home container : ${event.searchFilters?.priceFrom}");
      // setState(() {
      //   _searchFilters = event.searchFilters;
      // });
    });
  }

  /// Created to be called from navBloc for the ability to switch tabs from outside
  void changeActiveTab(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isLastRouteInCurrentTab = !Navigator.of(context).canPop();

        print("isLastRouteInCurrentTab $isLastRouteInCurrentTab");

        if (isLastRouteInCurrentTab && _currentTab != TabItem.home) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            if (_currentTab == TabItem.home)
              // ? IconButton(
              //     icon: SvgPicture.asset(
              //       icFilters,
              //       color: _searchFilters != null ? primaryColor : null,
              //     ),
              //     onPressed: () {
              //       _scaffoldKey.currentState?.openEndDrawer();
              //     },
              //   )
              IconButton(
                icon: SvgPicture.asset(icCreateAppointment),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(CreateIndividualAppointmentPage.routeName);
                },
              )
          ],
          leading: IconButton(
            icon: SvgPicture.asset(icMenu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Text(AppLocalizations.of(context)!.appName),
        ),
        drawer: _buildDrawerMenu(Provider.of<MasterMode>(context).isMaster),
        // endDrawer: Drawer(child: SearchFiltersPage(searchFilters: _searchFilters)),
        body: _children[_currentTab.index],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          height: 95,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _buildBottomMenuItem(
                    AppLocalizations.of(context)!.home, icHome, TabItem.home),
              ),
              if (!Provider.of<MasterMode>(context).isMaster)
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: _buildBottomMenuItem(
                      AppLocalizations.of(context)!.searching,
                      icSearch,
                      TabItem.search),
                ),
              if (Provider.of<MasterMode>(context).isMaster)
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: _buildBottomMenuItem(
                      AppLocalizations.of(context)!.notifications,
                      icSearch,
                      TabItem.notifications),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildOffstageNavigator(TabItem tabItem) {
  //   return Offstage(
  //     offstage: _navBloc.currentTab != tabItem,
  //     child: Navigator(
  //         key: _navBloc.tabNavigatorKeys[tabItem],
  //         initialRoute: "/",
  //         onGenerateRoute: (settings) {
  //           if (tabItem == TabItem.home) {
  //             return _navBloc.onGenerateRoutes(settings, HomePage());
  //           } else {
  //             return _navBloc.onGenerateRoutes(settings, SearchSalonsPage());
  //           }
  //         }),
  //   );
  // }

  Widget _buildBottomMenuItem(String text, String icon, TabItem tabItem) {
    return InkWell(
      onTap: () => setState(() => _currentTab = tabItem),
      child: Container(
        child: Container(
          height: 56,
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 28),
          decoration: _currentTab == tabItem
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: accentColor,
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon,
                  color: _currentTab == tabItem ? primaryColor : grey),
              marginHorizontal(8),
              Text(
                text,
                style: bodyText1.copyWith(
                    color: _currentTab == tabItem ? primaryColor : grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerMenu(bool isMasterMode) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 48, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    imageWithPlaceholder(
                        _currentUser.avatar, avatarPlaceholder),
                    Spacer(),
                    InkWell(
                      child: SvgPicture.asset(
                        icCancel,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                marginVertical(22),
                Text(_currentUser.name ?? "",
                    style: titleText2.copyWith(
                        fontSize: 24, fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: accentColor,
                    thickness: 1,
                  ),
                ),
                _buildMasterModeSwitcher(isMasterMode),
                marginVertical(32),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDrawerItem(AppLocalizations.of(context)!.ordersHistory,
                      icHistory, DrawerItem.history, onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(AppointmentsHistoryPage.routeName);
                  }),
                  if (!isMasterMode)
                    _buildDrawerItem(
                        AppLocalizations.of(context)!.favouriteSalons,
                        icStarUnchecked,
                        DrawerItem.favourites, onClick: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(FavouriteSalonsPage.routeName);
                    }),
                  if (!isMasterMode)
                    _buildDrawerItem(AppLocalizations.of(context)!.promo,
                        icPromo, DrawerItem.promo),
                  if (!isMasterMode)
                    _buildDrawerItem(AppLocalizations.of(context)!.bonusCards,
                        icBonusCards, DrawerItem.bonusCards),
                  _buildDrawerItem(AppLocalizations.of(context)!.settings,
                      icSettings, DrawerItem.settings, onClick: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(SettingsPage.routeName);
                  }),
                  _buildDrawerItem(AppLocalizations.of(context)!.exit, icExit,
                      DrawerItem.exit,
                      onClick: () => _loginBloc.logout()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Timer? _timer;
  ValueNotifier<bool> _masterSwitcherCanClick = ValueNotifier(true);

  bool _masterSwitcherEnabled = true;

  Widget _buildMasterModeSwitcher(bool isMaster) {
    var provider = Provider.of<MasterMode>(context, listen: false);

    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: grey.withAlpha(40),
      ),
      child: Row(
        children: [
          Flexible(
            child: InkWell(
              onTap: () {
                if (provider.isMaster) {
                  print("_masterSwitcherEnabled ${_masterSwitcherEnabled}");
                  _onClickMasterSwitcher(false, provider);
                }
              },
              child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isMaster ? null : primaryColor,
                ),
                child: Text(
                  AppLocalizations.of(context)!.client,
                  style: hintText2.copyWith(
                      fontSize: 14,
                      color: isMaster ? Colors.black : Colors.white),
                ),
              ),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                if (!provider.isMaster) {
                  print("_masterSwitcherEnabled $_masterSwitcherEnabled");

                  _onClickMasterSwitcher(true, provider);
                }
              },
              child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isMaster ? primaryColor : null,
                ),
                child: Text(
                  AppLocalizations.of(context)!.master,
                  style: hintText2.copyWith(
                      fontSize: 14,
                      color: isMaster ? Colors.white : Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onClickMasterSwitcher(bool clickedOnMaster, provider) {
    if (_masterSwitcherEnabled) {
      _masterSwitcherEnabled = false;

      provider.setMasterMode(clickedOnMaster);
      getIt<UserRepository>().switchMasterMode(clickedOnMaster);
    }

    _timer = Timer(Duration(milliseconds: 1000), () {
      _masterSwitcherEnabled = true;
    });
  }

  Widget _buildDrawerItem(String title, String icon, DrawerItem drawerItem,
      {Widget? widgetToOpen, Function()? onClick}) {
    return InkWell(
      onTap: () {
        if (drawerItem != DrawerItem.exit) _currentDrawerItem = drawerItem;

        if (widgetToOpen != null)
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widgetToOpen));
        else if (onClick != null) onClick();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        color: _currentDrawerItem == drawerItem ? accentColor : null,
        child: Row(
          children: [
            SvgPicture.asset(icon,
                color:
                    _currentDrawerItem == drawerItem ? primaryColor : greyText),
            marginHorizontal(6),
            Text(
              title,
              style: _currentDrawerItem == drawerItem
                  ? bodyText7.copyWith(color: primaryColor)
                  : bodyText7,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }
}

class AppSelectRoleWidget extends StatelessWidget {
  const AppSelectRoleWidget({
    Key? key,
    required this.onPressedClient,
    required this.colorPrimaryClient,
    required this.colorTextClient,
    required this.onPressedMaster,
    required this.colorPrimaryMaster,
    required this.colorTextMaster,
  }) : super(key: key);

  final Function() onPressedClient;
  final Color colorPrimaryClient;
  final Color colorTextClient;
  final Function() onPressedMaster;
  final Color colorPrimaryMaster;
  final Color colorTextMaster;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: grey.withOpacity(0.1),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Row(
            children: [
              _selectButton(
                'Client',
                onPressedClient,
                colorPrimaryClient,
                colorTextClient,
              ),
              _selectButton(
                'Master',
                onPressedMaster,
                colorPrimaryMaster,
                colorTextMaster,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _selectButton(
      String name, Function() onPressed, Color colorPrimary, Color colorText) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            primary: colorPrimary),
        child: Text(
          name,
          style: TextStyle(color: colorText),
        ),
      ),
    );
  }
}
