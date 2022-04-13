

import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/repositories/photo_picker_repository.dart';
import 'package:dashboard/repositories/photos_repository.dart';
import 'package:dashboard/screens/photos_screen/widgets/bloc/photos_form_bloc.dart';
import 'package:dashboard/screens/photos_screen/widgets/widgets/photos_form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/widgets/banner_form/bloc/banner_form_bloc.dart';
import 'widgets/widgets/logo_form/bloc/logo_form_bloc.dart';

class PhotosForm extends StatelessWidget {
  final PhotoPickerRepository _photoPickerRepository;
  final PhotosRepository _photosRepository;

  const PhotosForm({
    required PhotoPickerRepository photoPickerRepository, 
    required PhotosRepository photosRepository,
    Key? key
  })
    : _photoPickerRepository = photoPickerRepository,
      _photosRepository = photosRepository,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhotosFormBloc>(
      create: (context) => PhotosFormBloc(
        photosRepository: _photosRepository,
        logoFormBloc: BlocProvider.of<LogoFormBloc>(context),
        bannerFormBloc: BlocProvider.of<BannerFormBloc>(context),
        businessBloc: BlocProvider.of<BusinessBloc>(context)
      ),
      child: _isEdit(context: context)
        ? PhotosFormBody.edit(
            photoPickerRepository: _photoPickerRepository, 
          )
        : PhotosFormBody.new(
            photoPickerRepository: _photoPickerRepository, 
          )
    );
  }

  bool _isEdit({required BuildContext context}) {
    return BlocProvider.of<BusinessBloc>(context).business.photos.logo.name.isNotEmpty && BlocProvider.of<BusinessBloc>(context).business.photos.banner.name.isNotEmpty;
  }
}