import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/hours_screen/widgets/hours_selection_form/bloc/hours_selection_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import '../bloc/hours_confirmation_form_bloc.dart';

class HoursConfirmationFormBody extends StatelessWidget {
  final List<String> _days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess(context: context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.getWidth(4),
          right: SizeConfig.getWidth(4),
        ),
        child: Column(
          children: [
            BoldText4(text: "Looks OK?", context: context),
            BoldText5(text: "Select hours to change.", context: context),
            SizedBox(height: SizeConfig.getHeight(2)),
            _hoursList(context: context),
            _errorMessage(),
            SizedBox(height: SizeConfig.getHeight(4)),
            Row(
              children: [
                SizedBox(width: SizeConfig.getWidth(10)),
                _buttons(context: context),
                SizedBox(width: SizeConfig.getWidth(10)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _hoursList({required BuildContext context}) {
    return BlocBuilder<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      builder: (context, state) {
        return Column(
          key: Key("hoursList"),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            state.days.length, 
            (index) => _createDay(
              context: context, 
              dayIndex: index,
              state: state
            )
          )
        );
      }
    );
  }

  Widget _createDay({required BuildContext context, required int dayIndex, required HoursConfirmationFormState state}) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.getHeight(3)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text4(text: "${_days[dayIndex]}:", context: context),
              SizedBox(width: SizeConfig.getWidth(1)),
              _hoursRow(context: context, state: state, dayIndex: dayIndex)
            ],
          ),
        )
      ],
    );
  }

  Widget _hoursRow({required BuildContext context, required HoursConfirmationFormState state, required int dayIndex}) {
    if (state.days[dayIndex].isEmpty) {
      return Text4(text: 'Closed', context: context);
    }
    return Row(
      children: List.generate(
        state.days[dayIndex].length, 
        (index) => _createHour(context: context, hourIndex: index, day: state.days[dayIndex], dayIndex: dayIndex)
      ),
    );
  }
  
  Widget _createHour({required BuildContext context, required int hourIndex, required List<Hour> day, required int dayIndex}) {
    return Row(
      children: [
        TextButton(
          onPressed: () => _editHourButtonPressed(
            context: context,
            hourIndex: hourIndex,
            day: day,
            isOpenHour: true,
            dayIndex: dayIndex
          ),
          child: Text(
            day[hourIndex].start.format(context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              decoration: TextDecoration.underline,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
          )
        ),
        Text4(text: " - ", context: context),
        TextButton(
          onPressed: () => _editHourButtonPressed(
            context: context,
            hourIndex: hourIndex,
            day: day,
            isOpenHour: false,
            dayIndex: dayIndex
          ),
          child: Text(
            day[hourIndex].end.format(context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              decoration: TextDecoration.underline,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
          )
        ),
        if (hourIndex < day.length - 1)
          Row(
            children: [
              SizedBox(width: SizeConfig.getWidth(1)),
              Text4(text: "||", context: context),
              SizedBox(width: SizeConfig.getWidth(1)),
            ],
          )
      ],
    );
  }

  Widget _buttons({required BuildContext context}) {
    return Expanded(
      child: Row(
        children: [
          Expanded(child: _goBackButton(context: context)),
          SizedBox(width: 20.0),
          Expanded(child: _submitButton())
        ],
      )
    );
  }

  Widget _goBackButton({required BuildContext context}) {
    return OutlinedButton(
      key: Key("goBackButtonKey"),
      onPressed: () => BlocProvider.of<HoursSelectionFormBloc>(context).add(Finished(isFinished: false)),
      child: Text4(text: "Back", context: context, color: Theme.of(context).colorScheme.callToAction),
    );
  }

  Widget _submitButton() {
    return BlocBuilder<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl, 
          onAnimationComplete: () => _resetForm(context: context),
          child: ElevatedButton(
            key: Key("submitButtonKey"),
            onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(context: context, state: state) : null, 
            child: _buttonChild(context: context, state: state)
          )
        );
      },
    );
  }

  Widget _buttonChild({required BuildContext context, required HoursConfirmationFormState state}) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: state.isSubmitting
        ? CircularProgressIndicator()
        : Text4(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary),
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<HoursConfirmationFormBloc, HoursConfirmationFormState>(
      builder: (context, state) {
        if (state.errorMessage.isEmpty) return Container();

        return Column(
          children: [
            SizedBox(height: SizeConfig.getHeight(2)),
            TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
          ],
        );
      }
    );
  }

  bool _buttonEnabled({required HoursConfirmationFormState state}) {
    return !state.isSubmitting;
  }

  void _editHourButtonPressed({required BuildContext context, required int hourIndex, required List<Hour> day, required bool isOpenHour, required int dayIndex}) async {
    final Hour hourToEdit = day[hourIndex];
    showTimePicker(
      context: context, 
      initialTime: isOpenHour ? hourToEdit.start : hourToEdit.end,
      cancelText: 'Cancel',
      confirmText: "Change",
      helpText: "Edit Operating Hour",
      builder: (context, child) {
        return Theme(key: Key("timePickerKey"), data: ThemeData.light(), child: child!);
      }
    ).then((newTime) {
      List<Hour> updatedHours = day.where(
        (hour) => hour != hourToEdit
      ).toList()
      ..add(
        isOpenHour 
          ? hourToEdit.update(start: newTime) 
          : hourToEdit.update(end: newTime)
      );
      BlocProvider.of<HoursConfirmationFormBloc>(context).add(HoursChanged(day: dayIndex, hours: updatedHours));
    });
  }

  void _submitButtonPressed({required BuildContext context, required HoursConfirmationFormState state}) {
    if (!state.isSubmitting) {
      BlocProvider.of<HoursConfirmationFormBloc>(context).add(Submitted(
        sunday: _listHoursToString(context: context, listHours: state.sunday), 
        monday: _listHoursToString(context: context, listHours: state.monday), 
        tuesday: _listHoursToString(context: context, listHours: state.tuesday), 
        wednesday: _listHoursToString(context: context, listHours: state.wednesday), 
        thursday: _listHoursToString(context: context, listHours: state.thursday), 
        friday: _listHoursToString(context: context, listHours: state.friday), 
        saturday: _listHoursToString(context: context, listHours: state.saturday)
      ));
    }
  }

  void _resetForm({required BuildContext context}) {
    Future.delayed(Duration(seconds: 1), () =>  BlocProvider.of<HoursConfirmationFormBloc>(context).add(Reset()));
  }

  String _listHoursToString({required BuildContext context, required List<Hour> listHours}) {
    String stringHours = listHours.fold("", (String previousValue, hour) {
      String formattedPrev = previousValue.length > 0 ? "$previousValue || " : previousValue;
      return "$formattedPrev${hour.start.format(context)} - ${hour.end.format(context)}";
    }).trim();
    return stringHours.length == 0 ? 'closed' : stringHours;
  }

  void _showSuccess({required BuildContext context}) {    
    ToastMessage(
      context: context,
      message: "Hours Saved!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}