
abstract class NavEvent {
  final List arguments;

  NavEvent([this.arguments = const []]);
}

class NavPop extends NavEvent {
}

class NavPopMain extends NavEvent {
}

class NavPopAllAndClear extends NavEvent {
}

class NavPopAll extends NavEvent {

}

class NavLogin extends NavEvent {
  NavLogin(args) : super(args);
}

class NavSalonDetails extends NavEvent {
  NavSalonDetails(args) : super(args);
}

class NavChooseCategoryPage extends NavEvent {
  NavChooseCategoryPage(args) : super(args);
}

class NavChooseServicePage extends NavEvent {
  NavChooseServicePage(args) : super(args);
}

class NavCreateOrderPage extends NavEvent {
  NavCreateOrderPage(args) : super(args);
}

class NavOrdersHistoryPage extends NavEvent {
  NavOrdersHistoryPage(args) : super(args);
}

class NavProfilePage extends NavEvent {
  NavProfilePage(args) : super(args);
}