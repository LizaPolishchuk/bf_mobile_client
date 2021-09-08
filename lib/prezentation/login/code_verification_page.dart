import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/prezentation/login/login_event.dart';

import 'login_bloc.dart';
import 'login_state.dart';

class CodeVerificationPage extends StatefulWidget {
  static const routeName = '/code-varification';

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  late LoginBloc _loginBloc;

  // late NavBloc navBloc;

  late TextEditingController _teControllerPhone;

  bool rememberMe = false;

  String? _codeErrorText;

  @override
  void initState() {
    super.initState();

    _loginBloc = getItApp<LoginBloc>();
    // navBloc = getItWeb<NavBloc>();

    _teControllerPhone = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:

        BlocBuilder<LoginBloc, LoginState>(
            bloc: _loginBloc,
            builder: (BuildContext context, LoginState state) {
              if (state is LoggedInState) {
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
              }
              if (state is LoadingLoginState) {
                return Text("Loading...");
                // SchedulerBinding.instance?.addPostFrameCallback((_) {
                //   showLoaderDialog(context);
                // });
              } else if (state is ErrorLoginState) {
                if (state.errorCode == 400) {
                  _codeErrorText = "Error code";
                }
                print("ErrorLoginState code:  ${state.errorCode}, message: ${state.errorMessage}");

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
              return buildPage();
            }),
      ),
    );
  }

  Widget buildPage() {
    return Column(
      children: [
        Text("Code verification"),
        Flexible(
          flex: 1,
          child:TextField(
            decoration: InputDecoration(
              errorText: _codeErrorText,
            ),
            controller: _teControllerPhone,
          ),),
        TextButton(
            onPressed: () {
              _loginBloc.add(LoginWithPhoneVerifyCodeEvent(_teControllerPhone.text));
            },
            child: Text("Login")),
      ],
    );
  }

}
