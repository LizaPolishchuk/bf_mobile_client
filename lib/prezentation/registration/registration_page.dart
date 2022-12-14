import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_bloc.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/widgets/gender_selector.dart';

import '../../injection_container_app.dart';
import '../../utils/app_images.dart';

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

    _registrationBloc.errorMessage.listen((errorMsg) {
      _alertBuilder.showErrorSnackBar(context, errorMsg);
    });

    _registrationBloc.isLoading.listen((isLoading) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            tr(AppStrings.signIn),
            style: titleText2,
          ),
          marginVertical(8),
          Text(
            tr(AppStrings.signInHintText),
            style: hintText2,
          ),
          marginVertical(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr(AppStrings.downloadPhotoText),
                style: text16W400,
              ),
              CircleAvatar(
                child: Image.asset(
                  avatarPlaceholder,
                  fit: BoxFit.fill,
                ),
                backgroundColor: Colors.transparent,
                radius: 50,
              ),
            ],
          ),
          marginVertical(8),
          Text(
            tr(AppStrings.enterName),
            style: text16W400,
          ),
          marginVertical(10),
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
          // GenderSelector(
          //     genderSelectorType: GenderSelectorType.icons,
          //     onSelectGender: (int selectedGender) {
          //       _selectedGender = selectedGender;
          //       if (_showGenderError == true) {
          //         setState(() {
          //           _showGenderError = false;
          //         });
          //       }
          //     }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                child: SvgPicture.asset(icMan),
                backgroundColor: Colors.transparent,
                radius: 50,
              ),
              CircleAvatar(
                child: SvgPicture.asset(icWoman),
                backgroundColor: Colors.transparent,
                radius: 50,
              ),
            ],
          ),
          GenderSelector(
              genderSelectorType: GenderSelectorType.radio_buttons,
              initialGender: _selectedGender,
              enabled: true,
              onSelectGender: (int selectedGender) {
                _selectedGender = selectedGender;
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
                _registrationBloc.updateUser(userToUpdate);
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
