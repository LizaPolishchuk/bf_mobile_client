import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/prezentation/login/login_event.dart';
import 'package:salons_app_mobile/utils/app_images.dart';

import 'login_bloc.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;

  // late NavBloc navBloc;

  late TextEditingController _teControllerEmail;
  late TextEditingController _teControllerPassword;

  bool rememberMe = false;

  String? _emailErrorText;
  String? _passwordErrorText;

  @override
  void initState() {
    super.initState();

    _loginBloc = getItApp<LoginBloc>();
    // navBloc = getItWeb<NavBloc>();

    _teControllerEmail = new TextEditingController();
    _teControllerPassword = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          child: BlocBuilder<LoginBloc, LoginState>(
              bloc: _loginBloc,
              builder: (BuildContext context, LoginState state) {
                if (state is LoadingLoginState) {
                  return Text("Loading...");
                  // SchedulerBinding.instance?.addPostFrameCallback((_) {
                  //   showLoaderDialog(context);
                  // });
                } else if (state is ErrorLoginState) {
                  print(
                      "ErrorLoginState code:  ${state.errorCode}, message: ${state.errorMessage}");

                  // stopLoaderDialog(context);

                  // if (state.errorCode == "user-not-found") {
                  //   _emailErrorText = tr(AppStrings.wrong_email);
                  // } else if (state.errorCode == "wrong-password") {
                  //   _passwordErrorText = tr(AppStrings.wrong_password);
                  // } else {
                  //   SchedulerBinding.instance?.addPostFrameCallback((_) {
                  //     showAlertDialog(context, description: state.errorMessage);
                  //   });
                  // }
                }
                return buildLoginPage();
              })),
    );
  }

  Widget buildLoginPage() {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: InkWell(
            child: Container(
              height: 60,
              child: Row(
                children: [
                  SvgPicture.asset(icGoogle),
                  Text("Google"),
                ],
              ),
            ),
            onTap: () => _loginBloc..add(LoginWithGoogleEvent()),
          ),
        ),
        Flexible(
          flex: 1,
          child: InkWell(
            child: Container(
              color: Color(0xff3B5998),
              height: 60,
              child: Row(
                children: [
                  SvgPicture.asset(icFacebook),
                  Text("Facebook"),
                ],
              ),
            ),
            onTap: () => _loginBloc.add(LoginWithFacebookEvent()),
          ),
        ),
      ],
    );
  }

// bool validateFields() {
//   setState(() {
//     _emailErrorText = _teControllerEmail.text.isEmpty ||
//             !_teControllerEmail.text.isEmailValid()
//         ? 'Error email'
//         : null;
//     _passwordErrorText =
//         _teControllerPassword.text.isEmpty ? 'Error password' : null;
//   });
//
//   return _passwordErrorText == null && _emailErrorText == null;
// }
//
// Widget buildError() {
//   return Center(
//     child: Text('Error login'),
//   );
// }
}
