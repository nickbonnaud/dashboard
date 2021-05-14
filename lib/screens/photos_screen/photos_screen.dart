import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/repositories/photo_picker_repository.dart';
import 'package:dashboard/repositories/photos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/photos_screen_cubit.dart';
import 'widgets/photos_form.dart';
import 'widgets/widgets/widgets/banner_form/bloc/banner_form_bloc.dart';
import 'widgets/widgets/widgets/logo_form/bloc/logo_form_bloc.dart';

class PhotosScreen extends StatelessWidget {
  final PhotoPickerRepository _photoPickerRepository;
  final PhotosRepository _photosRepository;
  final BusinessBloc _businessBloc;
  final Photos _photos;
  final String _profileIdentifier;

  const PhotosScreen({
    required PhotoPickerRepository photoPickerRepository,
    required PhotosRepository photosRepository,
    required BusinessBloc businessBloc,
    required Photos photos,
    required String profileIdentifier
  })
    : _photoPickerRepository = photoPickerRepository,
      _photosRepository = photosRepository,
      _businessBloc = businessBloc,
      _photos = photos,
      _profileIdentifier = profileIdentifier;
  
  @override
  Widget build(BuildContext context) {
    return _isEdit()
      ? Scaffold(
          appBar: DefaultAppBar(context: context),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _photosForm()
        )
      : Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          ),
          body: _photosForm()
        );
  }

  bool _isEdit() {
    return _photos.logo.name.isNotEmpty &&_photos.banner.name.isNotEmpty;
  }

  Widget _photosForm() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotosScreenCubit>(
          create: (_) => PhotosScreenCubit(), 
        ),
        BlocProvider<LogoFormBloc>(
          create: (_) => LogoFormBloc(logo: _photos.logo),
        ),
        BlocProvider<BannerFormBloc>(
          create: (_) => BannerFormBloc(banner: _photos.banner)
        )
      ],
      child: SingleChildScrollView(
        key: Key("mainScrollKey"),
        child: PhotosForm(
          photoPickerRepository: _photoPickerRepository,
          photosRepository: _photosRepository,
          businessBloc: _businessBloc,
          profileIdentifier: _profileIdentifier,
          isEdit: _isEdit(),
        )
      )
    );
  }
}