

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
  final BusinessBloc _businessBloc;
  final String _profileIdentifier;
  final bool _isEdit;

  PhotosForm({
    required PhotoPickerRepository photoPickerRepository, 
    required PhotosRepository photosRepository,
    required BusinessBloc businessBloc,
    required String profileIdentifier,
    required bool isEdit
  })
    : _photoPickerRepository = photoPickerRepository,
      _photosRepository = photosRepository,
      _businessBloc = businessBloc,
      _profileIdentifier = profileIdentifier,
      _isEdit = isEdit;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhotosFormBloc>(
      create: (context) => PhotosFormBloc(
        photosRepository: _photosRepository,
        logoFormBloc: BlocProvider.of<LogoFormBloc>(context),
        bannerFormBloc: BlocProvider.of<BannerFormBloc>(context),
        businessBloc: _businessBloc
      ),
      child: PhotosFormBody(
        photoPickerRepository: _photoPickerRepository, 
        profileIdentifier: _profileIdentifier,
        isEdit: _isEdit,
      ),
    );
  }
}