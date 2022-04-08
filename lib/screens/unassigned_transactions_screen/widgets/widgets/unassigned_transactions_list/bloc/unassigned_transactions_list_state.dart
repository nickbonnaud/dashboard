part of 'unassigned_transactions_list_bloc.dart';

class UnassignedTransactionsListState extends Equatable {
  final List<UnassignedTransaction> transactions;
  final String? nextUrl;
  final bool hasReachedEnd;
  final bool loading;
  final bool paginating;
  final String errorMessage;
  final DateTimeRange? currentDateRange;

  const UnassignedTransactionsListState({
    required this.transactions,
    this.nextUrl,
    required this.hasReachedEnd,
    required this.loading,
    required this.paginating,
    required this.errorMessage,
    this.currentDateRange
  });

  factory UnassignedTransactionsListState.initial({@required DateTimeRange? currentDateRange}) {
    return UnassignedTransactionsListState(
      transactions: const [],
      nextUrl: null,
      hasReachedEnd: false,
      loading: false,
      paginating: false,
      errorMessage: '',
      currentDateRange: currentDateRange,
    );
  }

  UnassignedTransactionsListState update({
    List<UnassignedTransaction>? transactions,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    bool? paginating,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    bool isDateReset = false
  }) {
    return _copyWith(
      transactions: transactions,
      nextUrl: nextUrl,
      hasReachedEnd: hasReachedEnd,
      loading: loading,
      paginating: paginating,
      errorMessage: errorMessage,
      currentDateRange: currentDateRange,
      isDateReset: isDateReset
    );
  }
  
  UnassignedTransactionsListState _copyWith({
    List<UnassignedTransaction>? transactions,
    String? nextUrl,
    bool? hasReachedEnd,
    bool? loading,
    bool? paginating,
    String? errorMessage,
    DateTimeRange? currentDateRange,
    required bool isDateReset
  }) {
    return UnassignedTransactionsListState(
      transactions: transactions ?? this.transactions,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null :  nextUrl ?? this.nextUrl,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      loading: loading ?? this.loading,
      paginating: paginating ?? this.paginating,
      errorMessage: errorMessage ?? this.errorMessage,
      currentDateRange: isDateReset ? null : currentDateRange ?? this.currentDateRange,
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
    currentDateRange,
  ];
  
  @override
  String toString() => '''UnassignedTransactionsListState {
    transactions: $transactions,
    nextUrl: $nextUrl,
    hasReachedEnd: $hasReachedEnd,
    loading: $loading,
    paginating: $paginating
    errorMessage: $errorMessage,
    currentDateRange: $currentDateRange,
  }''';
}
