import 'package:bloc_test/bloc_test.dart';
import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/customer_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/customers_screen/bloc/filter_button_bloc.dart';
import 'package:dashboard/screens/customers_screen/cubit/date_range_cubit.dart';
import 'package:dashboard/screens/customers_screen/widgets/bloc/customers_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}
class MockCustomer extends Mock implements CustomerResource {}

void main() {
  group("Customer List Bloc Tests", () {
    late CustomerRepository customerRepository;
    late FilterButtonBloc filterButtonBloc;
    late DateRangeCubit dateRangeCubit;
    late CustomersListBloc customersListBloc;

    late CustomersListState baseState;

    List<CustomerResource> _generateCustomers({int numbCustomers = 10}) {
      return List.generate(numbCustomers, (index) => MockCustomer());
    }

    late List<CustomerResource> _customersList;
    late List<CustomerResource> _previousCustomersList;
    late DateTimeRange _dateRange;

    setUp(() {
      customerRepository = MockCustomerRepository();
      filterButtonBloc = FilterButtonBloc();
      dateRangeCubit = DateRangeCubit();
      baseState = CustomersListState.initial(currentDateRange: null);
      customersListBloc = CustomersListBloc(
        customerRepository: customerRepository,
        filterButtonBloc: filterButtonBloc,
        dateRangeCubit: dateRangeCubit
      );
      registerFallbackValue(MockCustomer());
    });

    tearDown(() {
      filterButtonBloc.close();
      dateRangeCubit.close();
      customersListBloc.close();
    });

    test("Initial state of CustomersListBloc is CustomersListState.initial()", () {
      expect(customersListBloc.state, CustomersListState.initial(currentDateRange: null));
    });

    blocTest<CustomersListBloc, CustomersListState>(
      "Init event changes state: [loading: true], [loading: false, customers: List<MockCustomers>, nextUrl: nextUrl, hasReachedEnd: hasReachedEnd]",
      build: () => customersListBloc,
      act: (bloc) {
        _customersList = _generateCustomers();
        when(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions')))
          .thenAnswer((_) async => PaginateDataHolder(data: _customersList, next: "next"));
        bloc.add(Init());
      },
      expect: () {
        return [baseState.update(loading: true), baseState.update(loading: false, customers: _customersList, nextUrl: 'next', hasReachedEnd: false)]; 
      }
    );

    blocTest<CustomersListBloc, CustomersListState>(
      "Init event calls CustomerRepository.fetchAll()",
      build: () => customersListBloc,
      act: (bloc) {
        _customersList = _generateCustomers();
        when(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions')))
          .thenAnswer((_) async => PaginateDataHolder(data: _customersList, next: "next"));
        bloc.add(Init());
      },
      verify: (_) {
        verify(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions'))).called(1);
      }
    );

    blocTest<CustomersListBloc, CustomersListState>(
      "Init event on error changes state: [isSubmitting:true], [loading: false, errorMessage: error]",
      build: () => customersListBloc,
      act: (bloc) {
        _customersList = _generateCustomers();
        when(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions')))
          .thenThrow(ApiException(error: "error"));
        bloc.add(Init());
      },
      expect: () => [baseState.update(loading: true), baseState.update(loading: false, errorMessage: "error")]
    );

    blocTest<CustomersListBloc, CustomersListState>(
      "Fetch event changes state: [loading: true, customers: [], nextUrl: null, hasReachedEnd: false, errorMessage: ''], [loading: false, customers: List<MockCustomers>, nextUrl: 'next', hasReachedEnd: false]",
      build: () => customersListBloc,
      seed: () => baseState.update(customers: _generateCustomers(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _customersList = _generateCustomers();
        when(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions')))
          .thenAnswer((_) async => PaginateDataHolder(data: _customersList, next: "next"));
        bloc.add(FetchAll());
      },
      expect: () {
        return [baseState.update(loading: true, customers: [], nextUrl: null, hasReachedEnd: false, errorMessage: ""), baseState.update(loading: false, customers: _customersList, nextUrl: 'next', hasReachedEnd: false)]; 
      }
    );

    blocTest<CustomersListBloc, CustomersListState>(
      "Fetch event calls CustomerRepository.fetchAll()",
      build: () => customersListBloc,
       seed: () => baseState.update(customers: _generateCustomers(), nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error"),
      act: (bloc) {
        _customersList = _generateCustomers();
        when(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions')))
          .thenAnswer((_) async => PaginateDataHolder(data: _customersList, next: "next"));
        bloc.add(FetchAll());
      },
      verify: (_) {
        verify(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions'))).called(1);
      }
    );

    blocTest<CustomersListBloc, CustomersListState>(
      "Fetch event on error changes state: [loading: true, customers: [], nextUrl: null, hasReachedEnd: false, errorMessage: ''], [loading: false, errorMessage: error]",
      build: () => customersListBloc,
      act: (bloc) {
        when(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions')))
          .thenThrow(ApiException(error: "error"));
        bloc.add(FetchAll());
      },
      expect: () {
        CustomersListState newState = baseState.update(loading: true, customers: [], nextUrl: null, hasReachedEnd: false, errorMessage: "");
        return [newState, newState.update(loading: false, errorMessage: "error")]; 
      }
    );
    
    blocTest<CustomersListBloc, CustomersListState>(
      "FetchMore event changes state: [loading: false, customers: List<MockCustomers>, nextUrl: 'next', hasReachedEnd: false]",
      build: () => customersListBloc,
      seed: () {
        _customersList = _generateCustomers();
        baseState = baseState.update(customers: _customersList, nextUrl: "nextUrl", hasReachedEnd: false);
        return baseState;
      },
      act: (bloc) {
        List<CustomerResource> paginateCustomers = _generateCustomers();
        _customersList = _customersList + paginateCustomers;
        when(() => customerRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: paginateCustomers, next: "next"));
        bloc.add(FetchMore());
      },
      expect: () {
        return [baseState.update(paginating: true), baseState.update(customers: _customersList, nextUrl: 'next', hasReachedEnd: false)]; 
      }
    );

    blocTest<CustomersListBloc, CustomersListState>(
      "FetchMore event calls CustomerRepository.paginate()",
      build: () => customersListBloc,
      seed: () {
        _customersList = _generateCustomers();
        return baseState.update(customers: _customersList, nextUrl: "nextUrl", hasReachedEnd: false);
      },
      act: (bloc) {
        List<CustomerResource> paginateCustomers = _generateCustomers();
        _customersList = _customersList + paginateCustomers;
        when(() => customerRepository.paginate(url: any(named: "url")))
          .thenAnswer((_) async => PaginateDataHolder(data: paginateCustomers, next: "next"));
        bloc.add(FetchMore());
      },
      verify: (_) {
        verify(() => customerRepository.paginate(url: any(named: "url"))).called(1);
      }
    );


    blocTest<CustomersListBloc, CustomersListState>(
      "FetchMore event on error changes state: [loading: false, errorMessage: error]",
      build: () => customersListBloc,
      seed: () {
        _customersList = _generateCustomers();
        baseState = baseState.update(customers: _customersList, nextUrl: "nextUrl", hasReachedEnd: false);
        return baseState;
      },
      act: (bloc) {
        when(() => customerRepository.paginate(url: any(named: "url")))
          .thenThrow(ApiException(error: "error"));
        bloc.add(FetchMore());
      },
      expect: () {
        return [baseState.update(paginating: true), baseState.update(customers: _customersList, nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error")]; 
      }
    );

    blocTest<CustomersListBloc, CustomersListState>(
      "DateRangeChanged event yields 3 different states, updates Customers",
      build: () => customersListBloc,
      seed: () {
        _previousCustomersList = _generateCustomers(numbCustomers: 3);
        return baseState.update(customers: _previousCustomersList, nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error");
      },
      act: (bloc) {
        _dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
        when(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions'), dateRange: any(named: "dateRange")))
          .thenAnswer((_) async {
            _customersList = _generateCustomers();
            return PaginateDataHolder(data: _customersList, next: "next");
          });
        bloc.add(DateRangeChanged(dateRange: _dateRange));
      },
      expect: () {
        CustomersListState firstState = baseState.update(customers: _previousCustomersList, nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error", currentDateRange: _dateRange);
        CustomersListState secondState = CustomersListState(loading: true, paginating: false, customers: [], nextUrl: null, hasReachedEnd: false, errorMessage: '', currentDateRange: _dateRange);
        CustomersListState thirdState = secondState.update(loading: false, customers: _customersList, nextUrl: "next", hasReachedEnd: false);
        return [firstState, secondState, thirdState]; 
      }
    );
    
    blocTest<CustomersListBloc, CustomersListState>(
      "FilterButtonChanged event yields 2 different states, updates Customers",
      build: () => customersListBloc,
      seed: () {
        _previousCustomersList = _generateCustomers(numbCustomers: 3);
        return baseState.update(customers: _previousCustomersList, nextUrl: "nextUrl", hasReachedEnd: false, errorMessage: "error");
      },
      act: (bloc) {
        when(() => customerRepository.fetchAll(searchHistoric: any(named: 'searchHistoric'), withTransactions: any(named: 'withTransactions'), dateRange: any(named: "dateRange")))
          .thenAnswer((_) async {
            _customersList = _generateCustomers();
            return PaginateDataHolder(data: _customersList, next: "next");
          });
        bloc.add(FilterButtonChanged());
      },
      expect: () {
        CustomersListState secondState = CustomersListState(loading: true, paginating: false, customers: [], nextUrl: null, hasReachedEnd: false, errorMessage: '', currentDateRange: null);
        CustomersListState thirdState = secondState.update(loading: false, customers: _customersList, nextUrl: "next", hasReachedEnd: false);
        return [secondState, thirdState]; 
      }
    );
  });
}