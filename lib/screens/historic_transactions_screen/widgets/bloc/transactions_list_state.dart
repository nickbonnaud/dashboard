part of 'transactions_list_bloc.dart';

@immutable
class TransactionsListState extends Equatable {
  final List<TransactionResource> transactions;
  final String? nextUrl;
  final bool hasReachedEnd;
  final bool loading;
  final bool paginating;
  final String errorMessage;
  final FilterType currentFilter;
  final DateTimeRange? currentDateRange;
  final String? currentIdQuery;
  final FullName? currentNameQuery;

  const TransactionsListState({
    required this.transactions,
    this.nextUrl,
    required this.hasReachedEnd,
    required this.loading,
    required this.paginating,
    required this.errorMessage,
    required this.currentFilter,
    this.currentDateRange,
    this.currentIdQuery,
    this.currentNameQuery
  });

  factory TransactionsListState.initial({required FilterType currentFilter, @required DateTimeRange? currentDateRange}) {
    return TransactionsListState(
      transactions: [],
      nextUrl: null,
      hasReachedEnd: false,
      loading: false,
      paginating: false,
      errorMessage: '',
      currentFilter: currentFilter,
      currentDateRange: currentDateRange,
      currentIdQuery: null,
      currentNameQuery: null
    );
  }

  TransactionsListState reset({String? currentIdQuery, FullName? currentNameQuery}) {
    return TransactionsListState(
      transactions: [],
      nextUrl: null,
      hasReachedEnd: false,
      loading: true,
      paginating: false,
      errorMessage: '',
      currentFilter: this.currentFilter,
      currentDateRange: this.currentDateRange,
      currentIdQuery: currentIdQuery,
      currentNameQuery: currentNameQuery
    );
  }
  
  TransactionsListState update({
    List<TransactionResource>? transactions,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    bool? paginating,
    String? errorMessage,
    FilterType? currentFilter,
    DateTimeRange? currentDateRange,
    String? currentIdQuery,
    FullName? currentNameQuery,
    bool isDateReset = false
  }) {
    return _copyWith(
      transactions: transactions,
      nextUrl: nextUrl,
      hasReachedEnd: hasReachedEnd,
      loading: loading,
      paginating: paginating,
      errorMessage: errorMessage,
      currentFilter: currentFilter,
      currentDateRange: currentDateRange,
      currentIdQuery: currentIdQuery,
      currentNameQuery: currentNameQuery,
      isDateReset: isDateReset
    );
  }
  
  TransactionsListState _copyWith({
    List<TransactionResource>? transactions,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    bool? paginating,
    String? errorMessage,
    FilterType? currentFilter,
    DateTimeRange? currentDateRange,
    String? currentIdQuery,
    FullName? currentNameQuery,
    required bool isDateReset
  }) {
    return TransactionsListState(
      transactions: transactions ?? this.transactions,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null : nextUrl ?? this.nextUrl,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      loading: loading ?? this.loading,
      paginating: paginating ?? this.paginating,
      errorMessage: errorMessage ?? this.errorMessage,
      currentFilter: currentFilter ?? this.currentFilter,
      currentDateRange: isDateReset ? null : currentDateRange ?? this.currentDateRange,
      currentIdQuery: currentIdQuery ?? this.currentIdQuery,
      currentNameQuery: currentNameQuery ?? this.currentNameQuery
    );
  }

  @override
  List<Object?> get props => [
    transactions,
    nextUrl,
    hasReachedEnd,
    loading,
    paginating,
    errorMessage,
    currentFilter,
    currentDateRange,
    currentIdQuery,
    currentNameQuery
  ];
  
  @override
  String toString() => '''TransactionsListState {
    transactions: $transactions,
    nextUrl: $nextUrl,
    hasReachedEnd: $hasReachedEnd,
    loading: $loading,
    paginating: $paginating,
    errorMessage: $errorMessage,
    currentFilter: $currentFilter,
    currentDateRange: $currentDateRange,
    currentIdQuery: $currentIdQuery,
    currentNameQuery: $currentNameQuery
  }''';
  
  
}

