import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/home/home_page.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_bloc.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_event.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_state.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/loader.dart';

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

  @override
  void initState() {
    super.initState();

    _registrationBloc = getItApp<RegistrationBloc>();
    _teControllerName = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
            bloc: _registrationBloc,
            builder: (BuildContext context, RegistrationState state) {
              if (state is LoadingRegistrationState) {
                _alertBuilder.showLoaderDialog(context);
              } else {
                _alertBuilder.stopLoaderDialog(context);
                _alertBuilder.stopErrorDialog(context);
              }

              if (state is UserUpdatedState) {
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                      (Route<dynamic> route) => false);
                });
              } else if (state is ErrorRegistrationState) {
                _alertBuilder.showErrorDialog(context, state.failure.message);
              }

              return _buildPage();
            }),
      ),
    );
  }

  Widget _buildPage() {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Padding(
      padding: const EdgeInsets.only(
        left: 28,
        right: 28,
        top: 120,
        bottom: 28
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            tr(AppStrings.appName),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontSize: 50,
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
            child: textFieldWithBorders(
              tr(AppStrings.name),
              _teControllerName,
              validator: (text) => (text?.isEmpty == true)
                  ? "Это поле не может быть пустым"
                  : null,
            ),
          ),
          marginVertical(isKeyboard ? 33 : 66),
          Text(
            tr(AppStrings.chooseGender),
            style: (_showGenderError == null || _showGenderError == false)
                ? titleText2
                : titleText2.copyWith(color: errorRed),
          ),
          marginVertical(48),
          _buildGenderSelector(),
          marginVertical(isKeyboard ? 40: 80),
          buttonWithText(context, tr(AppStrings.continueTxt), () {
            bool validName = _formKey.currentState!.validate();
            bool validGender = checkIsGenderSelected();
            if (validName && validGender) {
              UserEntity userToUpdate = widget.user.copy(
                name: _teControllerName.text,
                gender: _selectedGender,
              );
              _registrationBloc.add(UpdateUserEvent(userToUpdate));
            }
          }),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: _buildGenderItem(tr(AppStrings.man), icMan, 0),
          onTap: () {
            setState(() {
              _selectedGender = 0;
            });
          },
        ),
        marginHorizontal(52),
        GestureDetector(
          child: _buildGenderItem(tr(AppStrings.woman), icWoman, 1),
          onTap: () {
            setState(() {
              _selectedGender = 1;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGenderItem(String name, String image, int genderIndex) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: SvgPicture.asset(
                image,
                height: (genderIndex == _selectedGender) ? 110 : 70,
                width: (genderIndex == _selectedGender) ? 110 : 70,
              ),
            ),
            marginVertical(6),
            Text(
              name,
              style: bodyText3,
            ),
          ],
        ),
        if (genderIndex != _selectedGender && _selectedGender != null)
          Positioned(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2.0,
                  sigmaY: 2.0,
                ),
                child: Container(
                  height: 80,
                  width: 80,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool checkIsGenderSelected() {
    setState(() {
      _showGenderError = _selectedGender == null;
    });
    return _selectedGender != null;
  }
}
