import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/home_container.dart';
import 'package:salons_app_mobile/prezentation/login/code_verification_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_event.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_page.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
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

  @override
  void initState() {
    super.initState();

    _loginBloc = getItApp<LoginBloc>();
    _teControllerPhone = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _alertBuilder.showErrorDialog(context, state.failure.message);
            } else {
              _alertBuilder.stopErrorDialog(context);
            }

            if (state is VerifyCodeSentState) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CodeVerificationPage(state.isCreator, _teControllerPhone.text),
              ));
            } else if (state is LoggedInState) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => (state.isNewUser ?? false)
                        ? RegistrationPage(state.user)
                        : HomeContainer(),
                  ),
                  (Route<dynamic> route) => false);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: textFieldWithBorders(
              tr(AppStrings.phoneNumber),
              _teControllerPhone,
              maxLength: 9,
              prefixText: uaCode,
              keyboardType: TextInputType.phone,
              validator: (String? arg) {
                return (arg?.length == null || arg!.length < 9)
                    ? tr(AppStrings.phoneError)
                    : null;
              },
            ),
          ),
          marginVertical(22),
          buttonWithText(
            context,
            tr(AppStrings.signIn),
            () {
              if (_formKey.currentState!.validate())
                _loginBloc
                    .add(LoginWithPhoneEvent(uaCode + _teControllerPhone.text));
            },
          ),
          marginVertical(22),
          Text(
            tr(AppStrings.continueWith).toUpperCase(),
            style: bodyText1,
          ),
          marginVertical(22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: SvgPicture.asset(icGoogle),
                onTap: () => _loginBloc..add(LoginWithGoogleEvent()),
              ),
              marginHorizontal(10),
              InkWell(
                child: SvgPicture.asset(icFacebook),
                onTap: () => _loginBloc.add(LoginWithFacebookEvent()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
