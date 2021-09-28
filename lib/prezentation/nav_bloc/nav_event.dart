
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

class NavEditRatingDetails extends NavEvent {
  NavEditRatingDetails(args) : super(args);

}