import 'package:dashboard/resources/helpers/font_size_adapter.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/screens/profile_screen/bloc/profile_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:dashboard/theme/global_colors.dart';

class PlaceForm extends StatefulWidget {

  const PlaceForm({Key? key})
    : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  final TextEditingController _placeQueryController = TextEditingController();
  final FocusNode _placeQueryFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _placeQueryController.addListener(_onPlaceQueryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          key: const Key("placeNameFieldKey"),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: 'Business Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontSizeAdapter.setSize(size: 3, context: context)
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: FontSizeAdapter.setSize(size: 3, context: context)
          ),
          controller: _placeQueryController,
          focusNode: _placeQueryFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          autocorrect: false,
        ),
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.getWidth(10), right: SizeConfig.getWidth(10)),
          child: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
            builder: (context, state) {
              return state.isSubmitting 
                ? _loadingIndicator() 
                : _predictions(state: state);
            }
          ) 
        )
      ],
    );
  }

  @override
  void dispose() {
    _placeQueryController.dispose();
    _placeQueryFocus.dispose();
    super.dispose();
  }

  Widget _loadingIndicator() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.getHeight(5)),
        CircularProgressIndicator(color: Theme.of(context).colorScheme.callToAction)
      ]
    );
  }
  
  Widget _predictions({required ProfileScreenState state}) {
    if (state.predictions.isNotEmpty) {
      return Column(
        key: const Key("predictionsListKey"),
        children: [
          SizedBox(height: SizeConfig.getHeight(5)),
          BoldText5(text: 'Please select your business.', context: context),
          SizedBox(height: SizeConfig.getHeight(2)),
          ListBody(
            children: state.predictions.map((prediction) => prediction.description != null
              ? ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(prediction.description!),
                  onTap: () => _onPredictionSelected(prediction: prediction),
                  hoverColor: Theme.of(context).colorScheme.callToActionDisabled,
                )
              : Container()
            ).toList()
              
          )
        ]
      );
    }
    return Container();
  }

  void _onPredictionSelected({required Prediction prediction}) {
    BlocProvider.of<ProfileScreenBloc>(context).add(PredictionSelected(prediction: prediction));
  }

  void _onPlaceQueryChanged() {
    BlocProvider.of<ProfileScreenBloc>(context).add(PlaceQueryChanged(query: _placeQueryController.text));
  }
}