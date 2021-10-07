class ApiEndpoints {
  static const String base = 'http://novapay.ai/api/business';
  
  static const String register = 'auth/register';
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String verifyPassword = 'auth/verify';
  static const String requestPasswordReset = 'auth/request-reset';
  static const String resetPassword = 'auth/reset-password';
  static const String refreshSelf = 'auth/refresh';

  static const String payFacBank = 'payfac/bank';
  static const String payFacBusiness = 'payfac/business';
  static const String payFacOwner = 'payfac/owner';

  static const String business = "business";

  static const String credentials = 'credentials';

  static const String customers = 'customers';

  static const String geoLocation = 'location/geo';

  static const String hours = 'hours';

  static const String message = 'message';

  static const String reply = 'reply';

  static const String photos = 'photos';

  static const String profile = 'profile';

  static const String refunds = 'refunds';

  static const String transactionStatuses = 'status/transaction';

  static const String tips = 'tips';

  static const String transactions = 'transactions';

  static const String unassignedTransactions = 'unassigned-transactions';
}