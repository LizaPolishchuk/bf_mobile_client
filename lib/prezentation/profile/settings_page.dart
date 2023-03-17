import 'dart:io';

import 'package:bf_mobile_client/l10n/l10n.dart';
import 'package:bf_mobile_client/prezentation/profile/profile_bloc.dart';
import 'package:bf_mobile_client/utils/alert_builder.dart';
import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_images.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/extentions.dart';
import 'package:bf_mobile_client/utils/widgets/gender_selector.dart';
import 'package:bf_network_module/bf_network_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

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

  Gender? _selectedGender;
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
        title: Text(AppLocalizations.of(context)!.settings),
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
    _selectedGender = Gender.values.byName(user.gender);

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
                  SizedBox(
                    height: 88,
                    width: 93,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 88,
                          width: 88,
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: _pickedAvatar != null
                              ? ClipRRect(
                                  child: Image.file(
                                    _pickedAvatar!,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                )
                              : user.avatar?.isNotEmpty == true
                                  ? ClipRRect(
                                      child: Image.network(
                                        user.avatar!,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    )
                                  : SvgPicture.asset(icProfilePlaceholder),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () async {
                              if (_isEditMode) {
                                final PickedFile? image = await ImagePicker()
                                    .getImage(source: ImageSource.gallery);
                                if (image != null) {
                                  setState(() {
                                    _pickedAvatar = File(image.path);
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: 24,
                              width: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  width: 1,
                                  color: primaryColor,
                                ),
                              ),
                              child: SvgPicture.asset(icCamera),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  marginVertical(24),
                  Form(
                    key: _formKeyName,
                    child: textFieldWithBorders(
                      AppLocalizations.of(context)!.name,
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
                      AppLocalizations.of(context)!.phoneNumber,
                      _teControllerPhone,
                      maxLength: 9,
                      enabled: false,
                      prefixText: null,
                      keyboardType: TextInputType.phone,
                      validator: (String? arg) {
                        return (arg?.length == null || arg!.length < 9)
                            ? AppLocalizations.of(context)!.phoneError
                            : null;
                      },
                    ),
                  ),
                  marginVertical(isKeyboard ? 33 : 51),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.yourGender,
                      style: appBarText,
                    ),
                  ),
                  marginVertical(16),
                  GenderSelector(
                      genderSelectorType: GenderSelectorType.radio_buttons,
                      initialGender: _selectedGender,
                      enabled: _isEditMode,
                      onSelectGender: (Gender selectedGender) {
                        _selectedGender = selectedGender;
                      }),
                  marginVertical(16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.language,
                      style: appBarText,
                    ),
                  ),
                  marginVertical(16),
                  _buildLanguageSelector(),
                  Spacer(),
                  roundedButton(
                      context,
                      _isEditMode
                          ? AppLocalizations.of(context)!.saveChanges
                          : AppLocalizations.of(context)!.editProfile, () {
                    if (!_isEditMode) {
                      setState(() {
                        _isEditMode = true;
                      });
                    } else {
                      bool validName = _formKeyName.currentState!.validate();
                      if (validName) {
                        UserEntity userToUpdate = user.copy(
                          firstname: _teControllerName.text,
                          gender: _selectedGender?.name,
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
                      child: roundedButton(
                          context, AppLocalizations.of(context)!.cancel, () {
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

  Locale? _selectedLocale;

  Widget _buildLanguageSelector() {
    var supportedLocales = L10n.supportedLocales;
    var currentLocaleName = getIt<LocalStorage>().getLanguage();

    if (currentLocaleName == null) {
      var localName = Platform.localeName;
      if (localName.contains("-")) {
        localName = localName.split("-").first;
      }
      currentLocaleName = localName;
    }
    _selectedLocale = Locale(currentLocaleName);

    if (!supportedLocales.contains(_selectedLocale)) {
      _selectedLocale = L10n.defaultLocale;
    }

    var languages = supportedLocales
        .map((locale) => RadioListTile<Locale>(
              value: locale,
              contentPadding: EdgeInsets.zero,
              activeColor: primaryColor,
              title: Text(
                LocaleNames.of(context)!
                        .nameOf(locale.languageCode)
                        ?.capitalize() ??
                    locale.languageCode,
                style: bodyText6.copyWith(
                    color: locale == _selectedLocale ? primaryColor : greyText),
              ),
              groupValue: _selectedLocale,
              onChanged: (Locale? locale) {
                if (locale != null && _selectedLocale != locale) {
                  setState(() {
                    _selectedLocale = locale;
                  });
                  getIt<UserRepository>().setCurrentLanguage(locale.languageCode);
                }
              },
            ))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: languages,
    );
  }
}
