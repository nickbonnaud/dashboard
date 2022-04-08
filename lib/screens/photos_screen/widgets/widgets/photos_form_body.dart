import 'dart:async';

import 'package:dashboard/global_widgets/shaker.dart';
import 'package:dashboard/repositories/photo_picker_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/resources/helpers/text_styles.dart';
import 'package:dashboard/resources/helpers/toast_message.dart';
import 'package:dashboard/screens/photos_screen/cubit/photos_screen_cubit.dart';
import 'package:dashboard/screens/photos_screen/widgets/bloc/photos_form_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/banner_form/banner_form.dart';
import 'widgets/logo_form/logo_form.dart';

class PhotosFormBody extends StatefulWidget {
  final PhotoPickerRepository _photoPickerRepository;
  final String _profileIdentifier;
  final bool _isEdit;

  const PhotosFormBody({
    required PhotoPickerRepository photoPickerRepository, 
    required String profileIdentifier,
    required bool isEdit,
    Key? key
  })
    : _photoPickerRepository = photoPickerRepository,
      _profileIdentifier = profileIdentifier,
      _isEdit = isEdit,
      super(key: key);

  @override
  State<PhotosFormBody> createState() => _PhotosFormBodyState();
}

class _PhotosFormBodyState extends State<PhotosFormBody> {
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PhotosScreenCubit, int>(
          listener: (context, page) {
            page == 1 
              ? _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn)
              : _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
          }
        ),
        BlocListener<PhotosFormBloc, PhotosFormState>(
          listener: (context, state) {
            if (state.isSuccess) {
              _showSuccessToast();
            }
          }
        )
      ],
      child: Column(
        children: [
          SizedBox(height: SizeConfig.getHeight(5)),
          _title(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _leftChevron(),
                _body(),
                _rightChevron()
              ],
            ),
          ),
          SizedBox(height: SizeConfig.getHeight(5)),
          _errorMessage(),
          Row(
            children: [
              SizedBox(width: SizeConfig.getWidth(10)),
              Expanded(child: _submitButton()),
              SizedBox(width: SizeConfig.getWidth(10)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _title() {
    return BoldText3(text: "Business Logo & Banner", context: context);
  }

  Widget _leftChevron() {
    return BlocBuilder<PhotosScreenCubit, int>(
      builder: (context, page) {
        return IconButton(
          key: const Key("leftChevronKey"),
          icon: const Icon(Icons.chevron_left),
          iconSize: SizeConfig.getWidth(10),
          color: page == 0 
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction,
          onPressed: page == 0 
            ? null 
            : () => context.read<PhotosScreenCubit>().previous(),
        );
      }
    );
  }

  Widget _body() {
    return Expanded(
      child: PageView(
        key: const Key("pageViewKey"),
        controller: _controller,
        children: [
          LogoForm(photoPickerRepository: widget._photoPickerRepository),
          BannerForm(photoPickerRepository: widget._photoPickerRepository)
        ],
      ),
    );
  }

  Widget _rightChevron() {
    return BlocBuilder<PhotosScreenCubit, int>(
      builder: (context, page) {
        return IconButton(
          key: const Key("rightChevronKey"),
          icon: const Icon(Icons.chevron_right),
          iconSize: SizeConfig.getWidth(10),
          color: page == 1 
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction,
          onPressed: page == 1
            ? null 
            : () => context.read<PhotosScreenCubit>().next(),
        );
      },
    );
  }

  Widget _errorMessage() {
    return BlocBuilder<PhotosFormBloc, PhotosFormState>(
      builder: (context, state) {
        if (state.errorMessage.isEmpty) return Container();

        return Column(
          children: [
            Text4(text: state.errorMessage, context: context, color: Theme.of(context).colorScheme.danger),
            SizedBox(height: SizeConfig.getHeight(2)),
          ],
        );
      },
    );
  }
  
  Widget _submitButton() {
    return BlocBuilder<PhotosFormBloc, PhotosFormState>(
      builder: (context, state) {
        return Shaker(
          control: state.errorButtonControl,
          onAnimationComplete: () => _resetForm(),
          child: ElevatedButton(
            key: const Key("submitButtonKey"),
            onPressed: _buttonEnabled(state: state) ? () => _submitButtonPressed(state: state) : null,
            child: _buttonChild(state: state),
          )
        );
      }
    );
  }

  Widget _buttonChild({required PhotosFormState state}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5), 
      child: state.isSubmitting
        ? const CircularProgressIndicator()
        : Text4(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary)
    );
  }

  bool _buttonEnabled({required PhotosFormState state}) {
    if (widget._isEdit) {
      return state.bannerFile != null || state.logoFile != null;
    }
    return state.photosValid;
  }

  void _submitButtonPressed({required PhotosFormState state}) {
    if (_buttonEnabled(state: state)) {
      BlocProvider.of<PhotosFormBloc>(context).add(Submitted(identifier: widget._profileIdentifier));
    }
  }

  void _resetForm() {
    Future.delayed(const Duration(seconds: 1), () => BlocProvider.of<PhotosFormBloc>(context).add(Reset()));
  }

  void _showSuccessToast() {
    ToastMessage(
      context: context,
      message: "Photos Saved!",
      color: Theme.of(context).colorScheme.success
    ).showToast().then((_) => Navigator.of(context).pop());
  }
}