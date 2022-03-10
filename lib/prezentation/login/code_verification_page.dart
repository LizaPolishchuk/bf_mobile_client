import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/home_container.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_page.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'login_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class CodeVerificationPage extends StatefulWidget {
  static const routeName = '/code-verification';

  final String phoneNumber;
  final LoginBloc loginBloc;

  const CodeVerificationPage(this.loginBloc, this.phoneNumber);

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  late LoginBloc _loginBloc;
  late TextEditingController _teControllerCode;
  final AlertBuilder _alertBuilder = new AlertBuilder();

  @override
  void initState() {
    super.initState();

    listenForCode();

    _teControllerCode = TextEditingController();
    _loginBloc = widget.loginBloc;
    _loginBloc.add(StartTimerEvent());
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
        child: BlocListener<LoginBloc, LoginState>(
          listener: (BuildContext context, state) {
            if (state is LoggedInState) {
              SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => (state.isNewUser ?? false)
                          ? RegistrationPage(state.user)
                          : HomeContainer(),
                    ),
                    (Route<dynamic> route) => false);
              });
            }

            if (state is LoadingCodeVerifyState) {
              _alertBuilder.showLoaderDialog(context);
            } else {
              _alertBuilder.stopLoaderDialog(context);
            }

            if (state is ErrorCodeVerifyState) {
              print("${state.failure}");
              String errorMsg = state.failure.message;
              if (errorMsg == NoInternetException.noInternetCode) {
                errorMsg = tr(AppStrings.noInternetConnection);
              } else {
                errorMsg =
                    (state.failure.codeStr == "invalid-verification-code")
                        ? tr(AppStrings.wrongCode)
                        : tr(AppStrings.somethingWentWrong);
              }
              _alertBuilder.showErrorSnackBar(context, errorMsg);
            } else {
              _alertBuilder.stopErrorDialog(context);
            }
          },
          bloc: _loginBloc,
          child: buildPage(),
        ),
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
            autoFocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            onCodeChanged: (code) async {
              if (code!.length == 6) {
                var hasConnection =
                    await ConnectivityManager.checkInternetConnection();
                if (hasConnection) {
                  _loginBloc.add(LoginWithPhoneVerifyCodeEvent(
                      _teControllerCode.text, widget.phoneNumber));
                } else {
                  _alertBuilder.showErrorSnackBar(
                      context, tr(AppStrings.noInternetConnection));
                }
              }
            },
          ),
          marginVertical(42),
          roundedButton(context, tr(AppStrings.continueTxt), () async {
            var hasConnection =
                await ConnectivityManager.checkInternetConnection();
            if (hasConnection) {
              _loginBloc.add(LoginWithPhoneVerifyCodeEvent(
                  _teControllerCode.text, widget.phoneNumber));
            } else {
              _alertBuilder.showErrorSnackBar(
                  context, tr(AppStrings.noInternetConnection));
            }
          }),
          Spacer(),
          StreamBuilder<int?>(
              stream: _loginBloc.streamTime,
              builder: (context, snapshot) {
                return RichText(
                  text: TextSpan(
                    style: bodyText4,
                    children: <TextSpan>[
                      TextSpan(text: tr(AppStrings.didNotReceiveCode) + " "),
                      TextSpan(
                          text: (snapshot.data == null)
                              ? tr(AppStrings.resendCode)
                              : '${tr(AppStrings.resendCode)} 0:${snapshot.data! < 10 ? "0" : ""}${snapshot.data}',
                          style: bodyText4.copyWith(
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              if (snapshot.data == null) {
                                var hasConnection = await ConnectivityManager
                                    .checkInternetConnection();
                                if (hasConnection) {
                                  _loginBloc.add(
                                      LoginWithPhoneEvent(widget.phoneNumber));
                                  _loginBloc.add(StartTimerEvent());
                                }
                              } else {
                                _alertBuilder.showErrorSnackBar(context,
                                    tr(AppStrings.noInternetConnection));
                              }
                            }),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
