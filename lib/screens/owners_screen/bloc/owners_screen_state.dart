part of 'owners_screen_bloc.dart';

@immutable
class OwnersScreenState extends Equatable {
  final List<OwnerAccount> owners;
  final bool formVisible;
  final OwnerAccount? editingAccount;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  OwnersScreenState({
    required this.owners,
    required this.formVisible,
    required this.editingAccount,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
  });

  factory OwnersScreenState.initial({required List<OwnerAccount> owners}) {
    return OwnersScreenState(
      owners: owners,
      formVisible: owners.length == 0,
      editingAccount: null,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  OwnersScreenState update({
    List<OwnerAccount>? owners,
    bool? formVisible,
    OwnerAccount? editingAccount,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool resetEditingAccount = false
  }) {
    return OwnersScreenState(
      owners: owners ?? this.owners,
      formVisible: formVisible ?? this.formVisible,
      editingAccount: resetEditingAccount ? null : editingAccount ?? this.editingAccount,
      isSubmitting: isSubmitting ?? this.isSubmitting, 
      isSuccess: isSuccess ?? this.isSuccess, 
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    owners, 
    formVisible,
    editingAccount,
    isSubmitting, 
    isSuccess, 
    errorMessage
  ];
  
  @override
  String toString() => '''OwnersScreenState { 
    owners: $owners, 
    formVisible: $formVisible,
    editingAccount: $editingAccount,
    isSubmitting: $isSubmitting, 
    isSuccess: $isSuccess, 
    errorMessage: $errorMessage 
  }''';
}
