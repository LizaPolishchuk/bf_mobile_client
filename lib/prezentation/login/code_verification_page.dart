import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/loader.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'login_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class CodeVerificationPage extends StatefulWidget {
  static const routeName = '/code-verification';

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  late LoginBloc _loginBloc;
  late TextEditingController _teControllerCode;
  final AlertBuilder _loader = new AlertBuilder();

  @override
  void initState() {
    super.initState();

    listenForCode();

    _teControllerCode = TextEditingController();
    _loginBloc = getItApp<LoginBloc>();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void listenForCode() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgGrey,
        title: Text(
          tr(AppStrings.appName),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<LoginBloc, LoginState>(
            bloc: _loginBloc,
            builder: (BuildContext context, LoginState state) {
              if (state is LoggedInState) {
                _loader.stopLoaderDialog(context);
              }
              if (state is LoadingLoginState) {
                _loader.showLoaderDialog(context);
              } else if (state is ErrorLoginState) {
                _loader.stopLoaderDialog(context);

                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  Fluttertoast.showToast(
                      msg: (state.failure.code == 400)
                          ? "Не верный код"
                          : "Something went wrong",
                      toastLength: Toast.LENGTH_LONG);
                });
              }

              return buildPage();
            }),
      ),
    );
  }

  Widget buildPage() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: bgGrey,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: buildContent(),
          ),
        ),
      ],
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            tr(AppStrings.phoneVerification),
            style: titleText1,
          ),
          marginVertical(7),
          Text(
            tr(AppStrings.phoneVerificationDescription),
            style: bodyText2,
            textAlign: TextAlign.center,
          ),
          marginVertical(64),
          PinFieldAutoFill(
            controller: _teControllerCode,
            codeLength: 6,
            decoration: UnderlineDecoration(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
            ),
            cursor: Cursor(
                color: primaryColor, height: 26, enabled: true, width: 3),
            currentCode: "",
            onCodeSubmitted: (code) {},
            onCodeChanged: (code) {
              if (code!.length == 6) {
                _loginBloc
                    .add(LoginWithPhoneVerifyCodeEvent(_teControllerCode.text));
              }
            },
          ),
          marginVertical(42),
          buttonWithText(context, tr(AppStrings.continueTxt), () {
            _loginBloc
                .add(LoginWithPhoneVerifyCodeEvent(_teControllerCode.text));
          }),
        ],
      ),
    );
  }
}
