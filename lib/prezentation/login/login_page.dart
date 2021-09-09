import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salons_app_mobile/injection_container_app.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/login/code_verification_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_event.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';

import 'login_bloc.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc _loginBloc;
  late TextEditingController _teControllerPhone;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _loginBloc = getItApp<LoginBloc>();
    _teControllerPhone = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<LoginBloc, LoginState>(
          bloc: _loginBloc,
          builder: (BuildContext context, LoginState state) {
            if (state is VerifyCodeSentState) {
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CodeVerificationPage(),
                ));
              });
            }
            if (state is LoadingLoginState) {
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                showLoaderDialog(context);
              });
            } else if (state is ErrorLoginState) {
              print("ErrorLoginState code:  ${state.errorCode}, message: ${state.errorMessage}");

              stopLoaderDialog(context);

              SchedulerBinding.instance?.addPostFrameCallback((_) {
                Fluttertoast.showToast(
                    msg: "This is Error Toast", toastLength: Toast.LENGTH_LONG);
              });
            }
            return buildLoginPage();
          }),
    );
  }

  Widget buildLoginPage() {
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
            child: buildPageContent(),
          ),
        ),
      ],
    );
  }

  Widget buildPageContent() {
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
              prefixText: "+380",
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CodeVerificationPage(),
              ));
              // _loginBloc.add(LoginWithPhoneEvent(_teControllerPhone.text));
            },
            width: 220,
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
