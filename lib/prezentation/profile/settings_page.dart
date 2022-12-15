// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'package:salons_app_mobile/localization/translations.dart';
import 'package:salons_app_mobile/prezentation/profile/profile_bloc.dart';
import 'package:salons_app_mobile/utils/alert_builder.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';
import 'package:salons_app_mobile/utils/app_styles.dart';
import 'package:salons_app_mobile/utils/widgets/app_dowland_photo.dart';
import 'package:salons_app_mobile/utils/widgets/gender_selector.dart';

import '../../injection_container_app.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _teControllerName;
  late TextEditingController _teControllerPhone;
  late ProfileBloc _profileBloc;

  final _formKeyName = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();
  AlertBuilder _alertBuilder = new AlertBuilder();

  int? _selectedGender;
  bool _isEditMode = false;

  File? _pickedAvatar;

  @override
  void initState() {
    super.initState();

    _profileBloc = getItApp<ProfileBloc>();
    _profileBloc.loadUserProfile();

    _teControllerName = new TextEditingController();
    _teControllerPhone = new TextEditingController();

    _profileBloc.profileUpdated.listen((_) {
      _isEditMode = false;
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
      appBar: AppBar(
        title: Text(tr(AppStrings.settings)),
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

    _teControllerName.text = user.name ?? "";
    _teControllerPhone.text = user.phone ?? "";
    _selectedGender = user.gender;

    print(_selectedGender);

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight - 16),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppDowlandPhoto(
                    onTap: () async {
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
                    pickedAvatar: _pickedAvatar,
                    user: user,
                  ),
                  marginVertical(24),
                  Form(
                    key: _formKeyName,
                    child: textFieldWithBorders(
                      tr(AppStrings.name),
                      _teControllerName,
                      enabled: _isEditMode,
                      validator: (text) => (text?.isEmpty == true)
                          ? "Это поле не может быть пустым"
                          : null,
                    ),
                  ),
                  marginVertical(16),
                  Form(
                    key: _formKeyPhone,
                    child: textFieldWithBorders(
                      tr(AppStrings.phoneNumber),
                      _teControllerPhone,
                      maxLength: 9,
                      enabled: false,
                      prefixText: null,
                      keyboardType: TextInputType.phone,
                      validator: (String? arg) {
                        return (arg?.length == null || arg!.length < 9)
                            ? tr(AppStrings.phoneError)
                            : null;
                      },
                    ),
                  ),
                  marginVertical(isKeyboard ? 33 : 51),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tr(AppStrings.yourGender),
                      style: appBarText,
                    ),
                  ),
                  marginVertical(16),
                  GenderSelector(
                      genderSelectorType: GenderSelectorType.radio_buttons,
                      initialGender: _selectedGender,
                      enabled: _isEditMode,
                      onSelectGender: (int selectedGender) {
                        _selectedGender = selectedGender;
                      }),
                  Spacer(),
                  roundedButton(
                      context,
                      _isEditMode
                          ? tr(AppStrings.saveChanges)
                          : tr(AppStrings.editProfile), () {
                    if (!_isEditMode) {
                      setState(() {
                        _isEditMode = true;
                      });
                    } else {
                      bool validName = _formKeyName.currentState!.validate();
                      if (validName) {
                        UserEntity userToUpdate = user.copy(
                          name: _teControllerName.text,
                          gender: _selectedGender,
                        );
                        _profileBloc.updateUser(userToUpdate,
                            userAvatar: _pickedAvatar);
                      }
                    }
                  }),
                  const SizedBox(height: 12),
                  if (_isEditMode)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: roundedButton(context, tr(AppStrings.cancel), () {
                        setState(() {
                          _isEditMode = false;
                        });
                      }),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
