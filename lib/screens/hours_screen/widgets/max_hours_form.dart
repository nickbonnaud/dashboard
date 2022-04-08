import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/responsive_layout_helper.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/hours_screen/bloc/hours_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MaxHoursForm extends StatefulWidget {
  final Hours _hours;

  const MaxHoursForm({required Hours hours, Key? key})
    : _hours = hours,
      super(key: key);
      

  @override
  State<MaxHoursForm> createState() => _MaxHoursFormState();
}

class _MaxHoursFormState extends State<MaxHoursForm> {
  final FocusNode _openingTimeFocus = FocusNode();
  final FocusNode _closingTimeFocus = FocusNode();

  final ResponsiveLayoutHelper _layoutHelper = ResponsiveLayoutHelper();

  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;
  
  @override
  void initState() {
    super.initState();
    _openingTimeController = TextEditingController(text: _getEarliestOpening());
    _closingTimeController = TextEditingController(text: _getLatestClosing());
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.getWidth(10),
          right: SizeConfig.getWidth(10)
        ),
        child: Column(
          children: [
            BoldText5(text: 'Please set the earliest and latest time your business is open.', context: context),
            SizedBox(height: SizeConfig.getHeight(3)),
            ResponsiveRowColumn(
              layout: _layoutHelper.setLayout(context: context),
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisSize: MainAxisSize.min,
              columnSpacing: SizeConfig.getHeight(3),
              rowSpacing: SizeConfig.getWidth(5),
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit: FlexFit.tight,
                  child: _openingTimeTextField(),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  rowFit: FlexFit.tight,
                  child: _closingTimeTextField(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _openingTimeController.dispose();
    _openingTimeFocus.dispose();

    _closingTimeController.dispose();
    _closingTimeFocus.dispose();
    super.dispose();
  }

  Widget _openingTimeTextField() {
    return TextFormField(
      key: const Key("openingTimeFieldKey"),
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        labelText: 'Earliest opening time',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      controller: _openingTimeController,
      focusNode: _openingTimeFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _openingTimeFocus.unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
      onTap:
        () => _onFieldTapped(isOpening: true)
        .then((time) {
          if (time != null) {
            _openingTimeController.text = time.format(context);
            BlocProvider.of<HoursScreenBloc>(context).add(EarliestOpeningChanged(time: time));
          }
        }),
    );
  }

  Widget _closingTimeTextField() {
    return TextFormField(
      key: const Key("closingTimeFieldKey"),
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(
        labelText: 'Latest closing time',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: FontSizeAdapter.setSize(size: 3, context: context)
        ),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: FontSizeAdapter.setSize(size: 3, context: context)
      ),
      controller: _closingTimeController,
      focusNode: _closingTimeFocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _openingTimeFocus.unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: false,
      onTap:
        () => _onFieldTapped(isOpening: true)
        .then((time) {
          if (time != null) {
            _closingTimeController.text = time.format(context);
            BlocProvider.of<HoursScreenBloc>(context).add(LatestClosingChanged(time: time));
          }
        }),
    );
  }

  String _getEarliestOpening() {
    return widget._hours.empty
      ? ""
      : widget._hours.earliest;
  }

  String _getLatestClosing() {
    return widget._hours.empty
      ? ""
      : widget._hours.latest;
  }

  Future<TimeOfDay?> _onFieldTapped({required bool isOpening}) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      cancelText: "Cancel",
      confirmText: "Set",
      helpText: isOpening ? 'Set earliest opening' : 'Set latest closing',
      builder: (context, child) {
        return Theme(
          key: const Key("timePickerKey"),
          data: ThemeData.light(),
          child: child!,
        );
      }
    );
  }
}