import 'package:bloc/bloc.dart';
import 'package:dashboard/models/business/accounts.dart';
import 'package:dashboard/models/business/bank_account.dart';
import 'package:dashboard/models/business/business.dart';
import 'package:dashboard/models/business/business_account.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/business/location.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/repositories/business_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:equatable/equatable.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessRepository _businessRepository;
  
  Business get business => (state as BusinessLoaded).business;
  
  BusinessBloc({required BusinessRepository businessRepository})
    : _businessRepository = businessRepository,
      super(BusinessInitial()) { _eventHandler(); }

  void _eventHandler() {
    on<BusinessAuthenticated>((event, emit) => _mapBusinessAuthenticatedToState(emit: emit));
    on<BusinessLoggedIn>((event, emit) => _mapBusinessLoggedInToState(event: event, emit: emit));
    on<BusinessLoggedOut>((event, emit) => _mapBusinessLoggedOutToState(emit: emit));
    on<BankAccountUpdated>((event, emit) => _mapBankAccountUpdatedToState(event: event, emit: emit));
    on<PhotosUpdated>((event, emit) => _mapPhotosUpdatedToState(event: event, emit: emit));
    on<BusinessAccountUpdated>((event, emit) => _mapBusinessAccountUpdatedToState(event: event, emit: emit));
    on<HoursUpdated>((event, emit) => _mapHoursUpdatedToState(event: event, emit: emit));
    on<LocationUpdated>((event, emit) => _mapLocationUpdatedToState(event: event, emit: emit));
    on<OwnerAccountsUpdated>((event, emit) => _mapOwnerAccountsUpdatedToState(event: event, emit: emit));
    on<ProfileUpdated>((event, emit) => _mapProfileUpdatedToState(event: event, emit: emit));
    on<EmailUpdated>((event, emit) => _mapEmailUpdatedToState(event: event, emit: emit));
    on<BusinessUpdated>((event, emit) => _mapBusinessUpdatedToState(event: event, emit: emit));
  }
  
  void _mapBusinessAuthenticatedToState({required Emitter<BusinessState> emit}) async {
    emit(BusinessLoading());
    try {
      Business business = await _businessRepository.fetch();
      emit(BusinessLoaded(business: business));
    } on ApiException catch(exception) {
      emit(BusinessFailedToLoad(error: exception.error));
    }
  }

  void _mapBusinessLoggedInToState({required BusinessLoggedIn event, required Emitter<BusinessState> emit}) async {
    emit(BusinessLoaded(business: event.business));
  }

  void _mapBusinessLoggedOutToState({required Emitter<BusinessState> emit}) async {
    emit(BusinessInitial());
  }

  void _mapBusinessUpdatedToState({required BusinessUpdated event, required Emitter<BusinessState> emit}) async {
    emit(BusinessLoaded(business: event.business));
  }

  void _mapBankAccountUpdatedToState({required BankAccountUpdated event, required Emitter<BusinessState> emit}) async {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      
      Accounts accounts = business.accounts.update(bankAccount: event.bankAccount);
      business = business.update(accounts: accounts);
      emit(BusinessLoaded(business: business));
    }
  }

  void _mapBusinessAccountUpdatedToState({required BusinessAccountUpdated event, required Emitter<BusinessState> emit}) async {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      Accounts accounts = business.accounts.update(businessAccount: event.businessAccount);
      business = business.update(accounts: accounts);
      emit(BusinessLoaded(business: business));
    }
  }

  void _mapPhotosUpdatedToState({required PhotosUpdated event, required Emitter<BusinessState> emit}) async {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      business = business.update(photos: event.photos);
      emit(BusinessLoaded(business: business));
    }
  }

  void _mapHoursUpdatedToState({required HoursUpdated event, required Emitter<BusinessState> emit}) async {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      Profile profile = business.profile.update(hours: event.hours);
      business = business.update(profile: profile);
      emit(BusinessLoaded(business: business));
    }
  }

  void _mapLocationUpdatedToState({required LocationUpdated event, required Emitter<BusinessState> emit}) async {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      business = business.update(location: event.location);
      emit(BusinessLoaded(business: business));
    }
  }

  void _mapOwnerAccountsUpdatedToState({required OwnerAccountsUpdated event, required Emitter<BusinessState> emit}) async {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      Accounts accounts = business.accounts.update(ownerAccounts: event.ownerAccounts);
      business = business.update(accounts: accounts);
      emit(BusinessLoaded(business: business));
    }
  }

  void _mapProfileUpdatedToState({required ProfileUpdated event, required Emitter<BusinessState> emit}) async {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      business = business.update(profile: event.profile);
      emit(BusinessLoaded(business: business));
    }
  }

  void _mapEmailUpdatedToState({required EmailUpdated event, required Emitter<BusinessState> emit}) async {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      business = business.update(email: event.email);
      emit(BusinessLoaded(business: business));
    }
  }
}
