import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/home_container.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_bloc.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_event.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_state.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/widgets/gender_selector.dart';

import '../../injection_container_app.dart';

class RegistrationPage extends StatefulWidget {
  static const routeName = '/registration';
  final UserEntity user;

  const RegistrationPage(this.user);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController _teControllerName;
  late RegistrationBloc _registrationBloc;
  final _formKey = GlobalKey<FormState>();
  AlertBuilder _alertBuilder = new AlertBuilder();

  int? _selectedGender;
  bool? _showGenderError;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    _registrationBloc = getItApp<RegistrationBloc>();
    _teControllerName = new TextEditingController();
    _teControllerName.addListener(() {
      if (_isButtonPressed) {
        _isButtonPressed = false;
        _formKey.currentState!.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
          bloc: _registrationBloc,
          listener: (BuildContext context, state) {
            if (state is LoadingRegistrationState) {
              _alertBuilder.showLoaderDialog(context);
            } else {
              _alertBuilder.stopLoaderDialog(context);
            }

            if (state is ErrorRegistrationState) {
              String errorMsg = state.failure.message;
              if (errorMsg == NoInternetException.noInternetCode) {
                errorMsg = tr(AppStrings.noInternetConnection);
              } else {
                errorMsg = tr(AppStrings.somethingWentWrong);
              }
              _alertBuilder.showErrorSnackBar(context, errorMsg);
            }

            if (state is UserUpdatedState) {
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => HomeContainer(),
                    ),
                    (Route<dynamic> route) => false);
              });
            }
          },
          builder: (BuildContext context, RegistrationState state) {
            return _buildPage();
          }),
    );
  }

  Widget _buildPage() {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Padding(
      padding: const EdgeInsets.only(left: 28, right: 28, bottom: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Text(
                tr(AppStrings.appName),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  fontSize: 50,
                ),
              ),
            ),
          ),
          marginVertical(48),
          Text(
            tr(AppStrings.enterName),
            style: titleText2,
          ),
          marginVertical(25),
          Form(
            key: _formKey,
            child: textFieldWithBorders(tr(AppStrings.name), _teControllerName,
                maxLength: 250,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                ], validator: (text) {
              if (!_isButtonPressed) {
                return null;
              }
              return (text?.isEmpty == true)
                  ? "Это поле не может быть пустым"
                  : null;
            }),
          ),
          marginVertical(isKeyboard ? 33 : 66),
          Text(
            tr(AppStrings.chooseGender),
            style: (_showGenderError == null || _showGenderError == false)
                ? titleText2
                : titleText2.copyWith(color: errorRed),
          ),
          marginVertical(48),
          GenderSelector(
              genderSelectorType: GenderSelectorType.icons,
              onSelectGender: (int selectedGender) {
                _selectedGender = selectedGender;
                if (_showGenderError == true) {
                  setState(() {
                    _showGenderError = false;
                  });
                }
              }),
          marginVertical(isKeyboard ? 40 : 80),
          roundedButton(context, tr(AppStrings.continueTxt), () async {
            _isButtonPressed = true;
            bool validName = _formKey.currentState!.validate();
            bool validGender = checkIsGenderSelected();
            if (validName && validGender) {
              var hasConnection =
                  await ConnectivityManager.checkInternetConnection();
              if (hasConnection) {
                UserEntity userToUpdate = widget.user.copy(
                  name: _teControllerName.text,
                  gender: _selectedGender,
                );
                _registrationBloc.add(UpdateUserEvent(userToUpdate));
              } else {
                _alertBuilder.showErrorSnackBar(
                    context, tr(AppStrings.noInternetConnection));
              }
            }
          }),
        ],
      ),
    );
  }

  bool checkIsGenderSelected() {
    setState(() {
      _showGenderError = _selectedGender == null;
    });
    return _selectedGender != null;
  }
}
