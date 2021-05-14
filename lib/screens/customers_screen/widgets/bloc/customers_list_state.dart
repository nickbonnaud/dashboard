part of 'customers_list_bloc.dart';

@immutable
class CustomersListState extends Equatable {
  final List<CustomerResource> customers;
  final String? nextUrl;
  final bool hasReachedEnd;
  final bool loading;
  final bool paginating;
  final String errorMessage;
  final DateTimeRange? currentDateRange;

  CustomersListState({
    required this.customers,
    this.nextUrl,
    required this.hasReachedEnd,
    required this.loading,
    required this.paginating,
    required this.errorMessage,
    this.currentDateRange
  });

  factory CustomersListState.initial({@required DateTimeRange? currentDateRange}) {
    return CustomersListState(
      customers: [],
      hasReachedEnd: false,
      loading: false,
      paginating: false,
      errorMessage: '',
      currentDateRange: currentDateRange,
    );
  }

  CustomersListState reset() {
    return CustomersListState(
      loading: true,
      paginating: false,
      customers: [],
      nextUrl: null,
      hasReachedEnd: false,
      errorMessage: '',
      currentDateRange: currentDateRange
    );
  }
  
  CustomersListState update({
    List<CustomerResource>? customers,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    bool? paginating,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    bool isDateReset = false
  }) {
    return _copyWith(
      customers: customers,
      nextUrl: nextUrl,
      hasReachedEnd: hasReachedEnd,
      loading: loading,
      paginating: paginating,
      errorMessage: errorMessage,
      currentDateRange: currentDateRange,
      isDateReset: isDateReset
    );
  }
  
  CustomersListState _copyWith({
    List<CustomerResource>? customers,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    bool? paginating,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    required bool isDateReset
  }) {
    return CustomersListState(
      customers: customers ?? this.customers,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null : nextUrl ?? this.nextUrl,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      loading: loading ?? this.loading,
      paginating: paginating ?? this.paginating,
      errorMessage: errorMessage ?? this.errorMessage,
      currentDateRange: isDateReset ? null : currentDateRange ?? this.currentDateRange,
    );
  }

  @override
  List<Object?> get props => [
    customers,
    nextUrl,
    hasReachedEnd,
    loading,
    paginating,
    errorMessage,
    currentDateRange
  ];

  @override
  String toString() => '''CustomersListState {
    customers: $customers,
    nextUrl: $nextUrl,
    hasReachedEnd: $hasReachedEnd,
    loading: $loading,
    paginating: $paginating
    errorMessage: $errorMessage,
    currentDateRange: $currentDateRange,
  }''';
}
