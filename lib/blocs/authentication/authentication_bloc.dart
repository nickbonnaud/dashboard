import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final BusinessBloc _businessBloc;

  AuthenticationBloc({required AuthenticationRepository authenticationRepository, required BusinessBloc businessBloc})
    : _authenticationRepository = authenticationRepository,
      _businessBloc = businessBloc,
      super(Unknown()); 

  bool get isAuthenticated => state is Authenticated;

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is Init) {
      yield* _mapInitToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState(event: event);
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapInitToState() async* {
    final bool isSignedIn = _authenticationRepository.isSignedIn();
    // final bool isSignedIn = true;
    if (isSignedIn) {
      _businessBloc.add(BusinessAuthenticated());
      yield Authenticated();
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState({required LoggedIn event}) async* {
    _businessBloc.add(BusinessLoggedIn(business: event.business));
    yield Authenticated();
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    try {
      final bool loggedOut = await _authenticationRepository.logout();
      if (loggedOut) {
        _businessBloc.add(BusinessLoggedOut());
        yield Unauthenticated();
      }
    } catch (error) {
      yield state;
    }
  }
}
