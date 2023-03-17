import 'package:bf_mobile_client/utils/app_colors.dart';
import 'package:bf_mobile_client/utils/app_components.dart';
import 'package:bf_mobile_client/utils/app_images.dart';
import 'package:bf_mobile_client/utils/app_styles.dart';
import 'package:bf_mobile_client/utils/date_utils.dart';
import 'package:bf_mobile_client/utils/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';

class CreateIndividualAppointmentPage extends StatefulWidget {
  static const routeName = '/create-appointment';

  const CreateIndividualAppointmentPage({Key? key}) : super(key: key);

  @override
  State<CreateIndividualAppointmentPage> createState() =>
      _CreateIndividualAppointmentPageState();
}

class _CreateIndividualAppointmentPageState
    extends State<CreateIndividualAppointmentPage> {
  TextEditingController _salonNameController = TextEditingController();
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _masterNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  bool _showCalendar = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createAppointment),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildInputText(
                        title: AppLocalizations.of(context)!.salonName,
                        controller: _salonNameController),
                    marginVertical(24),
                    _buildInputText(
                        title: AppLocalizations.of(context)!.serviceName,
                        controller: _serviceNameController),
                    marginVertical(24),
                    _buildInputText(
                        title: AppLocalizations.of(context)!.masterName,
                        controller: _masterNameController),
                    marginVertical(24),
                    _buildInputText(
                        title: AppLocalizations.of(context)!.date,
                        controller: _dateController,
                        icon: icCalendar,
                        onPressIcon: () {
                          setState(() {
                            _showCalendar = !_showCalendar;
                            if (!_showCalendar) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            }
                          });
                        }),
                    if (_showCalendar)
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Calendar(
                          height: 140,
                          calendarFormat: CalendarFormat.twoWeeks,
                          selectedDay: _selectedDate,
                          onSelectDay: (selectedDay) {
                            _selectedDate = selectedDay;
                            _dateController.text =
                                selectedDay.formatToddMMYYYY();
                            setState(() {
                              _showCalendar = false;
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            });
                          },
                        ),
                      ),
                    marginVertical(24),
                    _buildInputText(
                        title: AppLocalizations.of(context)!.time,
                        controller: _timeController,
                        icon: icClock,
                        onPressIcon: () async {
                          _selectedTime = await showTimePicker(
                            initialTime: _selectedTime ?? TimeOfDay.now(),
                            context: context,
                          );

                          if (_selectedTime != null) {
                            _timeController.text =
                                _selectedTime!.format(context);
                          }

                          FocusScope.of(context).requestFocus(new FocusNode());

                          // setState(() {
                          //   _showCalendar = !_showCalendar;
                          //   if (!_showCalendar) {
                          //     FocusScope.of(context)
                          //         .requestFocus(new FocusNode());
                          //   }
                          // });
                        }),
                    marginVertical(24),
                    _buildInputText(
                      title: AppLocalizations.of(context)!.price,
                      controller: _priceController,
                      isPrice: true,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: roundedButton(
                  context, AppLocalizations.of(context)!.save, () {},
                  width: double.infinity),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputText(
      {required String title,
      required TextEditingController controller,
      String? icon,
      VoidCallback? onPressIcon,
      bool isPrice = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bodyText4,
        ),
        marginVertical(8),
        textFieldWithBorders(
          "", controller,
          maxLength: 250,
          onTap: onPressIcon,
          enabled: icon == null,
          keyboardType:
              isPrice == true ? TextInputType.number : TextInputType.name,
          inputFormatters:
              isPrice ? [FilteringTextInputFormatter.digitsOnly] : null,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIconConstraints: icon != null
              ? BoxConstraints(minWidth: 26, minHeight: 26)
              : null,
          suffixIcon: icon != null
              ? Container(
                  height: 26,
                  width: 26,
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    icon,
                    color: primaryColor,
                  ),
                )
              : null,
          //     validator: (text) {
          //   if (!_isButtonPressed) {
          //     return null;
          //   }
          //   return (text?.isEmpty == true)
          //       ? "Это поле не может быть пустым"
          //       : null;
          // },
        ),
      ],
    );
  }
}
