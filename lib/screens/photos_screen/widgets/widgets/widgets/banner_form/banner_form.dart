import 'package:dashboard/global_widgets/cached_image.dart';
import 'package:dashboard/models/photo.dart';
import 'package:dashboard/repositories/photo_picker_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/banner_form_bloc.dart';

class BannerForm extends StatelessWidget {

  const BannerForm({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const Key("bannerScrollKey"),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.getHeight(5)),
          _banner(context: context),
          SizedBox(height: SizeConfig.getHeight(5)),
          ElevatedButton(
            key: const Key("bannerPickerButtonKey"),
            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: SizeConfig.getWidth(1), horizontal: SizeConfig.getWidth(4)))),
            onPressed: () => _buttonPressed(context: context),
            child: _buttonChild(context: context),
          ),
          SizedBox(height: SizeConfig.getHeight(1)),
        ],
      ),
    );
  }

  Widget _banner({required BuildContext context}) {
    return BlocBuilder<BannerFormBloc, BannerFormState>(
      builder: (context, state) {
        if (state.bannerFile != null) {
          return _fileDisplay(bannerFile: state.bannerFile!);
        }

        return state.initialBanner.largeUrl.isNotEmpty
          ? _initialBanner(banner: state.initialBanner)
          : _placeHolder();
      }
    );
  }

  Widget _fileDisplay({required XFile bannerFile}) {
    if (bannerFile.path.isEmpty) return Container();
    
    return Material(
      child: Container(
        width: Size(SizeConfig.getWidth(30), SizeConfig.getWidth(20)).width,
        height: Size(SizeConfig.getWidth(30), SizeConfig.getWidth(20)).height,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(bannerFile.path)
          )
        ),
      ),
      elevation: 10,
      shape: const ContinuousRectangleBorder(),
    );
  }

  Widget _initialBanner({required Photo banner}) {
    return CachedImage(
      url: banner.largeUrl,
      size: Size(SizeConfig.getWidth(30), SizeConfig.getWidth(20))
    );
  }

  Widget _placeHolder() {
    return Material(
      key: const Key("bannerPlaceHolderKey"),
      child: Container(
        color: Colors.black54,
        width: SizeConfig.getWidth(30),
        child: Icon(
          Icons.add_photo_alternate,
          size: SizeConfig.getWidth(25),
          color: Colors.white,
        ),
      ),
      elevation: 10,
    );
  }

  Widget _buttonChild({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Text4(text: 'Select Banner', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  void _buttonPressed({required BuildContext context}) async {
    final XFile? bannerFile = await RepositoryProvider.of<PhotoPickerRepository>(context).choosePhoto();
    if (bannerFile != null) {
      BlocProvider.of<BannerFormBloc>(context).add(BannerPicked(bannerFile: bannerFile));
    }
  }
}