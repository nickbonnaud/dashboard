import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/constants.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:rxdart/rxdart.dart';

part 'owner_form_event.dart';
part 'owner_form_state.dart';

class OwnerFormBloc extends Bloc<OwnerFormEvent, OwnerFormState> {
  final OwnerRepository _ownerRepository;
  final OwnersScreenBloc _ownersScreenBloc;
  
  OwnerFormBloc({
    required OwnerRepository ownerRepository,
    required OwnersScreenBloc ownersScreenBloc
  })
    : _ownerRepository = ownerRepository,
      _ownersScreenBloc = ownersScreenBloc,
      super(OwnerFormState.empty());

  @override
  Stream<Transition<OwnerFormEvent, OwnerFormState>> transformEvents(Stream<OwnerFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => 
      event is Submitted ||
      event is Updated ||
      event is PrimaryChanged ||
      event is Reset
    );

    final debounceStream = events.where((event) => 
      event is !Submitted &&
      event is !Updated &&
      event is !PrimaryChanged &&
      event is !Reset
    ).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<OwnerFormState> mapEventToState(OwnerFormEvent event) async* {
    if (event is FirstNameChanged) {
      yield* _mapFirstNameChangedToState(event: event);
    } else if (event is LastNameChanged) {
      yield* _mapLastNameChangedToState(event: event);
    } else if (event is TitleChanged) {
      yield* _mapTitleChangedToState(event: event);
    } else if (event is PhoneChanged) {
      yield* _mapPhoneChangedToState(event: event);
    } else if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event: event);
    } else if (event is PrimaryChanged) {
      yield* _mapPrimaryChangedToState(event: event);
    } else if (event is PercentOwnershipChanged) {
      yield* _mapPercentOwnershipChanged(event: event);
    } else if (event is DobChanged) {
      yield* _mapDobChangedToState(event: event);
    } else if (event is SsnChanged) {
      yield* _mapSsnChangedToState(event: event);
    } else if (event is AddressChanged) {
      yield* _mapAddressChangedToState(event: event);
    } else if (event is AddressSecondaryChanged) {
      yield* _mapAddressSecondaryChangedToState(event: event);
    } else if (event is CityChanged) {
      yield* _mapCityChangedToState(event: event);
    } else if (event is StateChanged) {
      yield* _mapStateChangedToState(event: event);
    } else if (event is ZipChanged) {
      yield* _mapZipChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Updated) {
      yield* _mapUpdatedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }
  
  Stream<OwnerFormState> _mapFirstNameChangedToState({required FirstNameChanged event}) async* {
    yield state.update(isFirstNameValid: Validators.isValidFirstName(name: event.firstName));
  }

  Stream<OwnerFormState> _mapLastNameChangedToState({required LastNameChanged event}) async* {
    yield state.update(isLastNameValid: Validators.isValidLastName(name: event.lastName));
  }

  Stream<OwnerFormState> _mapTitleChangedToState({required TitleChanged event}) async* {
    yield state.update(isTitleValid: event.title.length >= 2);
  }

  Stream<OwnerFormState> _mapPhoneChangedToState({required PhoneChanged event}) async* {
    yield state.update(isPhoneValid: Validators.isValidPhone(phone: event.phone));
  }

  Stream<OwnerFormState> _mapEmailChangedToState({required EmailChanged event}) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email: event.email));
  }

  Stream<OwnerFormState> _mapPrimaryChangedToState({required PrimaryChanged event}) async* {    
    yield state.update(isPrimary: event.isPrimary);
  }
  
  Stream<OwnerFormState> _mapPercentOwnershipChanged({required PercentOwnershipChanged event}) async* {
    yield state.update(isPercentOwnershipValid: Validators.isValidPercentOwnership(percent: event.percentOwnership) && _totalAssignedOwnership() + event.percentOwnership <= 100);
  }

  Stream<OwnerFormState> _mapDobChangedToState({required DobChanged event}) async* {
    try {
      DateFormat.yMd().parse(event.dob);
      yield state.update(isDobValid: true);
    } on FormatException catch(_) {
      yield state.update(isDobValid: false);
    }
  }

  Stream<OwnerFormState> _mapSsnChangedToState({required SsnChanged event}) async* {
    yield state.update(isSsnValid: Validators.isValidSsn(ssn: event.ssn));
  }

  Stream<OwnerFormState> _mapAddressChangedToState({required AddressChanged event}) async* {
    yield state.update(isAddressValid: Validators.isValidAddress(address: event.address));
  }

  Stream<OwnerFormState> _mapAddressSecondaryChangedToState({required AddressSecondaryChanged event}) async* {
    yield state.update(isAddressSecondaryValid: Validators.isValidAddressSecondary(address: event.addressSecondary));
  }

  Stream<OwnerFormState> _mapCityChangedToState({required CityChanged event}) async* {
    yield state.update(isCityValid: Validators.isValidCity(city: event.city));
  }

  Stream<OwnerFormState> _mapStateChangedToState({required StateChanged event}) async* {
    yield state.update(isStateValid: Constants.states.contains(event.state.toUpperCase()));
  }

  Stream<OwnerFormState> _mapZipChangedToState({required ZipChanged event}) async* {
    yield state.update(isZipValid: Validators.isValidZip(zip: event.zip));
  }

  Stream<OwnerFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      OwnerAccount account = await _ownerRepository.store(
        firstName: event.firstName,
        lastName: event.lastName,
        title: event.title,
        phone: event.phone,
        email: event.email,
        primary: event.primary,
        percentOwnership: int.parse(event.percentOwnership),
        dob: event.dob,
        ssn: event.ssn,
        address: event.address,
        addressSecondary: event.addressSecondary,
        city: event.city,
        state: event.state.toUpperCase(),
        zip: event.zip
      );
      _ownersScreenBloc.add(OwnerAdded(owner: account));
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<OwnerFormState> _mapUpdatedToState({required Updated event}) async* {
    yield state.update(isSubmitting: true);

     try {
      OwnerAccount account = await _ownerRepository.update(
        identifier: event.identifier,
        firstName: event.firstName,
        lastName: event.lastName,
        title: event.title,
        phone: event.phone,
        email: event.email,
        primary: event.primary,
        percentOwnership: int.parse(event.percentOwnership),
        dob: event.dob,
        ssn: event.ssn,
        address: event.address,
        addressSecondary: event.addressSecondary,
        city: event.city,
        state: event.state.toUpperCase(),
        zip: event.zip
      );
      _ownersScreenBloc.add(OwnerUpdated(owner: account));
      yield state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.STOP);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.PLAY_FROM_START);
    }
  }

  Stream<OwnerFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.STOP);
  }

  int _totalAssignedOwnership() {
    return _ownersScreenBloc.owners.fold(0, (totalAssigned, owner) => totalAssigned + owner.percentOwnership);
  }
}
