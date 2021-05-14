part of 'refunds_list_bloc.dart';

@immutable
class RefundsListState extends Equatable {
  final List<RefundResource> refunds;
  final String? nextUrl;
  final bool hasReachedEnd;
  final bool loading;
  final bool paginating;
  final String errorMessage;
  final FilterType currentFilter;
  final DateTimeRange? currentDateRange;
  final String? currentIdQuery;
  final FullName? currentNameQuery;

  const RefundsListState({
    required this.refunds,
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

  factory RefundsListState.initial({required FilterType currentFilter, @required DateTimeRange? currentDateRange}) {
    return RefundsListState(
      refunds: [],
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

  RefundsListState reset({String? currentIdQuery, FullName? currentNameQuery}) {
    return RefundsListState(
      refunds: [],
      nextUrl: null,
      hasReachedEnd: false,
      loading: true,
      paginating: false,
      errorMessage: '',
      currentFilter: this.currentFilter,
      currentDateRange: this.currentDateRange,
      currentIdQuery: currentIdQuery,
      currentNameQuery: currentNameQuery,
    );
  }
  
  RefundsListState update({
    List<RefundResource>? refunds,
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
      refunds: refunds,
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
  
  RefundsListState _copyWith({
    List<RefundResource>? refunds,
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
    return RefundsListState(
      refunds: refunds ?? this.refunds,
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
    refunds,
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
  String toString() => '''RefundsListState {
    refunds: $refunds,
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
