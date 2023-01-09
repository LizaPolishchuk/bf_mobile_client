import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salons_app_mobile/utils/app_colors.dart';
import 'package:salons_app_mobile/utils/app_components.dart';
import 'package:salons_app_mobile/utils/app_images.dart';
import 'package:salons_app_mobile/utils/app_strings.dart';

import '../app_styles.dart';

enum GenderSelectorType { icons, radio_buttons }

class GenderSelector extends StatefulWidget {
  final GenderSelectorType genderSelectorType;
  final Function(int selectedGender) onSelectGender;
  final int? initialGender;
  final bool enabled;

  const GenderSelector(
      {Key? key,
      required this.genderSelectorType,
      this.initialGender,
      this.enabled = true,
      required this.onSelectGender})
      : super(key: key);

  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  int? _selectedGender;

  @override
  void initState() {
    super.initState();

    _selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    return _buildGenderSelector();
  }

  Widget _buildGenderSelector() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderItem(AppLocalizations.of(context)!.man, icMan, 0),
        marginHorizontal(52),
        _buildGenderItem(AppLocalizations.of(context)!.woman, icWoman, 1),
      ],
    );
  }

  Widget _buildGenderItem(String name, String image, int genderIndex) {
    return GestureDetector(
      child: widget.genderSelectorType == GenderSelectorType.icons
          ? _buildGenderIconItem(name, image, genderIndex)
          : _buildGenderRadioItem(name, genderIndex),
      onTap: () {
        if (widget.enabled) {
          widget.onSelectGender(genderIndex);
          setState(() {
            _selectedGender = genderIndex;
          });
        }
      },
    );
  }

  Widget _buildGenderIconItem(String name, String image, int genderIndex) {
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

  Widget _buildGenderRadioItem(String name, int genderIndex) {
    return Container(
      height: 55,
      width: 135,
      alignment: Alignment.center,
      decoration: (genderIndex == _selectedGender)
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: accentColor,
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            genderIndex == _selectedGender
                ? icCheckBoxSelected
                : icCheckBoxUnselected,
            color: genderIndex != _selectedGender ? greyText : null,
          ),
          marginHorizontal(10),
          Text(
            name,
            style: bodyText6.copyWith(
                color:
                    genderIndex == _selectedGender ? primaryColor : greyText),
          ),
        ],
      ),
    );
  }
}
