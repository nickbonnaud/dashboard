import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:dashboard/theme/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/unlocked_form_cubit.dart';
import 'widgets/email_form/bloc/email_form_bloc.dart';
import 'widgets/email_form/email_form.dart';
import 'widgets/password_form/bloc/password_form_bloc.dart';
import 'widgets/password_form/password_form.dart';

class UnlockedForm extends StatefulWidget {
  final BusinessRepository _businessRepository;

  const UnlockedForm({
    required BusinessRepository businessRepository,
    Key? key
  })
    : _businessRepository = businessRepository,
      super(key: key);

  @override
    State<UnlockedForm> createState() => _UnlockedFormState();
}

class _UnlockedFormState extends State<UnlockedForm> {
  final PageController _controller = PageController();
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<UnlockedFormCubit, int>(
      listener: (context, page) {
        page == 1 
          ? _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn)
          : _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _leftChevron(),
            _body(),
            _rightChevron()
          ],
        ),
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _leftChevron() {
    return BlocBuilder<UnlockedFormCubit, int>(
      builder: (context, page) {
        return IconButton(
          icon: const Icon(Icons.chevron_left),
          iconSize: SizeConfig.getWidth(10),
          color: page == 0 
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction,
          onPressed: page == 0 
            ? null 
            : () => context.read<UnlockedFormCubit>().previous(),
        );
      }
    );
  }

  Widget _body() {
    return Expanded(
      child: PageView(
        controller: _controller,
        children: [
          _emailForm(),
          _passwordForm()
        ],
      )
    );
  }

  Widget _emailForm() {
    return BlocProvider<EmailFormBloc>(
      create: (context) => EmailFormBloc(
        businessRepository: widget._businessRepository,
        businessBloc: BlocProvider.of<BusinessBloc>(context)
      ),
      child: const EmailForm(),
    );
  }

  Widget _passwordForm() {
    return BlocProvider<PasswordFormBloc>(
      create: (context) => PasswordFormBloc(
        businessRepository: widget._businessRepository
      ),
      child: const PasswordForm(),
    );
  }

  Widget _rightChevron() {
    return BlocBuilder<UnlockedFormCubit, int>(
      builder: (context, page) {
        return IconButton(
          icon: const Icon(Icons.chevron_right),
          iconSize: SizeConfig.getWidth(10),
          color: page == 1 
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction,
          onPressed: page == 1
            ? null 
            : () => context.read<UnlockedFormCubit>().next(),
        );
      },
    );
  }
}