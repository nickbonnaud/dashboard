import 'package:bloc/bloc.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/repositories/owner_repository.dart';
import 'package:dashboard/resources/constants.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/resources/helpers/debouncer.dart';
import 'package:dashboard/resources/helpers/validators.dart';
import 'package:dashboard/screens/owners_screen/bloc/owners_screen_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:simple_animations/simple_animations.dart';

part 'owner_form_event.dart';
part 'owner_form_state.dart';

class OwnerFormBloc extends Bloc<OwnerFormEvent, OwnerFormState> {
  final OwnerRepository _ownerRepository;
  final OwnersScreenBloc _ownersScreenBloc;
  final OwnerAccount? _ownerAccount;

  final Duration _debounceTime = const Duration(milliseconds: 300); 
  
  OwnerFormBloc({
    required OwnerRepository ownerRepository,
    required OwnersScreenBloc ownersScreenBloc,
    OwnerAccount? ownerAccount
  })
    : _ownerRepository = ownerRepository,
      _ownersScreenBloc = ownersScreenBloc,
      _ownerAccount = ownerAccount,
      super(OwnerFormState.empty(ownerAccount: ownerAccount)) { _eventHandler(); }

  void _eventHandler() {
    on<FirstNameChanged>((event, emit) => _mapFirstNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<LastNameChanged>((event, emit) => _mapLastNameChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<TitleChanged>((event, emit) => _mapTitleChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PhoneChanged>((event, emit) => _mapPhoneChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<EmailChanged>((event, emit) => _mapEmailChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PercentOwnershipChanged>((event, emit) => _mapPercentOwnershipChanged(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<DobChanged>((event, emit) => _mapDobChangedToState(event: event, emit: emit));
    on<SsnChanged>((event, emit) => _mapSsnChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<AddressChanged>((event, emit) => _mapAddressChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<AddressSecondaryChanged>((event, emit) => _mapAddressSecondaryChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<CityChanged>((event, emit) => _mapCityChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<StateChanged>((event, emit) => _mapStateChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<ZipChanged>((event, emit) => _mapZipChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: _debounceTime));
    on<PrimaryChanged>((event, emit) => _mapPrimaryChangedToState(event: event, emit: emit));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Updated>((event, emit) async => await _mapUpdatedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }
  
  void _mapFirstNameChangedToState({required FirstNameChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(firstName: event.firstName, isFirstNameValid: Validators.isValidFirstName(name: event.firstName)));
  }

  void _mapLastNameChangedToState({required LastNameChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(lastName: event.lastName, isLastNameValid: Validators.isValidLastName(name: event.lastName)));
  }

  void _mapTitleChangedToState({required TitleChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(title: event.title, isTitleValid: event.title.length >= 2));
  }

  void _mapPhoneChangedToState({required PhoneChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(phone: event.phone, isPhoneValid: Validators.isValidPhone(phone: event.phone)));
  }

  void _mapEmailChangedToState({required EmailChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(email: event.email, isEmailValid: Validators.isValidEmail(email: event.email)));
  }

  void _mapPrimaryChangedToState({required PrimaryChanged event, required Emitter<OwnerFormState> emit}) {    
    emit(state.update(isPrimary: event.isPrimary));
  }
  
  void _mapPercentOwnershipChanged({required PercentOwnershipChanged event, required Emitter<OwnerFormState> emit}) {
    bool isValidPercentOwnership = Validators.isValidPercentOwnership(percent: event.percentOwnership) && _totalAssignedOwnership() + event.percentOwnership <= 100;
    emit(state.update(percentOwnership: event.percentOwnership.toString(), isPercentOwnershipValid: isValidPercentOwnership));
  }

  void _mapDobChangedToState({required DobChanged event, required Emitter<OwnerFormState> emit}) {
    try {
      DateFormat.yMd().parse(event.dob);
      emit(state.update(dob: event.dob, isDobValid: true));
    } on FormatException catch(_) {
      emit(state.update(dob: event.dob, isDobValid: false));
    }
  }

  void _mapSsnChangedToState({required SsnChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(ssn: event.ssn, isSsnValid: Validators.isValidSsn(ssn: event.ssn)));
  }

  void _mapAddressChangedToState({required AddressChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(address: event.address, isAddressValid: Validators.isValidAddress(address: event.address)));
  }

  void _mapAddressSecondaryChangedToState({required AddressSecondaryChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(addressSecondary: event.addressSecondary, isAddressSecondaryValid: Validators.isValidAddressSecondary(address: event.addressSecondary)));
  }

  void _mapCityChangedToState({required CityChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(city: event.city, isCityValid: Validators.isValidCity(city: event.city)));
  }

  void _mapStateChangedToState({required StateChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(state: event.state.toUpperCase(), isStateValid: Constants.states.contains(event.state.toUpperCase())));
  }

  void _mapZipChangedToState({required ZipChanged event, required Emitter<OwnerFormState> emit}) {
    emit(state.update(zip: event.zip, isZipValid: Validators.isValidZip(zip: event.zip)));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<OwnerFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      OwnerAccount account = await _ownerRepository.store(
        firstName: state.firstName,
        lastName: state.lastName,
        title: state.title,
        phone: state.phone,
        email: state.email,
        primary: state.isPrimary,
        percentOwnership: int.parse(state.percentOwnership),
        dob: state.dob,
        ssn: state.ssn,
        address: state.address,
        addressSecondary: state.addressSecondary,
        city: state.city,
        state: state.state.toUpperCase(),
        zip: state.zip
      );
      _ownersScreenBloc.add(OwnerAdded(owner: account));
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  Future<void> _mapUpdatedToState({required Updated event, required Emitter<OwnerFormState> emit}) async {
    emit(state.update(isSubmitting: true));

     try {
      OwnerAccount account = await _ownerRepository.update(
        identifier: _ownerAccount!.identifier,
        firstName: state.firstName,
        lastName: state.lastName,
        title: state.title,
        phone: state.phone,
        email: state.email,
        primary: state.isPrimary,
        percentOwnership: int.parse(state.percentOwnership),
        dob: state.dob,
        ssn: state.ssn,
        address: state.address,
        addressSecondary: state.addressSecondary,
        city: state.city,
        state: state.state.toUpperCase(),
        zip: state.zip
      );
      _ownersScreenBloc.add(OwnerUpdated(owner: account));
      emit(state.update(isSubmitting: false, isSuccess: true, errorButtonControl: CustomAnimationControl.stop));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error, errorButtonControl: CustomAnimationControl.playFromStart));
    }
  }

  void _mapResetToState({required Emitter<OwnerFormState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: "", errorButtonControl: CustomAnimationControl.stop));
  }

  int _totalAssignedOwnership() {
    return _ownersScreenBloc.owners.fold(0, (totalAssigned, owner) => totalAssigned + owner.percentOwnership);
  }
}
