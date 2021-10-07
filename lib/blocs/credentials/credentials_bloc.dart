import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/blocs/authentication/authentication_bloc.dart';
import 'package:dashboard/models/credentials.dart';
import 'package:dashboard/repositories/credentials_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'credentials_event.dart';
part 'credentials_state.dart';

class CredentialsBloc extends Bloc<CredentialsEvent, CredentialsState> {
  final CredentialsRepository _credentialsRepository;

  late StreamSubscription _authStreamBlocSubscription;

  String? get googleKey => (state as CredentialsLoaded).credentials.googleKey;
  
  CredentialsBloc({required CredentialsRepository credentialsRepository, required AuthenticationBloc authenticationBloc}) 
    : _credentialsRepository = credentialsRepository,
      super(CredentialsInitial()) {

        _eventHandler();
        
        if (authenticationBloc.isAuthenticated) {
          add(Init());
        } else {
          _authStreamBlocSubscription = authenticationBloc.stream.listen((AuthenticationState state) {
            if (state is Authenticated) {
              add(Init());
            }
          });
        }
      }

  void _eventHandler() {
    on<Init>((event, emit) async => await _mapInitToState(emit: emit));
  }

  @override
  Future<void> close() {
    _authStreamBlocSubscription.cancel();
    return super.close();
  }

  Future<void> _mapInitToState({required Emitter<CredentialsState> emit}) async {
    emit(CredentialsLoading());
    try {
      Credentials credentials = await _credentialsRepository.fetch();
      emit(CredentialsLoaded(credentials: credentials));
    } on ApiException catch (exception) {
      emit(FailedToFetchCredentials(error: exception.error));
    }
  }
}
