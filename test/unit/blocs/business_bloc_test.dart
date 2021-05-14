import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/blocs/business/business_bloc.dart';
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
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBusinessRepository extends Mock implements BusinessRepository {}
class MockBusiness extends Mock implements Business {}
class MockBankAccount extends Mock implements BankAccount {}
class MockBusinessAccount extends Mock implements BusinessAccount {}
class MockAccounts extends Mock implements Accounts {}
class MockPhotos extends Mock implements Photos {}
class MockProfile extends Mock implements Profile {}
class MockHours extends Mock implements Hours {}
class MockLocation extends Mock implements Location {}
class MockOwnerAccount extends Mock implements OwnerAccount {}

void main() {
  group("Business Bloc Tests", () {
    late BusinessRepository businessRepository;
    late BusinessBloc businessBloc;

    setUp(() {
      businessRepository = MockBusinessRepository();
      businessBloc = BusinessBloc(businessRepository: businessRepository);
      registerFallbackValue<BankAccount>(MockBankAccount());
      registerFallbackValue<BusinessAccount>(MockBusinessAccount());
      registerFallbackValue<Accounts>(MockAccounts());
      registerFallbackValue<Photos>(MockPhotos());
      registerFallbackValue<Hours>(MockHours());
    });

    tearDown(() {
      businessBloc.close();
    });

    test("Business Bloc inital state is BusinessInitial", () {
      expect(businessBloc.state, isA<BusinessInitial>());
    });

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event BusinessAuthenticated fetchs Business on success",
      build: () {
        when(() => businessRepository.fetch()).thenAnswer((_) async => MockBusiness());
        return businessBloc;
      },
      act: (bloc) => bloc.add(BusinessAuthenticated()),
      verify: (_) {
        verify(() => businessRepository.fetch()).called(1);
      }
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event BusinessAuthenticated yields BusinessLoading, BusinessLoaded on success",
      build: () {
        when(() => businessRepository.fetch()).thenAnswer((_) async => MockBusiness());
        return businessBloc;
      },
      act: (bloc) => bloc.add(BusinessAuthenticated()),
      expect: () => [isA<BusinessLoading>(), isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event BusinessAuthenticated yields BusinessLoading, BusinessFailedToLoad on error",
      build: () {
        when(() => businessRepository.fetch()).thenThrow(ApiException(error: "error"));
        return businessBloc;
      },
      act: (bloc) => bloc.add(BusinessAuthenticated()),
      expect: () => [isA<BusinessLoading>(), isA<BusinessFailedToLoad>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event BusinessLoggedIn yields BusinessLoaded",
      build: () => businessBloc,
      act: (bloc) => bloc.add(BusinessLoggedIn(business: MockBusiness())),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event BusinessLoggedOut yields BusinessInitial",
      build: () => businessBloc,
      act: (bloc) => bloc.add(BusinessLoggedOut()),
      expect: () => [isA<BusinessInitial>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event BusinessUpdated yields BusinessLoaded",
      build: () => businessBloc,
      act: (bloc) => bloc.add(BusinessUpdated(business: MockBusiness())),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event BankAccountUpdated yields BusinessLoaded",
      seed: () {
        Business business = MockBusiness();
        Accounts accounts = MockAccounts();

        when(() => business.accounts).thenReturn(accounts);
        when(() => accounts.update(bankAccount: any(named: "bankAccount"))).thenReturn(MockAccounts());
        when(() => business.update(accounts: any(named: 'accounts'))).thenReturn(MockBusiness());
        return BusinessLoaded(business: business);
      },
      build: () => businessBloc,
      act: (bloc) => bloc.add(BankAccountUpdated(bankAccount: MockBankAccount())),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event BusinessAccountUpdated yields BusinessLoaded",
      seed: () {
        Business business = MockBusiness();
        Accounts accounts = MockAccounts();

        when(() => business.accounts).thenReturn(accounts);
        when(() => accounts.update(businessAccount: any(named: "businessAccount"))).thenReturn(MockAccounts());
        when(() => business.update(accounts: any(named: 'accounts'))).thenReturn(MockBusiness());
        return BusinessLoaded(business: business);
      },
      build: () => businessBloc,
      act: (bloc) => bloc.add(BusinessAccountUpdated(businessAccount: MockBusinessAccount())),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event PhotosUpdated yields BusinessLoaded",
      seed: () {
        Business business = MockBusiness();

        when(() => business.update(photos: any(named: 'photos'))).thenReturn(MockBusiness());
        return BusinessLoaded(business: business);
      },
      build: () => businessBloc,
      act: (bloc) => bloc.add(PhotosUpdated(photos: MockPhotos())),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event HoursUpdated yields BusinessLoaded",
      seed: () {
        Business business = MockBusiness();
        Profile profile = MockProfile();

        when(() => business.profile).thenReturn(profile);
        when(() => profile.update(hours: any(named: "hours"))).thenReturn(MockProfile());
        when(() => business.update(profile: any(named: 'profile'))).thenReturn(MockBusiness());
        return BusinessLoaded(business: business);
      },
      build: () => businessBloc,
      act: (bloc) => bloc.add(HoursUpdated(hours: MockHours())),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event LocationUpdated yields BusinessLoaded",
      seed: () {
        Business business = MockBusiness();
        when(() => business.update(location: any(named: 'location'))).thenReturn(MockBusiness());
        return BusinessLoaded(business: business);
      },
      build: () => businessBloc,
      act: (bloc) => bloc.add(LocationUpdated(location: MockLocation())),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event OwnerAccountsUpdated yields BusinessLoaded",
      seed: () {
        Business business = MockBusiness();
        Accounts accounts = MockAccounts();

        when(() => business.accounts).thenReturn(accounts);
        when(() => accounts.update(ownerAccounts: any(named: "ownerAccounts"))).thenReturn(MockAccounts());
        when(() => business.update(accounts: any(named: 'accounts'))).thenReturn(MockBusiness());
        return BusinessLoaded(business: business);
      },
      build: () => businessBloc,
      act: (bloc) => bloc.add(OwnerAccountsUpdated(ownerAccounts: [MockOwnerAccount()])),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event ProfileUpdated yields BusinessLoaded",
      seed: () {
        Business business = MockBusiness();
        when(() => business.update(profile: any(named: 'profile'))).thenReturn(MockBusiness());
        return BusinessLoaded(business: business);
      },
      build: () => businessBloc,
      act: (bloc) => bloc.add(ProfileUpdated(profile: MockProfile())),
      expect: () => [isA<BusinessLoaded>()]
    );

    blocTest<BusinessBloc, BusinessState>(
      "BusinessBloc event Email Updated yields BusinessLoaded",
      seed: () {
        Business business = MockBusiness();
        when(() => business.update(email: any(named: 'email'))).thenReturn(MockBusiness());
        return BusinessLoaded(business: business);
      },
      build: () => businessBloc,
      act: (bloc) => bloc.add(EmailUpdated(email: "email")),
      expect: () => [isA<BusinessLoaded>()]
    );
  });
}