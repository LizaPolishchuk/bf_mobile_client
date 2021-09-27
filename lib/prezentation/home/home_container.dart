import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/home_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_bloc.dart';
import 'package:salons_app_mobile/prezentation/login/login_event.dart';
import 'package:salons_app_mobile/prezentation/login/login_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_state.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_bloc.dart';
import 'package:salons_app_mobile/prezentation/nav_bloc/nav_event.dart';
import 'package:salons_app_mobile/prezentation/salons_list/search_salons_page.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  TabItem _currentTab = TabItem.home;
  late NavBloc _navBloc;
  late LoginBloc _loginBloc;
  late UserEntity _currentUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AlertBuilder _alertBuilder = AlertBuilder();

  @override
  void initState() {
    super.initState();

    _currentUser = getIt<LocalStorage>().getCurrentUser();

    _loginBloc = getItApp<LoginBloc>();
    _navBloc = getItApp<NavBloc>();
  }

  void _onItemTapped(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navBloc.add(NavPopAll());
    } else {
      _navBloc.currentTab = tabItem;
      setState(() => _currentTab = tabItem);
    }
  }

  /// Created to be called from navBloc for the ability to switch tabs from outside
  void changeActiveTab(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

//       WillPopScope(
//         onWillPop: () async {
//       final isFirstRouteInCurrentTab = !await _navBloc
//           .tabNavigatorKeys[_navBloc.currentTab]!.currentState!
//           .maybePop();
//       if (isFirstRouteInCurrentTab) {
//         if (_navBloc.currentTab != TabItem.search) {
// //            _tabIndex = 0;
//           _onItemTapped(TabItem.search.index);
//
//           return false;
//         }
//       }
//       // let system handle back button if we're on the first route
//       return isFirstRouteInCurrentTab;
//     },
//     child:

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (BuildContext context, state) {
          if (state is ErrorLoginState) {
            _alertBuilder.showErrorDialog(context, state.failure.message);
          } else {
            _alertBuilder.stopErrorDialog(context);
          }

          if (state is LoggedOutState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (Route<dynamic> route) => false);
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.black),
            ),
            title: Text(tr(AppStrings.appName)),
          ),
          drawer: _buildDrawerMenu(),
          body: Stack(children: <Widget>[
            _buildOffstageNavigator(TabItem.home),
            _buildOffstageNavigator(TabItem.search),
          ]),
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
                      "Home", icHome, TabItem.home),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: _buildBottomMenuItem(
                     "Search", icSearch, TabItem.search),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _navBloc.currentTab != tabItem,
      child: Navigator(
          key: _navBloc.tabNavigatorKeys[tabItem],
          initialRoute: "/",
          onGenerateRoute: (settings) {
            if (tabItem == TabItem.home) {
              return _navBloc.onGenerateRoutes(settings, HomePage());
            } else {
              return _navBloc.onGenerateRoutes(settings, SearchSalonsPage());
            }
          }),
    );
  }

  Widget _buildBottomMenuItem(
      String text, String icon, TabItem tabItem) {
    return InkWell(
      onTap:() => _onItemTapped(tabItem),
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
          Container(
              padding:
                  EdgeInsets.only(top: 56, bottom: 20, left: 16, right: 16),
              decoration: BoxDecoration(color: accentColor),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        tr(AppStrings.appName),
                        style: titleText2.copyWith(color: greyText),
                      ),
                      Spacer(),
                      InkWell(
                        child: SvgPicture.asset(icCancel),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  marginVertical(42),
                  Row(
                    children: [
                      imageWithPlaceholder("", avatarPlaceholder),
                      marginHorizontal(10),
                      Expanded(
                        child: Text(_currentUser.name ?? "",
                            style: bodyText3,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              )),
          marginVertical(40),
          _buildDrawerItem(tr(AppStrings.history), icHistory),
          _buildDrawerItem(tr(AppStrings.promo), icPromo),
          _buildDrawerItem(tr(AppStrings.bonusCards), icBonusCards),
          _buildDrawerItem(tr(AppStrings.settings), icSettings),
          _buildDrawerItem(tr(AppStrings.exit), icExit,
              onClick: () => _loginBloc.add(LogoutEvent())),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, String icon,
      {Widget? widgetToOpen, Function()? onClick}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 28, left: 16, right: 16),
      child: InkWell(
        onTap: () {
          if (widgetToOpen != null)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => widgetToOpen));
          else if (onClick != null) onClick();
        },
        child: Row(
          children: [
            SvgPicture.asset(icon),
            marginHorizontal(8),
            Text(
              title,
              style: bodyText3.copyWith(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
