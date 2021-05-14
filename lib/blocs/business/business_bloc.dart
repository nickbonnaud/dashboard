import 'dart:async';

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
      super(BusinessInitial());

  @override
  Stream<BusinessState> mapEventToState(BusinessEvent event) async* {
    if (event is BusinessAuthenticated) {
      yield* _mapBusinessAuthenticatedToState();
    } else if (event is BusinessLoggedIn) {
      yield BusinessLoaded(business: event.business);
    } else if (event is BusinessLoggedOut) {
      yield BusinessInitial();
    } else if (event is BankAccountUpdated) {
      yield* _mapBankAccountUpdatedToState(event: event);
    } else if (event is PhotosUpdated) {
      yield* _mapPhotosUpdatedToState(event: event);
    } else if (event is BusinessAccountUpdated) {
      yield* _mapBusinessAccountUpdatedToState(event: event);
    } else if (event is HoursUpdated) {
      yield* _mapHoursUpdatedToState(event: event);
    } else if (event is LocationUpdated) {
      yield* _mapLocationUpdatedToState(event: event);
    } else if (event is OwnerAccountsUpdated) {
      yield* _mapOwnerAccountsUpdatedToState(event: event);
    } else if (event is ProfileUpdated) {
      yield* _mapProfileUpdatedToState(event: event);
    } else if (event is EmailUpdated) {
      yield* _mapEmailUpdatedToState(event: event);
    } else if (event is BusinessUpdated) {
      yield* _mapBusinessUpdatedToState(event: event);
    }
  }

  Stream<BusinessState> _mapBusinessAuthenticatedToState() async* {
    yield BusinessLoading();
    try {
      Business business = await _businessRepository.fetch();
      yield BusinessLoaded(business: business);
    } on ApiException catch(exception) {
      yield BusinessFailedToLoad(error: exception.error);
    }
  }

  Stream<BusinessState> _mapBusinessUpdatedToState({required BusinessUpdated event}) async* {
    yield BusinessLoaded(business: event.business);
  }

  Stream<BusinessState> _mapBankAccountUpdatedToState({required BankAccountUpdated event}) async* {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      
      Accounts accounts = business.accounts.update(bankAccount: event.bankAccount);
      business = business.update(accounts: accounts);
      yield BusinessLoaded(business: business);
    }
  }

  Stream<BusinessState> _mapBusinessAccountUpdatedToState({required BusinessAccountUpdated event}) async* {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      Accounts accounts = business.accounts.update(businessAccount: event.businessAccount);
      business = business.update(accounts: accounts);
      yield BusinessLoaded(business: business);
    }
  }

  Stream<BusinessState> _mapPhotosUpdatedToState({required PhotosUpdated event}) async* {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      business = business.update(photos: event.photos);
      yield BusinessLoaded(business: business);
    }
  }

  Stream<BusinessState> _mapHoursUpdatedToState({required HoursUpdated event}) async* {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      Profile profile = business.profile.update(hours: event.hours);
      business = business.update(profile: profile);
      yield BusinessLoaded(business: business);
    }
  }

  Stream<BusinessState> _mapLocationUpdatedToState({required LocationUpdated event}) async* {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      business = business.update(location: event.location);
      yield BusinessLoaded(business: business);
    }
  }

  Stream<BusinessState> _mapOwnerAccountsUpdatedToState({required OwnerAccountsUpdated event}) async* {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      Accounts accounts = business.accounts.update(ownerAccounts: event.ownerAccounts);
      business = business.update(accounts: accounts);
      yield BusinessLoaded(business: business);
    }
  }

  Stream<BusinessState> _mapProfileUpdatedToState({required ProfileUpdated event}) async* {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      business = business.update(profile: event.profile);
      yield BusinessLoaded(business: business);
    }
  }

  Stream<BusinessState> _mapEmailUpdatedToState({required EmailUpdated event}) async* {
    if (state is BusinessLoaded) {
      Business business = (state as BusinessLoaded).business;
      business = business.update(email: event.email);
      yield BusinessLoaded(business: business);
    }
  }
}
