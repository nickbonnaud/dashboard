import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/repositories/hours_repository.dart';
import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/hours_screen/bloc/hours_screen_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/hours_selection_form_bloc.dart';
import 'widgets/hours_confirmation_form.dart';

class HoursSelectionForm extends StatelessWidget {
  final HoursRepository _hoursRepository;
  final BusinessBloc _businessBloc;

  HoursSelectionForm({
    required HoursRepository hoursRepository,
    required BusinessBloc businessBloc,
    Key? key
  })
    : _hoursRepository = hoursRepository,
      _businessBloc = businessBloc,
      super(key: key);
  
  final GlobalKey _gridKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) { 
    return BlocBuilder<HoursSelectionFormBloc, HoursSelectionFormState>(
      builder: (context, state) {
        return _body(context: context, state: state);
      },
    );
  }

  Widget _body({required BuildContext context, required HoursSelectionFormState state}) {
    if (state.isFinished) {
      return HoursConfirmationForm(
        hoursRepository: _hoursRepository,
        businessBloc: _businessBloc
      );
    }
    return Column(
      key: const Key("hoursSelectionFormKey"),
      children: [
        BoldText5(text: "Drag or click to select hours.", context: context),
        TextButton(
          key: const Key("toggleAllButtonKey"),
          child: Text(
            state.operatingHoursGrid.allHoursSelected
              ? "Clear All?"
              : "Select All?",
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              decoration: TextDecoration.underline,
              fontSize: FontSizeAdapter.setSize(size: 2, context: context)
            ),
          ),
          onPressed: () => _toggleAllHours(context: context), 
        ),
        SizedBox(height: SizeConfig.getHeight(2)),
        Container(
          key: const Key("hoursSelectionGrid"),
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            key: _gridKey,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4),
              crossAxisCount: state.operatingHoursGrid.cols,
            ),
            itemCount: state.operatingHoursGrid.cols * state.operatingHoursGrid.rows,
            itemBuilder: (context, index) => _buildGridTimes(context: context, state: state, index: index),
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(3)),
        Row(
          children: [
            SizedBox(width: SizeConfig.getWidth(10)),
            _buttons(context: context),
            SizedBox(width: SizeConfig.getWidth(10)),
          ],
        ),
        SizedBox(height: SizeConfig.getHeight(2)),
      ],
    );
  }

  Widget _buildGridTimes({required BuildContext context, required HoursSelectionFormState state, required int index}) {
    int operatingHoursLength = state.operatingHoursGrid.cols;
    int x, y = 0;
    x = (index / operatingHoursLength).floor();
    y = (index % operatingHoursLength);
    GlobalKey gridTimeKey = GlobalKey();

    return GestureDetector(
      onTapDown: (details) {
        _selectTime(context: context, state: state, gridTimeKey: gridTimeKey, globalPosition: details.globalPosition, isDrag: false);
      },
      onVerticalDragUpdate: (details) {
        _selectTime(context: context, state: state, gridTimeKey: gridTimeKey, globalPosition: details.globalPosition, isDrag: true);
      },
      onHorizontalDragUpdate: (details) {
        _selectTime(context: context, state: state, gridTimeKey: gridTimeKey, globalPosition: details.globalPosition, isDrag: true);
      },
      child: GridTile(
        key: gridTimeKey,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5)
          ),
          child: Center(
            child: _buildGridTime(context: context, state: state, x: x, y: y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridTime({required BuildContext context, required HoursSelectionFormState state, required int x, required int y}) {
    if (x == 0 && y == 0) return Container();
    if (y == 0) return _buildHours(context: context, x: x);
    if (x == 0) return _buildDays(y: y);
    
    return state.operatingHoursGrid.isOpen(x: x, y: y)
      ? Container(key: Key("filled-$x-$y"), color: Theme.of(context).colorScheme.callToAction)
      : Container(key: Key("empty-$x-$y"), color: Colors.white);
  }

  Widget _buildHours({required BuildContext context, required int x}) {
    TimeOfDay startHour = BlocProvider.of<HoursScreenBloc>(context).state.earliestStart!;
    final DateTime now = DateTime.now();
    final DateTime openTime = DateTime(now.year, now.month, now.day, startHour.hour, startHour.minute < 30 ? 0 : 30);

    final DateTime updatedTime = openTime.add(Duration(minutes: 30 * (x - 1)));

    return Text(startHour.replacing(hour: updatedTime.hour, minute: updatedTime.minute).format(context));
  }

  Widget _buildDays({required int y}) {
    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Text(days[y - 1]);
  }

  Widget _buttons({required BuildContext context}) {
    return Expanded(
      child: Row(
        children: [
          Expanded(child: _resetMaxHours(context: context)),
          const SizedBox(width: 20.0),
          Expanded(child: _submitButton(context:  context))
        ],
      )
    );
  }

  Widget _resetMaxHours({required BuildContext context}) {
    return OutlinedButton(
      key: const Key("resetMaxHoursButtonKey"),
      onPressed: () => BlocProvider.of<HoursScreenBloc>(context).add(Reset()),
      child: Text4(text: "Back", context: context, color: Theme.of(context).colorScheme.callToAction),
    );
  }

  Widget _submitButton({required BuildContext context}) {
    return BlocBuilder<HoursSelectionFormBloc, HoursSelectionFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key("submitButtonKey"),
          onPressed: _buttonEnabled(state: state) ? () => _finalizeButtonPressed(context: context, state: state) : null, 
          child: Text4(text: 'Finalize', context: context, color: Theme.of(context).colorScheme.onSecondary),
        );
      },
    );
  }
  
  bool _buttonEnabled({required HoursSelectionFormState state}) {
    return state.operatingHoursGrid.populated;
  }

  void _finalizeButtonPressed({required BuildContext context, required HoursSelectionFormState state}) {
    if (_buttonEnabled(state: state)) {
      BlocProvider.of<HoursSelectionFormBloc>(context).add(const Finished(isFinished: true));
    }
  }
  
  void _selectTime({required BuildContext context, required HoursSelectionFormState state, required GlobalKey<State<StatefulWidget>> gridTimeKey, required Offset globalPosition, required bool isDrag}) {
    final BuildContext? gridTimeKeyContext = gridTimeKey.currentContext;
    final BuildContext? gridKeyContext = _gridKey.currentContext;

    if (gridTimeKeyContext != null && gridKeyContext != null) {
      final RenderBox boxTime = gridTimeKeyContext.findRenderObject() as RenderBox;
      final RenderBox mainGrid = gridKeyContext.findRenderObject() as RenderBox;

      final Offset position = mainGrid.localToGlobal(Offset.zero);
      final double gridLeft = position.dx;
      final double gridTop = position.dy;

      final double gridPosition = globalPosition.dy - gridTop;

      final int indexX = (gridPosition / boxTime.size.height).floor().toInt();
      final int indexY = ((globalPosition.dx - gridLeft) / boxTime.size.width).floor().toInt();

      if ((indexX < state.operatingHoursGrid.rows && indexX >= 0) && (indexY < state.operatingHoursGrid.cols && indexY >= 0)) {
        BlocProvider.of<HoursSelectionFormBloc>(context).add(GridSelectionChanged(indexX: indexX, indexY: indexY, isDrag: isDrag));
      }
    }
  }

  void _toggleAllHours({required BuildContext context}) {
    BlocProvider.of<HoursSelectionFormBloc>(context).add(ToggleAllHours());
  }
}