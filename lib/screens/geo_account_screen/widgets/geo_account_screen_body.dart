import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/geo_account_screen/bloc/geo_account_screen_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoAccountScreenBody extends StatelessWidget {
  final Location _location;
  final bool _isEdit;

  const GeoAccountScreenBody({required Location location, required bool isEdit, Key? key})
    : _location = location,
      _isEdit = isEdit,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<GeoAccountScreenBloc, GeoAccountScreenState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccess(context: context);
        }
      },
      child: SingleChildScrollView(
        key: const Key("scrollKey"),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.getHeight(5)),
            _title(context: context),
            SizedBox(height: SizeConfig.getHeight(5)),
            _map(),
            SizedBox(height: SizeConfig.getHeight(3)),
            _slider(context: context),
            _errorMessage(),
            SizedBox(height: SizeConfig.getHeight(5)),
            Row(
              children: [
                SizedBox(width: SizeConfig.getWidth(10)),
                Expanded(child: _submitButton()),
                SizedBox(width: SizeConfig.getWidth(10)),
              ],
            ),
            SizedBox(height: SizeConfig.getHeight(2)),
          ],
        ),
      ),
    );
  }

  Widget _title({required BuildContext context}) {
    return Column(
      key: const Key("titleKey"),
      children: [
        BoldText3(text: 'Business Location & Geofence', context: context),
        Text5(text: 'Please ensure location is correct and geofence encircles business.', context: context)
      ],
    );
  }

  Widget _map() {
    return BlocBuilder<GeoAccountScreenBloc, GeoAccountScreenState>(
      builder: (context, state) {
        return SizedBox(
          height: SizeConfig.getWidth(40),
          width: SizeConfig.getWidth(40),
          child: GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: state.initialLocation,
              zoom: 18
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer()
              )
            },
            markers: _businessMarker(context: context, state: state),
            circles: _geoFence(context: context, state: state),
          )
        );
      }
    );
  }

  Widget _slider({required BuildContext context}) {
    return Column(
      children: [
        BoldText5(text: 'Geofence Size', context: context),
        BlocBuilder<GeoAccountScreenBloc, GeoAccountScreenState>(
          builder: (context, state) {
            return SizedBox(
              width: SizeConfig.getWidth(40),
              child: Slider(
                value: state.radius,
                min: 10,
                max: 200,
                onChanged: (radius) => BlocProvider.of<GeoAccountScreenBloc>(context).add(RadiusChanged(radius: radius)),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _submitButton() {
    return BlocBuilder<GeoAccountScreenBloc, GeoAccountScreenState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl,
          onAnimationComplete: () => _resetForm(context: context),
          child: ElevatedButton(
            key: const Key("submitButtonKey"),
            onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(context: context, state: state) : null,
            child: _buttonChild(context: context, state: state),
          )
        );
      }
    );
  }

  Widget _buttonChild({required BuildContext context, required GeoAccountScreenState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<GeoAccountScreenBloc, GeoAccountScreenState>(
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

  Set<Marker> _businessMarker({required BuildContext context, required GeoAccountScreenState state}) {
    return {Marker(
      markerId: const MarkerId("markerId"),
      position: state.currentLocation,
      draggable: true,
      onDragEnd: (latLng) => BlocProvider.of<GeoAccountScreenBloc>(context).add(LocationChanged(location: latLng)),
    )};
  }

  Set<Circle> _geoFence({required BuildContext context, required GeoAccountScreenState state}) {
    return {Circle(
      circleId: const CircleId("circleId"),
      center: state.currentLocation,
      radius: state.radius,
      strokeColor: Theme.of(context).colorScheme.callToAction
    )};
  }

  bool _buttonEnabled({required GeoAccountScreenState state}) {
    return !state.isSubmitting && _fieldsChanged(state: state);
  }

  bool _fieldsChanged({required GeoAccountScreenState state}) {
    if (!_isEdit) return true;

    return state.initialLocation != state.currentLocation || state.initialRadius != state.radius;
  }
  
  void _resetForm({required BuildContext context}) {
    Future.delayed(const Duration(seconds: 1), () => BlocProvider.of<GeoAccountScreenBloc>(context).add(Reset()));
  }

  void _submitButtonPressed({required BuildContext context, required GeoAccountScreenState state}) {
    if (_buttonEnabled(state: state)) {
      _isEdit 
        ? BlocProvider.of<GeoAccountScreenBloc>(context).add(Updated(identifier: _location.identifier))
        : BlocProvider.of<GeoAccountScreenBloc>(context).add(Submitted());
    }
  }

  void _showSuccess({required BuildContext context}) {    
    ToastMessage(
      context: context,
      message: "Location Saved!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}