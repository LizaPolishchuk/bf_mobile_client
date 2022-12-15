import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/profile/profile_bloc.dart';
import 'package:salons_app_mobile/prezentation/registration/registration_bloc.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/widgets/app_dowland_photo.dart';
import 'package:salons_app_mobile/utils/widgets/app_text_button.dart';
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

  File? _pickedAvatar;
  late ProfileBloc _profileBloc;
  bool _isEditMode = false;

  int? _selectedGender;
  bool? _showGenderError;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    _profileBloc = getItApp<ProfileBloc>();
    _profileBloc.loadUserProfile();

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
      appBar: AppBar(
        leading: IconButton(
          //! How better way to do back button?
          //* Whet click back, black screen.
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: bgGrey,
        title: Text(
          tr(AppStrings.appName),
        ),
      ),
      body: StreamBuilder<UserEntity>(
          stream: _profileBloc.profileLoaded,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return SizedBox.shrink();
            }
            return _buildPage(snapshot.data!);
          }),
    );
  }

  Widget _buildPage(UserEntity user) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Padding(
      padding: const EdgeInsets.only(left: 28, right: 28, bottom: 28),
      child: SingleChildScrollView(
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
                AppDowlandPhoto(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => FractionallySizedBox(
                      widthFactor: 0.95,
                      heightFactor: 0.55,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              AppTextButton(
                                onPressed: () async {
                                  if (_isEditMode) {
                                    final XFile? image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      setState(() {
                                        _pickedAvatar = File(image.path);
                                      });
                                    }
                                  }
                                },
                                text: tr(AppStrings.addPhotoGalery),
                              ),
                              Divider(thickness: 1),
                              AppTextButton(
                                onPressed: () {},
                                text: tr(AppStrings.deletePhoto),
                              ),
                              Divider(thickness: 1),
                              AppTextButton(
                                onPressed: () {},
                                text: tr(AppStrings.makePhoto),
                              ),
                              //! In figma 4 buttons. I did not add cacell button.
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  pickedAvatar: _pickedAvatar,
                  user: user,
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
              child: textFieldWithBorders(
                  tr(AppStrings.name), _teControllerName,
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
            marginVertical(isKeyboard ? 10 : 20),
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
