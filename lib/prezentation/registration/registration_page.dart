import 'package:bf_mobile_client/prezentation/profile/profile_bloc.dart';
import 'package:bf_mobile_client/utils/alert_builder.dart';
import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/widgets/gender_selector.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late ProfileBloc _profileBloc;
  final _formKey = GlobalKey<FormState>();
  AlertBuilder _alertBuilder = new AlertBuilder();

  Gender? _selectedGender;
  bool? _showGenderError;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    _profileBloc = getItApp<ProfileBloc>();
    _teControllerName = new TextEditingController();
    _teControllerName.addListener(() {
      if (_isButtonPressed) {
        _isButtonPressed = false;
        _formKey.currentState!.validate();
      }
    });

    _profileBloc.errorMessage.listen((errorMsg) {
      _alertBuilder.showErrorSnackBar(context, errorMsg);
    });

    _profileBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        _alertBuilder.showLoaderDialog(context);
      } else {
        _alertBuilder.stopLoaderDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
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
                AppLocalizations.of(context)!.appName,
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
            AppLocalizations.of(context)!.enterName,
            style: titleText2,
          ),
          marginVertical(25),
          Form(
            key: _formKey,
            child: textFieldWithBorders(
                AppLocalizations.of(context)!.name, _teControllerName,
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
            AppLocalizations.of(context)!.chooseGender,
            style: (_showGenderError == null || _showGenderError == false)
                ? titleText2
                : titleText2.copyWith(color: errorRed),
          ),
          marginVertical(48),
          GenderSelector(
              genderSelectorType: GenderSelectorType.icons,
              onSelectGender: (Gender selectedGender) {
                _selectedGender = selectedGender;
                if (_showGenderError == true) {
                  setState(() {
                    _showGenderError = false;
                  });
                }
              }),
          marginVertical(isKeyboard ? 40 : 80),
          roundedButton(context, AppLocalizations.of(context)!.continueTxt,
              () async {
            _isButtonPressed = true;
            bool validName = _formKey.currentState!.validate();
            bool validGender = checkIsGenderSelected();
            if (validName && validGender) {
              var hasConnection =
                  await ConnectivityManager.checkInternetConnection();
              if (hasConnection) {
                UserEntity userToUpdate = widget.user.copy(
                  firstname: _teControllerName.text,
                  gender: _selectedGender?.name,
                );
                _profileBloc.updateUser(userToUpdate);
              } else {
                _alertBuilder.showErrorSnackBar(context,
                    AppLocalizations.of(context)!.noInternetConnection);
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
