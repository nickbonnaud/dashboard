import 'dart:async';

import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/providers/business_provider.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/repositories/token_repository.dart';
import 'package:dashboard/resources/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/theme/global_colors.dart';

import 'cubit/unlocked_form_cubit.dart';
import 'widgets/email_form/bloc/email_form_bloc.dart';
import 'widgets/email_form/email_form.dart';
import 'widgets/password_form/bloc/password_form_bloc.dart';
import 'widgets/password_form/password_form.dart';

class UnlockedForm extends StatefulWidget {

  @override
    State<UnlockedForm> createState() => _UnlockedFormState();
}

class _UnlockedFormState extends State<UnlockedForm> {
  final PageController _controller = PageController();
  final BusinessRepository _businessRepository = BusinessRepository(businessProvider: BusinessProvider(), tokenRepository: TokenRepository());
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<UnlockedFormCubit, int>(
      listener: (context, page) {
        page == 1 
          ? _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn)
          : _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _leftChevron(),
          _body(),
          _rightChevron()
        ],
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _leftChevron() {
    return FutureBuilder(
      future: _initializeController(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return BlocBuilder<UnlockedFormCubit, int>(
          builder: (context, page) {
            return IconButton(
              icon: Icon(Icons.chevron_left),
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
        businessRepository: _businessRepository,
        businessBloc: BlocProvider.of<BusinessBloc>(context)
      ),
      child: EmailForm(email: BlocProvider.of<BusinessBloc>(context).business.email),
    );
  }

  Widget _passwordForm() {
    return BlocProvider<PasswordFormBloc>(
      create: (context) => PasswordFormBloc(
        businessRepository: _businessRepository
      ),
      child: PasswordForm(),
    );
  }

  Widget _rightChevron() {
    return FutureBuilder(
      future: _initializeController(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return BlocBuilder<UnlockedFormCubit, int>(
          builder: (context, page) {
            return IconButton(
              icon: Icon(Icons.chevron_right),
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
      },
    );
  }

  Future<bool> _initializeController() {
    Completer<bool> completer = new Completer<bool>();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      completer.complete(true);
    });

    return completer.future;
  }
}