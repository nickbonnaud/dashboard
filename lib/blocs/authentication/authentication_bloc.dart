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
      super(Unknown()) { _eventHandler(); }

  bool get isAuthenticated => state is Authenticated;

  void _eventHandler() {
    on<Init>((event, emit) => _mapInitToState(emit: emit));
    on<LoggedIn>((event, emit) => _mapLoggedInToState(event: event, emit: emit));
    on<LoggedOut>((event, emit) async => await _mapLoggedOutToState(emit: emit));
  }

  void _mapInitToState({required Emitter<AuthenticationState> emit}) {
    final bool isSignedIn = _authenticationRepository.isSignedIn();
    // final bool isSignedIn = true;
    if (isSignedIn) {
      _businessBloc.add(BusinessAuthenticated());
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void _mapLoggedInToState({required LoggedIn event, required Emitter<AuthenticationState> emit}) {
    _businessBloc.add(BusinessLoggedIn(business: event.business));
    emit(Authenticated());
  }

  Future<void> _mapLoggedOutToState({required Emitter<AuthenticationState> emit}) async {
    try {
      final bool loggedOut = await _authenticationRepository.logout();
      if (loggedOut) {
        _businessBloc.add(BusinessLoggedOut());
        emit(Unauthenticated());
      }
    } catch (error) {
      emit(state);
    }
  }
}
