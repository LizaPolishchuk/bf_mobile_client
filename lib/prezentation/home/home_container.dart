import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/event_bus_events/go_to_search_salons_event.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/home_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';
import 'package:salons_app_mobile/prezentation/orders_history/orders_history_page.dart';
import 'package:salons_app_mobile/prezentation/profile/settings_page.dart';
import 'package:salons_app_mobile/prezentation/salons_list/favourite_salons_page.dart';
import 'package:salons_app_mobile/prezentation/salons_list/search_salons_page.dart';
import 'package:salons_app_mobile/prezentation/search_filters/search_filters_page.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/events/apply_search_filters_events.dart';
import 'package:salons_app_mobile/utils/events/event_bus.dart';

enum TabItem { home, search }

enum DrawerItem { history, favourites, promo, bonusCards, settings, exit }

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  TabItem _currentTab = TabItem.home;
  DrawerItem? _currentDrawerItem;

  final List _children = [
    const HomePage(),
    const SearchSalonsPage(),
  ];

  late LoginBloc _loginBloc;
  late UserEntity _currentUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AlertBuilder _alertBuilder = AlertBuilder();

  SearchFilters? _searchFilters;

  @override
  void initState() {
    super.initState();

    _currentUser = getIt<LocalStorage>().getCurrentUser();

    _loginBloc = getItApp<LoginBloc>();

    eventBus.on<GoToSearchSalonsEvent>().listen((event) {
      setState(() => _currentTab = TabItem.search);
    });

    eventBus.on<ApplySearchFiltersEvent>().listen((event) {
      print("catch in home container : ${event.searchFilters?.priceFrom}");
      setState(() {
        _searchFilters = event.searchFilters;
      });
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
            _currentTab == TabItem.home
                ? Container()
                : IconButton(
                    icon: SvgPicture.asset(
                      icFilters,
                      color: _searchFilters != null ? primaryColor : null,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  )
          ],
          leading: IconButton(
            icon: SvgPicture.asset(icMenu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Text(tr(AppStrings.appName)),
        ),
        drawer: _buildDrawerMenu(),
        endDrawer:
            Drawer(child: SearchFiltersPage(searchFilters: _searchFilters)),
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
                    tr(AppStrings.home), icHome, TabItem.home),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: _buildBottomMenuItem(
                    tr(AppStrings.searching), icSearch, TabItem.search),
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

  Widget _buildDrawerMenu() {
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
                    style: titleText2.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: accentColor,
                    thickness: 1,
                  ),
                ),
                _buildMasterModeSwitcher(),
                marginVertical(32),
              ],
            ),
          ),
          _buildDrawerItem(
              tr(AppStrings.history), icHistory, DrawerItem.history,
              onClick: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(OrdersHistoryPage.routeName);
          }),
          _buildDrawerItem(
              "Favourite salons", icStarUnchecked, DrawerItem.favourites,
              onClick: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(FavouriteSalonsPage.routeName);
          }),
          _buildDrawerItem(tr(AppStrings.promo), icPromo, DrawerItem.promo),
          _buildDrawerItem(
              tr(AppStrings.bonusCards), icBonusCards, DrawerItem.bonusCards),
          _buildDrawerItem(
              tr(AppStrings.settings), icSettings, DrawerItem.settings,
              onClick: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(SettingsPage.routeName);
          }),
          _buildDrawerItem(tr(AppStrings.exit), icExit, DrawerItem.exit,
              onClick: () => _loginBloc.logout()),
        ],
      ),
    );
  }

  ValueNotifier<bool> _isMasterModeNotifier = ValueNotifier<bool>(false);

  Widget _buildMasterModeSwitcher() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isMasterModeNotifier,
      builder: (context, isMaster, child) {
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
                  onTap: (){
                    _isMasterModeNotifier.value = false;
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isMaster ? null : primaryColor,
                    ),
                    child: Text(
                      tr(AppStrings.client),
                      style: hintText2.copyWith(fontSize: 14, color: isMaster ? Colors.black : Colors.white),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: (){
                    _isMasterModeNotifier.value = true;
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isMaster ? primaryColor : null,
                    ),
                    child: Text(
                      tr(AppStrings.master),
                      style: hintText2.copyWith(fontSize: 14, color: isMaster ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
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
