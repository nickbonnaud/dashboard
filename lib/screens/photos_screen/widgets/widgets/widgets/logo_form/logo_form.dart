import 'package:dashboard/global_widgets/cached_avatar.dart';
import 'package:dashboard/models/photo.dart';
import 'package:dashboard/repositories/photo_picker_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/logo_form_bloc.dart';

class LogoForm extends StatelessWidget {
  final PhotoPickerRepository _photoPickerRepository;

  const LogoForm({required PhotoPickerRepository photoPickerRepository})
    : _photoPickerRepository = photoPickerRepository;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: Key("logoScrollKey"),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.getHeight(5)),
          _logo(context: context),
          SizedBox(height: SizeConfig.getHeight(5)),
          ElevatedButton(
            key: Key("logoPickerButtonKey"),
            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: SizeConfig.getWidth(1), horizontal: SizeConfig.getWidth(4)))),
            onPressed: () =>  _buttonPressed(context: context),
            child: _buttonChild(context: context),
          ),
          SizedBox(height: SizeConfig.getHeight(1)),
        ],
      ),
    );
  }

  Widget _logo({required BuildContext context}) {
    return BlocBuilder<LogoFormBloc, LogoFormState>(
      builder: (context, state) {
        if (state.logoFile != null) {
          return _fileDisplay(logoFile: state.logoFile!);
        }

        return state.initialLogo.largeUrl.isNotEmpty
          ? _initialLogo(logo: state.initialLogo)
          : _placeHolder();
      }
    );
  }

  Widget _fileDisplay({required PickedFile logoFile}) {
    if (logoFile.path.isEmpty) return Container();
    
    return Material(
      key: Key("logoFileDisplayKey"),
      child: Container(
        width: SizeConfig.getWidth(10) * 2,
        height: SizeConfig.getWidth(10) * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(logoFile.path)
          )
        ),
      ),
      elevation: 10,
      shape: CircleBorder(),
    );
  }

  Widget _initialLogo({required Photo logo}) {
    return CachedAvatar(
      url: logo.largeUrl,
      size: SizeConfig.getWidth(10),
    );
  }

  Widget _placeHolder() {
    return Material(
      key: Key("logoPlaceHolderKey"),
      child: CircleAvatar(
        child: Icon(
          Icons.add_business,
          size: SizeConfig.getWidth(10),
          color: Colors.white,
        ),
        radius: SizeConfig.getWidth(10),
        backgroundColor: Colors.black54,
      ),
      elevation: 10,
      shape: CircleBorder(),
    );
  }

  Widget _buttonChild({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Text4(text: 'Select Logo', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  void _buttonPressed({required BuildContext context}) async {
    final PickedFile? logoFile = await _photoPickerRepository.choosePhoto();
    if (logoFile != null) {
      BlocProvider.of<LogoFormBloc>(context).add(LogoPicked(logoFile: logoFile));
    }
  }
}