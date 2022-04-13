import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
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

  const PhotosScreen({
    required PhotoPickerRepository photoPickerRepository,
    required PhotosRepository photosRepository,
    Key? key
  })
    : _photoPickerRepository = photoPickerRepository,
      _photosRepository = photosRepository,
      super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _photosForm(context: context),
      appBar: _isEdit(context: context)
        ? DefaultAppBar(context: context)
        : AppBar(
            leading: Container(),
            backgroundColor: Theme.of(context).colorScheme.secondary
          )
    );
  }

  bool _isEdit({required BuildContext context}) {
    return BlocProvider.of<BusinessBloc>(context).business.photos.logo.name.isNotEmpty && BlocProvider.of<BusinessBloc>(context).business.photos.banner.name.isNotEmpty;
  }

  Widget _photosForm({required BuildContext context}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotosScreenCubit>(
          create: (_) => PhotosScreenCubit(), 
        ),
        BlocProvider<LogoFormBloc>(
          create: (_) => LogoFormBloc(logo: BlocProvider.of<BusinessBloc>(context).business.photos.logo),
        ),
        BlocProvider<BannerFormBloc>(
          create: (_) => BannerFormBloc(banner: BlocProvider.of<BusinessBloc>(context).business.photos.banner)
        )
      ],
      child: SingleChildScrollView(
        key: const Key("mainScrollKey"),
        child: PhotosForm(
          photoPickerRepository: _photoPickerRepository,
          photosRepository: _photosRepository,
        )
      )
    );
  }
}