import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/login/code_verification_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_event.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

import 'login_bloc.dart';
import 'login_state.dart';

const uaCode = "+380";

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;
  late TextEditingController _teControllerPhone;
  final _formKey = GlobalKey<FormState>();
  final AlertBuilder _alertBuilder = new AlertBuilder();
  late FocusNode _teFocusNode;

  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    _loginBloc = getItApp<LoginBloc>();
    _teControllerPhone = new TextEditingController();
    _teFocusNode = FocusNode();

    _teControllerPhone.addListener(() {
      if (_isButtonPressed != false) {
        _isButtonPressed = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff193a3c),
      body: BlocProvider.value(
        value: _loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (BuildContext context, state) {
            if (state is LoadingLoginState) {
              _alertBuilder.showLoaderDialog(context);
            } else {
              _alertBuilder.stopLoaderDialog(context);
            }

            if (state is ErrorLoginState) {
              String errorMsg = kDebugMode
                  ? state.failure.message : tr(AppStrings.somethingWentWrong);
              _alertBuilder.showErrorSnackBar(context, errorMsg);
            }

            if (state is VerifyCodeSentState) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CodeVerificationPage(
                    _loginBloc, uaCode + _teControllerPhone.text),
              ));
            }
            // else if (state is LoggedInState) {
            //   Navigator.of(context).pushAndRemoveUntil(
            //       MaterialPageRoute(
            //         builder: (context) => (state.isNewUser ?? false)
            //             ? RegistrationPage(state.user)
            //             : HomeContainer(),
            //       ),
            //       (Route<dynamic> route) => false);
            // }
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
        Image.asset(
          loginPlaceholder,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: buildLogin(),
          ),
        ),
      ],
    );
  }

  Widget buildLogin() {
    print(_teFocusNode.hasFocus);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr(AppStrings.welcome),
            style: TextStyle(
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          marginVertical(2),
          Text(
            tr(AppStrings.enterPhoneDescription),
            style: TextStyle(
              color: grey,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          marginVertical(24),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: textFieldWithBorders(
              "",
              _teControllerPhone,
              // hintText: "+380",
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              focusNode: _teFocusNode,
              maxLength: 9,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 1.5),
                child: Text(
                  uaCode,
                  style: bodyText1,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              validator: (String? arg) {
                if (!_isButtonPressed) {
                  return null;
                }
                return (arg?.length == null || arg!.length < 9)
                    ? tr(AppStrings.phoneError)
                    : null;
              },
            ),
          ),
          marginVertical(22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: roundedButton(
              context,
              tr(AppStrings.signIn),
              () async {
                _isButtonPressed = true;
                if (_formKey.currentState!.validate()) {
                  var hasConnection =
                      await ConnectivityManager.checkInternetConnection();
                  if (hasConnection) {
                    _loginBloc.add(
                        LoginWithPhoneEvent(uaCode + _teControllerPhone.text));
                  } else {
                    _alertBuilder.showErrorSnackBar(
                        context, tr(AppStrings.noInternetConnection));
                  }
                }
              },
              width: double.infinity,
            ),
          ),
          // marginVertical(22),
          // Text(
          //   tr(AppStrings.continueWith).toUpperCase(),
          //   style: bodyText1,
          // ),
          // marginVertical(22),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     InkWell(
          //       child: SvgPicture.asset(icGoogle),
          //       onTap: () => _loginBloc..add(LoginWithGoogleEvent()),
          //     ),
          //     marginHorizontal(10),
          //     InkWell(
          //       child: SvgPicture.asset(icFacebook),
          //       onTap: () => _loginBloc.add(LoginWithFacebookEvent()),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();

    super.dispose();
  }
}
