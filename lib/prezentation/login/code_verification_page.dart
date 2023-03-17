import 'package:bf_mobile_client/prezentation/login/code_verification_bloc.dart';
import 'package:bf_mobile_client/utils/alert_builder.dart';
import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'login_bloc.dart';

class CodeVerificationPage extends StatefulWidget {
  static const routeName = '/code-verification';

  final String phoneNumber;
  final LoginBloc loginBloc;

  const CodeVerificationPage(this.loginBloc, this.phoneNumber);

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  late CodeVerifyBloc _codeVerifyBloc;
  late TextEditingController _teControllerCode;
  final AlertBuilder _alertBuilder = new AlertBuilder();

  @override
  void initState() {
    super.initState();

    print("code verification page init");

    widget.loginBloc.codeSentSuccess.listen((event) {
      SmsAutoFill().listenForCode();
    });

    _teControllerCode = TextEditingController();
    _codeVerifyBloc = getIt<CodeVerifyBloc>();
    _codeVerifyBloc.setLoginBloc(widget.loginBloc);

    _codeVerifyBloc.startTimerToResendCode();

    _codeVerifyBloc.loggedInSuccess.listen((event) {
      Navigator.of(context).pop();
    });

    _codeVerifyBloc.errorMessage.listen((errorMsg) {
      _alertBuilder.showErrorSnackBar(context, errorMsg);
    });

    _codeVerifyBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        _alertBuilder.showLoaderDialog(context);
      } else {
        _alertBuilder.stopLoaderDialog(context);
      }
    });
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _codeVerifyBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgGrey,
        title: Text(
          AppLocalizations.of(context)!.appName,
        ),
      ),
      body: SafeArea(
        child: Stack(
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
        ),
      ),
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
            AppLocalizations.of(context)!.phoneVerification,
            style: titleText1,
          ),
          marginVertical(7),
          Text(
            AppLocalizations.of(context)!.phoneVerificationDescription,
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
                _codeVerifyBloc.verifyCode(context,
                    widget.phoneNumber, _teControllerCode.text);
              }
            },
          ),
          marginVertical(42),
          roundedButton(context, AppLocalizations.of(context)!.continueTxt,
              () async {
            _codeVerifyBloc.verifyCode(context,
                widget.phoneNumber, _teControllerCode.text);
          }),
          Spacer(),
          StreamBuilder<int?>(
              stream: _codeVerifyBloc.resendCodeTime,
              builder: (context, snapshot) {
                return RichText(
                  text: TextSpan(
                    style: bodyText4,
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              AppLocalizations.of(context)!.didNotReceiveCode +
                                  " "),
                      TextSpan(
                          text: (snapshot.data == null)
                              ? AppLocalizations.of(context)!.resendCode
                              : '${AppLocalizations.of(context)!.resendCode} 0:${snapshot.data! < 10 ? "0" : ""}${snapshot.data}',
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
                                  _codeVerifyBloc
                                      .resendCode(widget.phoneNumber);
                                }
                              } else {
                                _alertBuilder.showErrorSnackBar(
                                    context,
                                    AppLocalizations.of(context)!
                                        .noInternetConnection);
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
