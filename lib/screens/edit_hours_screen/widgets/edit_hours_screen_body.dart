import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/hour.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/edit_hours_screen/bloc/edit_hours_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';


class EditHoursScreenBody extends StatelessWidget {
  final List<String> _days = const ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  final Hours _hours;

  const EditHoursScreenBody({required Hours hours, Key? key})
    : _hours = hours,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditHoursScreenBloc, EditHoursScreenState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess(context: context);
        }
      },
      child: SingleChildScrollView(
        key: const Key("scrollKey"),
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.getWidth(4),
            right: SizeConfig.getWidth(4),
          ),
          child: Column(
            children: [
              BoldText4(text: "Change Operating Hours.", context: context),
              BoldText5(text: "Select individual hours to edit.", context: context),
              SizedBox(height: SizeConfig.getHeight(2)),
              _hoursList(context: context),
              _errorMessage(),
              SizedBox(height: SizeConfig.getHeight(4)),
              Row(
                children: [
                  SizedBox(width: SizeConfig.getWidth(10)),
                  Expanded(
                    child: _submitButton()
                  ),
                  SizedBox(width: SizeConfig.getWidth(10)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _hoursList({required BuildContext context}) {
    return BlocBuilder<EditHoursScreenBloc, EditHoursScreenState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            state.days.length,
            (index) => _createDay(
              context: context,
              dayIndex: index,
              state: state
            )
          ),
        );
      }
    );
  }

  Widget _createDay({required BuildContext context, required int dayIndex, required EditHoursScreenState state}) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.getHeight(3)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _addRemoveHoursButtons(context: context, state: state, dayIndex: dayIndex),
              SizedBox(width: SizeConfig.getWidth(3)),
              Text4(text: "${_days[dayIndex]}:", context: context),
              SizedBox(width: SizeConfig.getWidth(1)),
              _hoursRow(context: context, state: state, dayIndex: dayIndex),
            ],
          ),
        )
      ],
    );
  }

  Widget _hoursRow({required BuildContext context, required EditHoursScreenState state, required int dayIndex}) {
    if (state.days[dayIndex].isEmpty) {
      return Text4(text: 'Closed', context: context);
    }
    return Row(
      key: Key(_days[dayIndex]),
      children: List.generate(
        state.days[dayIndex].length, 
        (index) => _createHour(context: context, hourIndex: index, day: state.days[dayIndex], dayIndex: dayIndex)
      )
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

  Widget _addRemoveHoursButtons({required BuildContext context, required EditHoursScreenState state, required int dayIndex}) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.add_circle, 
            color: Theme.of(context).colorScheme.success,
            size: SizeConfig.getWidth(2.5),
          ), 
          onPressed: () => _addHourButtonPressed(context: context, dayIndex: dayIndex)
        ),
        IconButton(
          icon: Icon(
            Icons.do_disturb_on_rounded, 
            color: state.days[dayIndex].isEmpty 
              ? Theme.of(context).colorScheme.dangerDisabled 
              : Theme.of(context).colorScheme.danger,
            size: SizeConfig.getWidth(2.5),
          ), 
          onPressed: state.days[dayIndex].isEmpty 
            ? null 
            : () => _removeHourButtonPressed(context: context, dayIndex: dayIndex)
        )
      ]
    );
  }

  Widget _submitButton() {
    return BlocBuilder<EditHoursScreenBloc, EditHoursScreenState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl,
          onAnimationComplete: () => _resetForm(context: context),
          child: ElevatedButton(
            key: const Key("submitButtonKey"),
            onPressed: _buttonEnabled(context: context, state: state) ? () => _submitButtonPressed(context: context, state: state) : null, 
            child: _buttonChild(context: context, state: state)
          )
        );
      }
    );
  }

  Widget _buttonChild({required BuildContext context, required EditHoursScreenState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Update', context: context, color: Theme.of(context).colorScheme.onSecondary),
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<EditHoursScreenBloc, EditHoursScreenState>(
      builder: (context, state) {
        if (!state.isFailure) return Container();

        return Column(
          children: [
            SizedBox(height: SizeConfig.getHeight(2)),
            TextCustom(text: state.errorMessage, size: SizeConfig.getWidth(2), context: context, color: Theme.of(context).colorScheme.danger)
          ],
        );
      }
    );
  }

  bool _buttonEnabled({required BuildContext context, required EditHoursScreenState state}) {
    return !state.isSubmitting && _hoursChanged(context: context, state: state);
  }

  bool _hoursChanged({required BuildContext context, required EditHoursScreenState state}) {
    bool hoursChanged = false;
    state.days.asMap().forEach((index, listHours) {
      if (_listHoursToString(context: context, listHours: listHours) != _hours.days[index]) {
        hoursChanged = true;
      }
    });
    return hoursChanged;
  }

  void _resetForm({required BuildContext context}) {
    Future.delayed(const Duration(seconds: 1), () => BlocProvider.of<EditHoursScreenBloc>(context).add(Reset()));
  }

  void _editHourButtonPressed({required BuildContext context, required int hourIndex, required List<Hour> day, required bool isOpenHour, required int dayIndex}) async {
    final Hour hourToEdit = day[hourIndex];
    showTimePicker(
      context: context, 
      initialTime: isOpenHour ? hourToEdit.start : hourToEdit.end,
      cancelText: 'Cancel',
      confirmText: "Change",
      helpText: "Edit Operating Hour",
      builder: (context, child) => Theme(data: ThemeData.light(), child: child!)
    ).then((newTime) {
      if (newTime != null) {
        List<Hour> updatedHours = day.where(
          (hour) => hour != hourToEdit
        ).toList()
        ..add(
          isOpenHour 
            ? hourToEdit.update(start: newTime) 
            : hourToEdit.update(end: newTime)
        );
        BlocProvider.of<EditHoursScreenBloc>(context).add(HoursChanged(day: dayIndex, hours: updatedHours));
      }
    });
  }

  void _addHourButtonPressed({required BuildContext context, required int dayIndex}) async {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      cancelText: 'Cancel',
      confirmText: "Set",
      helpText: "Add Hour",
      builder: (context, child) => Theme(data: ThemeData.light(), child: child!)
    ).then((startHour) {
      if (startHour != null) {
        BlocProvider.of<EditHoursScreenBloc>(context).add(HourAdded(
          hour: Hour(start: startHour, end: TimeOfDay(hour: startHour.hour + 1, minute: startHour.minute)), 
          day: dayIndex
        ));
      }
    });
  }

  void _removeHourButtonPressed({required BuildContext context, required int dayIndex}) {
    BlocProvider.of<EditHoursScreenBloc>(context).add(HourRemoved(day: dayIndex));
  }

  void _submitButtonPressed({required BuildContext context, required EditHoursScreenState state}) {
    if (_buttonEnabled(context: context, state: state)) {
      BlocProvider.of<EditHoursScreenBloc>(context).add(Updated(
        identifier: _hours.identifier,
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

  String _listHoursToString({required BuildContext context, required List<Hour> listHours}) {
    String stringHours = listHours.fold("", (String previousValue, hour) {
      String formattedPrev = previousValue.isNotEmpty ? "$previousValue || " : previousValue;
      return "$formattedPrev${hour.start.format(context)} - ${hour.end.format(context)}";
    }).trim();
    return stringHours.isEmpty ? 'closed' : stringHours;
  }
  
  void _showSuccess({required BuildContext context}) {
    ToastMessage(
      context: context,
      message: "Hours Updated!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}