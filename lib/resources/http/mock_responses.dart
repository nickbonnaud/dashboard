
import 'dart:math';

import 'package:dashboard/models/status.dart';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';

import '../../dev_keys.dart';

class MockResponses {

  static Map<String, dynamic>? mockResponse(RequestOptions options) {    
    if (options.path.endsWith('auth/register')) {
      return _mockRegister(options);
    } else if (options.path.endsWith('auth/login')) {
      return _mockLogin(options);
    } else if (options.path.endsWith('auth/logout')) {
      return _mockLogout();
    } else if (options.path.endsWith('auth/refresh')) {
      return _mockRefresh();
    } else if (options.path.contains('auth/verify')) {
      return _mockVerify(options);
    } else if (options.path.endsWith('credentials')) {
      return _mockFetchCredentials();
    } else if (options.path.contains('business/business/')) {
      return _mockUpdateBusiness(options);
    } else if (options.path.contains('profile') && (options.method.toLowerCase() == 'post' || options.method.toLowerCase() == 'patch')) {
      return _mockStoreProfile(options);
    } else if (options.path.contains('payfac/business')) {
      return _mockStoreBusinessData(options);
    } else if (options.path.endsWith('payfac/owner')) {
      return _mockStoreOwnerData(options);
    } else if (options.path.contains('payfac/owner') && options.method.toLowerCase() == 'patch') {
      return _mockUpdateOwnerData(options);
    } else if (options.path.contains('payfac/owner') && options.method.toLowerCase() == 'delete') {
      return _mockDeleteOwnerData();
    } else if (options.path.contains('photos/')) {
      return _mockStorePhoto(options);
    } else if (options.path.contains('payfac/bank')) {
      return _mockStoreBank(options);
    } else if (options.path.contains('location/geo')) {
      return _mockStoreGeo(options);
    } else if (options.path.contains('hours')) {
      return _mockStoreHours(options);
    } else if (options.path.contains("transactions?") && options.path.contains("sum=")) {
      return _mockFetchTransactionsSum();
    } else if (options.path.contains("refunds") && options.path.contains("sum=")) {
      return _mockFetchRefundsSum();
    }  else if (options.path.contains('unassigned-transaction')) {
      return _mockFetchUnassigned(options: options);
    }  else if (options.path.contains("transactions?") && options.path.contains("unique=customer_id")) {
      return _mockFetchUniqueCustomers();
    } else if (options.path.contains("transactions?") && options.path.contains("count=''")) {
      return _mockFetchUniqueCustomers();
    } else if (options.path.contains("transactions") && options.path.contains("date[]=")) {
      return _mockFetchTransactionsWithDate(options);
    } else if (options.path.contains("transaction") && options.path.contains("status=")) {
      return _mockFetchTransactionsByStatus(options);
    } else if (options.path.contains("transactions?") && options.path.contains("customer=")) {
      return _mockFetchTransactionsByCustomer(options);
    } else if (options.path.contains("employeeFirst=") || options.path.contains("employeeLast=")) {
      return _mockFetchTransactionsByEmployee(options);
    } else if (options.path.contains("transactions?") && (options.path.contains("customerFirst=") || options.path.contains("customerLast="))) {
      return _mockFetchTransactionsByCustomerName(options);
    } else if (options.path.contains("transactions?") && options.path.contains("id=")) {
      return _mockFetchTransactionById(options);
    } else if (options.path.contains("transactions")) {
      return _mockFetchTransactionsBase(options);
    } else if (options.path.contains("refunds") && options.path.contains("date[]=")) {
      return _mockFetchRefundsWithDate(options);
    } else if (options.path.contains("refunds?") && (options.path.contains("customerFirst=") || options.path.contains("customerLast="))) {
      return _mockFetchRefundsByCustomerName(options);
    } else if (options.path.contains("refunds?") && options.path.contains("id=")) {
      return _mockFetchRefundById(options);
    } else if (options.path.contains("transactionId=")) {
      return _mockFetchRefundByTransactionId(options);
    } else if (options.path.contains("refunds?") && options.path.contains("customer=")) {
      return _mockFetchRefundsByCustomerId(options);
    } else if (options.path.contains('refunds')) {
      return _mockFetchRefundsBase(options);
    } else if (options.path.contains('tips') && options.path.contains('all')) {
      return _mockFetchEmployeeTipsAll(options);
    } else if (options.path.contains('tips') && options.path.contains('single')) {
      return _mockFetchEmployeeTipsSingle(options);
    } else if (options.path.contains('message') && options.path.contains('unread')) {
      return _mockFetchHasUnreadMessages();
    } else if (options.path.contains('message') && options.method.toLowerCase() == 'get') {
      return _mockFetchMessages(options);
    } else if (options.path.contains('message') && options.method.toLowerCase() == 'post') {
      return _mockStoreMessage(options);
    } else if (options.path.contains('reply')) {
      return _mockStoreReply(options);
    } else if (options.path.contains('message') && options.method.toLowerCase() == 'patch') {
      return _mockUpdateMessage(options);
    } else if (options.path.contains("request-reset")) {
      return _mockRequestReset();
    } else if (options.path.contains("reset-password")) {
      return _mockResetPassword();
    } else if (options.path.contains("status/transaction")) {
      return _mockFetchTransactionStatuses();
    } else if (options.path.contains("customers")) {
      return _mockFetchAllCustomers(options);
    } else {
      return { 'data': { "testing": true } };
    }
  }

  static Map<String, dynamic> _mockRegister(RequestOptions options) {
    return {
      'data': {
        'csrf_token': {
          'value': 'fake_token',
          'expiry': DateTime.now().add(const Duration(hours: 2)).toString()
        },
        'business': {
          'identifier': 'fake_identifier',
          'email': options.data['email'],
          'profile': null,
          'photos': null,
          'accounts': {
            'business_account': null,
            'owner_accounts': [],
            'bank_account': null,
            'account_status': {
              'name': 'Profile Account Incomplete',
              'code': 100
            }
          },
          'location': null,
          'pos_account': null
        }
      }
    };
  }

  static Map<String, dynamic> _mockLogin(RequestOptions options) {
    return {
      'data': {
        'csrf_token': {
          'value': 'fake_token',
          'expiry': DateTime.now().add(const Duration(hours: 2)).toString()
        },
        'business': {
          'identifier': 'fake_identifier',
          'email': options.data['email'],
          'profile': null,
          'photos': null,
          'accounts': {
            'business_account': null,
            'owner_accounts': [],
            'bank_account': null,
            'account_status': {
              'name': 'Profile Account Incomplete',
              'code': 100
            }
          },
          'location': null,
          'pos_account': null
        }
      }
    };
  }

  static Map<String, dynamic> _mockLogout() {
    return {
      'data': {
        'success': true
      }
    };
  }

  static Map<String, dynamic> _mockVerify(RequestOptions options) {
    return {
      'data': {
        'password_verified': true 
      }
    };
  }

  static Map<String, dynamic> _mockRefresh() {
    // return {
    //   'data': {
    //     'csrf_token': {
    //       'value': 'fake_token',
    //       'expiry': DateTime.now().add(Duration(hours: 2)).toString()
    //     },
    //     'business': {
    //       'identifier': faker.guid.guid(),
    //       'email': faker.internet.email(),
    //       'profile': null,
    //       'photos': null,
    //       'accounts': {
    //         'business_account': null,
    //         'owner_accounts': [],
    //         'bank_account': null,
    //         'account_status': {
    //           'name': 'Profile Account Incomplete',
    //           'code': 103
    //         }
    //       },
    //       'location': null,
    //       'pos_account': null
    //     }
    //   }
    // };
    
    return {
      'data': {
        'csrf_token': {
          'value': 'fake_token',
          'expiry': DateTime.now().add(const Duration(hours: 2)).toString()
        },
        'business': generateBusiness()
      }
    };
  }

  static Map<String, dynamic> _mockFetchCredentials() {
    return {
      'data': {
        'google_key': DevKeys.googleKey
      }
    };
  }

  static Map<String, dynamic> _mockUpdateBusiness(RequestOptions options) {
    return {
      'data': {
        'identifier': _createIdentifier(),
        'email': options.data['email'] ?? faker.internet.email()
      }
    };
  }

  static Map<String, dynamic> _mockStoreProfile(RequestOptions options) {
    return {
      'data': {
        'identifier': 'fake_identifier',
        'name': options.data['name'],
        'website': options.data['website'],
        'description': options.data['description'],
        'phone': options.data['phone'],
        'hours': null
      }
    };
  }

  static Map<String, dynamic> 
  _mockStoreBusinessData(RequestOptions options) {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'ein': options.data['ein'],
        'business_name': options.data['business_name'],
        'address': {
          'address': options.data['address'],
          'address_secondary': options.data['address_secondary'] ?? "",
          'city': options.data['city'],
          'state': options.data['state'],
          'zip': options.data['zip']
        },
        'entity_type': options.data['entity_type']
      }
    };
  }

  static Map<String, dynamic> _mockStoreOwnerData(RequestOptions options) {
    return {
      'data': {
        'identifier': _createIdentifier(),
        'address': {
          'address': options.data['address'],
          'address_secondary': options.data['address_secondary'],
          'city': options.data['city'],
          'state': options.data['state'],
          'zip': options.data['zip']
        },
        'dob': options.data['dob'],
        'ssn': "XXXXX${options.data['ssn'].substring(options.data['ssn'].length -4)}",
        'last_name': options.data['last_name'],
        'first_name': options.data['first_name'],
        'title': options.data['title'],
        'phone': options.data['phone'],
        'email': options.data['email'],
        'primary': options.data['primary'],
        'percent_ownership': options.data['percent_ownership']
      }
    };
  }

  static Map<String, dynamic> _mockUpdateOwnerData(RequestOptions options) {
    return {
      'data': {
        'identifier': options.path.substring(options.path.lastIndexOf('/') + 1),
        'address': {
          'address': options.data['address'],
          'address_secondary': options.data['address_secondary'],
          'city': options.data['city'],
          'state': options.data['state'],
          'zip': options.data['zip']
        },
        'dob': options.data['dob'],
        'ssn': "XXXXX${options.data['ssn'].substring(options.data['ssn'].length -4)}",
        'last_name': options.data['last_name'],
        'first_name': options.data['first_name'],
        'title': options.data['title'],
        'phone': options.data['phone'],
        'email': options.data['email'],
        'primary': options.data['primary'],
        'percent_ownership': options.data['percent_ownership']
      }
    };
  }

  static Map<String, dynamic> _mockDeleteOwnerData() {
    return {
      'data': {
        'success': true
      }
    };
  }

  static Map<String, dynamic> _mockStorePhoto(RequestOptions options) {
    return {
      'data': {
        'logo': {
          'name': "logo-${_createIdentifier()}",
          'small_url': 'https://cdn.substack.com/image/fetch/h_600,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2Faf2d140a-732b-4af4-a371-c47d2ebd412f_500x500.png',
          'large_url': 'https://cdn.substack.com/image/fetch/h_600,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2Faf2d140a-732b-4af4-a371-c47d2ebd412f_500x500.png'
        },
        'banner': {
          'name': "banner-${_createIdentifier()}",
          'small_url': 'https://powerdigitalmarketing.com/wp-content/uploads/2020/05/How-You-Can-Use-PR-to-Solve-the-Issue-of-Fake-Online-Reviews-01.jpg',
          'large_url': 'https://powerdigitalmarketing.com/wp-content/uploads/2020/05/How-You-Can-Use-PR-to-Solve-the-Issue-of-Fake-Online-Reviews-01.jpg'
        }
      }
    };
  }

  static Map<String, dynamic> _mockStoreBank(RequestOptions options) {
    return {
      'data': {
        'identifier': _createIdentifier(),
        'address': {
          'address': options.data['address'],
          'address_secondary': options.data['address_secondary'],
          'city': options.data['city'],
          'state': options.data['state'],
          'zip': options.data['zip']
        },
        'first_name': options.data['first_name'],
        'last_name': options.data['last_name'],
        'routing_number': options.data['routing_number'],
        'account_number': options.data['account_number'],
        'account_type': options.data['account_type']
      }
    };
  }

  static Map<String, dynamic> _mockStoreGeo(RequestOptions options) {
    return {
      'data': {
        'identifier': _createIdentifier(),
        'lat': options.data['lat'],
        'lng': options.data['lng'],
        'radius': options.data['radius']
      }
    };
  }

  static Map<String, dynamic> _mockStoreHours(RequestOptions options) {
    return {
      'data': {
        'identifier': _createIdentifier(),
        'sunday': options.data['sunday'],
        'monday': options.data['monday'],
        'tuesday': options.data['tuesday'],
        'wednesday': options.data['wednesday'],
        'thursday': options.data['thursday'],
        'friday': options.data['friday'],
        'saturday': options.data['saturday'],
      }
    };
  }

  static Map<String, dynamic> _mockFetchTransactionsSum() {
    return {
      'data': {
        'sales_data': _randomInt(floor: 100, ceiling: 15000)
      }
    };
  }

  static Map<String, dynamic> _mockFetchRefundsSum() {
    return {
      'data': {
        'refund_data': _randomInt(floor: 100, ceiling: 15000)
      }
    };
  }

  static Map<String, dynamic> _mockFetchUniqueCustomers() {
    return {
      'data': {
        'sales_data': _randomInt(floor: 1, ceiling: 100)
      }
    };
  }

  static Map<String, dynamic> _mockFetchTransactionsBase(RequestOptions options) {
    return _createTransactions(options: options);
  }

  static Map<String, dynamic> _mockFetchTransactionsWithDate(RequestOptions options) {
    return _createTransactions(options: options);
  }

  static Map<String, dynamic> _mockFetchTransactionsByStatus(RequestOptions options) {
    final int code = int.parse(options.path.split("status=")[1].substring(0,3));
    final Status status = Status(name: "Fake Status", code: code);
    
    return _createTransactions(options: options, status: status);
  }

  static Map<String, dynamic> _mockFetchTransactionsByCustomer(RequestOptions options) {
    final String customerId = faker.guid.guid();
    
    return _createTransactions(options: options, customerId: customerId);
  }

  static Map<String, dynamic> _mockFetchTransactionsByEmployee(RequestOptions options) {
    final String? firstName = _parseStringFromUrl(url: options.path, needle: "employeeFirst=");
    final String? lastName = _parseStringFromUrl(url: options.path, needle: "employeeLast=");
    
    return _createTransactions(options: options, employeeFirst: firstName, employeeLast: lastName);
  }

  static Map<String, dynamic> _mockFetchTransactionsByCustomerName(RequestOptions options) {
    final String? firstName = _parseStringFromUrl(url: options.path, needle: "customerFirst=");
    final String? lastName = _parseStringFromUrl(url: options.path, needle: "customerLast=");
    
    return _createTransactions(options: options, customerFirst: firstName, customerLast: lastName);
  }

  static Map<String, dynamic> _mockFetchTransactionById(RequestOptions options) {
    final String? transactionId = _parseStringFromUrl(url: options.path, needle: "id=");

    return _createTransactions(options: options, canPaginate: false, numberTransactions: 1, transactionId: transactionId);
  }


  static Map<String, dynamic> _mockFetchRefundsBase(RequestOptions options) {
    return _createRefunds(options: options);
  }

  static Map<String, dynamic> _mockFetchRefundsWithDate(RequestOptions options) {
    return _createRefunds(options: options);
  }

  static Map<String, dynamic> _mockFetchRefundsByCustomerName(RequestOptions options) {
    final String? firstName = _parseStringFromUrl(url: options.path, needle: "customerFirst=");
    final String? lastName = _parseStringFromUrl(url: options.path, needle: "customerLast=");

    return _createRefunds(options: options, customerFirst: firstName, customerLast: lastName);
  }

  static Map<String, dynamic> _mockFetchRefundById(RequestOptions options) {
    final String? refundId = _parseStringFromUrl(url: options.path, needle: "id=");

    return _createRefunds(options: options, numberRefunds: 1, refundId: refundId);
  }

  static Map<String, dynamic> _mockFetchRefundByTransactionId(RequestOptions options) {
    final String? transactionId = _parseStringFromUrl(url: options.path, needle: "transactionId=");

    return _createRefunds(options: options, transactionId: transactionId);
  }

  static Map<String, dynamic> _mockFetchRefundsByCustomerId(RequestOptions options) {
    final String? customerId = _parseStringFromUrl(url: options.path, needle: "customer=");

    return _createRefunds(options: options, customerId: customerId);
  }

  static Map<String, dynamic> _mockFetchEmployeeTipsAll(RequestOptions options) {
    final bool doPaginate = faker.randomGenerator.boolean();
    final int numberTips = doPaginate ? 25 : _randomInt(floor: 1, ceiling: 25);
    final List<Map<String, dynamic>> data = List.generate(
      numberTips, 
      (index) {
        return generateEmployeeTip();
      }
    );

    String baseUrl = options.path;
    int currentPage = 1;

    if (options.path.contains('page=')) {
      List<String> urlSplit = options.path.split('page=');
      baseUrl = urlSplit[0];
      currentPage = int.parse(urlSplit[1]);
    } else {
      baseUrl = baseUrl.contains('?')
        ? "$baseUrl&"
        : "$baseUrl?";
    }

    return {
      'data': data,
      'links': {
        "first": baseUrl + "page=1",
        "last": doPaginate 
          ? baseUrl + "page=" + (currentPage + 1).toString()
          : baseUrl + "page=1",
        "prev": currentPage > 1
          ? baseUrl + 'page=' + (currentPage - 1).toString()
          : null,
        "next": doPaginate
          ? baseUrl + 'page=' + (currentPage + 1).toString()
          : null
      },
      'meta': {
        'current_page': 1,
        'from': 1,
        'last_page': 1,
        'path': 'http://novapay.ai/api/business/tips',
        'per_page': 25,
        'to': 1,
        'total': 10
      }
    };
  }

  static Map<String, dynamic> _mockFetchEmployeeTipsSingle(RequestOptions options) {
    return {
      'data': List.generate(
        3, 
        (index) {
          return generateEmployeeTip();
        }
      )
    };
  }

  static Map<String, dynamic> _mockFetchHasUnreadMessages() {
    return {
      'data': {
        'unread': true
      }
    };
  }

  static Map<String, dynamic> _mockFetchMessages(RequestOptions options) {
    return _createMessages(options: options);
  }

  static Map<String, dynamic> _mockStoreMessage(RequestOptions options) {
    return {
      'data': {
        'identifier': _createIdentifier(),
        'title': options.data['title'],
        'body': options.data['body'],
        'sent_by_business': true,
        'read': false,
        'unread_reply': false,
        'latest_reply': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'replies': []
      }
    };
  }
  
  static Map<String, dynamic> _mockStoreReply(RequestOptions options) {
    return {
      'data': {
        'identifier': _createIdentifier(),
        'body': options.data['body'],
        'sent_by_business': true,
        'read': false,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      }
    };
  }

  static Map<String, dynamic> _mockUpdateMessage(RequestOptions options) {
    return {
      'data': {
        'identifier': _createIdentifier(),
        'title': 'title',
        'body': 'body',
        'sent_by_business': false,
        'read': true,
        'unread_reply': false,
        'latest_reply': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'replies': []
      }
    };
  }

  static Map<String, dynamic> _mockRequestReset() {
    return {
      'data': {
        'email_sent': true,
        'res': "passwords.sent"
      }
    };
  }

  static Map<String, dynamic> _mockResetPassword() {
    return {
      'data': {
        'reset': true,
        'res': 'passwords.reset'
      }
    };
  }

  static Map<String, dynamic> _mockFetchTransactionStatuses() {
    return {
      'data': [
        {
          'name': 'Open',
          'code': 100
        },
        {
          'name': 'Closed',
          'code': 101
        },
        {
          'name': 'Payment Processing',
          'code': 103
        },
        {
          'name': 'Customer Approved',
          'code': 104
        },
        {
          'name': "Keep Open Notification Sent",
          'code': 105
        },
        {
          'name': "Customer Request Keep Open",
          'code': 106
        },
        {
          'name': "Paid",
          'code': 200
        },
        {
          'name': 'Wrong Bill Assigned',
          'code': 500
        },
        {
          'name': 'Error in Bill',
          'code': 501
        },
        {
          'name': 'Error Notifying',
          'code': 502
        },
        {
          'name': 'Other Bill Error',
          'code': 503
        },
      ]
    };
  }

  static Map<String, dynamic> _mockFetchUnassigned({required RequestOptions options}) {
    final bool doPaginate = faker.randomGenerator.boolean();
    final int numberTransactions = doPaginate ? 25 : _randomInt(floor: 1, ceiling: 25);
    final List<Map<String, dynamic>> data = List.generate(
      numberTransactions, 
      (index) {
        return generateUnassignedTransaction(index: index);
      }
    );

    String baseUrl = options.path;
    int currentPage = 1;

    if (options.path.contains('page=')) {
      List<String> urlSplit = options.path.split('page=');
      baseUrl = urlSplit[0];
      currentPage = int.parse(urlSplit[1]);
    } else {
      baseUrl = baseUrl.contains('?')
        ? "$baseUrl&"
        : "$baseUrl?";
    }

    return {
      'data': data,
      'links': {
        "first": baseUrl + "page=1",
        "last": doPaginate 
          ? baseUrl + "page=" + (currentPage + 1).toString()
          : baseUrl + "page=1",
        "prev": currentPage > 1
          ? baseUrl + 'page=' + (currentPage - 1).toString()
          : null,
        "next": doPaginate
          ? baseUrl + 'page=' + (currentPage + 1).toString()
          : null
      },
      'meta': {
        'current_page': 1,
        'from': 1,
        'last_page': 1,
        'path': 'http://novapay.ai/api/business/unassigned-transactions',
        'per_page': 25,
        'to': 1,
        'total': 10
      }
    };
  }

  static Map<String, dynamic> _mockFetchAllCustomers(RequestOptions options) {
    final bool doPaginate = faker.randomGenerator.boolean();
    final int numberCustomers = doPaginate ? 25 : _randomInt(floor: 1, ceiling: 25);
    
    final List<Map<String, dynamic>> data = List.generate(
      numberCustomers, 
      (index) {
        return generateCustomerResource(index: index);
      }
    );

    String baseUrl = options.path;
    int currentPage = 1;

    if (options.path.contains('page=')) {
      List<String> urlSplit = options.path.split('page=');
      baseUrl = urlSplit[0];
      currentPage = int.parse(urlSplit[1]);
    } else {
      baseUrl = baseUrl.contains('?')
        ? "$baseUrl&"
        : "$baseUrl?";
    }

    return {
      'data': data,
      'links': {
        "first": baseUrl + "page=1",
        "last": doPaginate 
          ? baseUrl + "page=" + (currentPage + 1).toString()
          : baseUrl + "page=1",
        "prev": currentPage > 1
          ? baseUrl + 'page=' + (currentPage - 1).toString()
          : null,
        "next": doPaginate
          ? baseUrl + 'page=' + (currentPage + 1).toString()
          : null
      },
      'meta': {
        'current_page': 1,
        'from': 1,
        'last_page': 1,
        'path': 'http://novapay.ai/api/business/customer',
        'per_page': 25,
        'to': 1,
        'total': 10
      }
    };
  }







  
  
  
  
  
  
  
  
  
  
  
  static Map<String, dynamic> _createTransactions({
    required RequestOptions options,
    int? numberTransactions, 
    String? transactionId,
    Status? status,
    String? customerId,
    String? customerFirst,
    String? customerLast,
    String? employeeFirst,
    String? employeeLast,
    bool hasEmployees = true, 
    bool hasRefunds = false,
    bool canPaginate = true,
  }) {
    final bool doPaginate = canPaginate && faker.randomGenerator.boolean();
    numberTransactions = doPaginate 
      ? 25 
      : numberTransactions ?? _randomInt(floor: 1, ceiling: 25);
    
    final List<Map<String, dynamic>> data = List.generate(
      numberTransactions,
      (index) {
        return generateTransactionResource(
          index: index,
          transactionId: transactionId,
          status: status,
          customerId: customerId,
          customerFirst: customerFirst,
          customerLast: customerLast,
          hasEmployees: hasEmployees,
          employeeFirst: employeeFirst,
          employeeLast: employeeLast,
          hasRefunds: hasRefunds
        );
      } 
    );
    
    String baseUrl = options.path;
    int currentPage = 1;

    if (options.path.contains('page=')) {
      List<String> urlSplit = options.path.split('page=');
      baseUrl = urlSplit[0];
      currentPage = int.parse(urlSplit[1]);
    } else {
      baseUrl = baseUrl.contains('?')
        ? "$baseUrl&"
        : "$baseUrl?";
    }

    return {
      'data': data,
      'links': {
        "first": baseUrl + "page=1",
        "last": doPaginate 
          ? baseUrl + "page=" + (currentPage + 1).toString()
          : baseUrl + "page=1",
        "prev": currentPage > 1
          ? baseUrl + 'page=' + (currentPage - 1).toString()
          : null,
        "next": doPaginate
          ? baseUrl + 'page=' + (currentPage + 1).toString()
          : null
      },
      'meta': {
        'current_page': 1,
        'from': 1,
        'last_page': 1,
        'path': 'http://novapay.ai/api/business/transaction',
        'per_page': 25,
        'to': 1,
        'total': 10
      }
    };
  }

  static Map<String, dynamic> _createMessages({required RequestOptions options}) {
    final bool doPaginate = faker.randomGenerator.boolean();
    final int numberMessages = doPaginate 
      ? 25 
      : _randomInt(floor: 1, ceiling: 25);

    final List<Map<String, dynamic>> data = List.generate(
      numberMessages, 
      (index) => generateMessage(index: index));

    String baseUrl = options.path;
    int currentPage = 1;

    if (options.path.contains('page=')) {
      List<String> urlSplit = options.path.split('page=');
      baseUrl = urlSplit[0];
      currentPage = int.parse(urlSplit[1]);
    } else {
      baseUrl = baseUrl.contains('?')
        ? "$baseUrl&"
        : "$baseUrl?";
    }

    return {
      'data': data,
      'links': {
        "first": baseUrl + "page=1",
        "last": doPaginate 
          ? baseUrl + "page=" + (currentPage + 1).toString()
          : baseUrl + "page=1",
        "prev": currentPage > 1
          ? baseUrl + 'page=' + (currentPage - 1).toString()
          : null,
        "next": doPaginate
          ? baseUrl + 'page=' + (currentPage + 1).toString()
          : null
      },
      'meta': {
        'current_page': 1,
        'from': 1,
        'last_page': 1,
        'path': 'http://novapay.ai/api/business/message',
        'per_page': 25,
        'to': 1,
        'total': 10
      }
    };
  }
  
  static Map<String, dynamic> _createRefunds({
    required RequestOptions options,
    int? numberRefunds,
    String? refundId,
    String? transactionId,
    String? customerFirst,
    String? customerLast,
    String? customerId,
    bool canPaginate = true,
  }) {
    final bool doPaginate = canPaginate && faker.randomGenerator.boolean();
    numberRefunds = doPaginate 
      ? 25 
      : numberRefunds ?? _randomInt(floor: 1, ceiling: 25);

    final List<Map<String, dynamic>> data = List.generate(
      numberRefunds, 
      (index) {
        return generateRefundResource(
          index: index,
          refundId: refundId,
          transactionId: transactionId,
          customerFirst: customerFirst,
          customerLast: customerLast,
          customerId: customerId
        );
      }
    );

    String baseUrl = options.path;
    int currentPage = 1;

    if (options.path.contains('page=')) {
      List<String> urlSplit = options.path.split('page=');
      baseUrl = urlSplit[0];
      currentPage = int.parse(urlSplit[1]);
    } else {
      baseUrl = baseUrl.contains('?')
        ? "$baseUrl&"
        : "$baseUrl?";
    }

    return {
      'data': data,
      'links': {
        "first": baseUrl + "page=1",
        "last": doPaginate 
          ? baseUrl + "page=" + (currentPage + 1).toString()
          : baseUrl + "page=1",
        "prev": currentPage > 1
          ? baseUrl + 'page=' + (currentPage - 1).toString()
          : null,
        "next": doPaginate
          ? baseUrl + 'page=' + (currentPage + 1).toString()
          : null
      },
      'meta': {
        'current_page': 1,
        'from': 1,
        'last_page': 1,
        'path': 'http://novapay.ai/api/business/transaction',
        'per_page': 25,
        'to': 1,
        'total': 10
      }
    };
  }

  static Map<String, dynamic> generateTransaction({int index = 0, String? transactionId, Status? status}) {
    final DateTime now = DateTime.now();
    
    final int netSales = _randomInt(floor: 500, ceiling: 25000);
    final int tax = (netSales * .0475).round();
    final int tip = _randomInt(floor: 0, ceiling: 1) * ((netSales + tax) * ((_randomInt(floor: 5, ceiling: 25)) / 100)).round();
    final int total = netSales + tax + tip;
    final DateTime billDate = DateTime(now.year, now.month, now.day - index);
    return {
      'identifier': transactionId ?? _createIdentifier(),
      'tax': tax,
      'tip': tip,
      'net_sales': netSales,
      'total': total,
      'partial_payment': "0",
      'locked': true,
      'bill_created_at': billDate.toIso8601String(),
      'updated_at': billDate.toIso8601String(),
      'status': {
        'name': status == null ? 'paid': status.name,
        'code': status == null ? 200 : status.code
      }
    };
  }

  static Map<String, dynamic> generateRefund({int index = 0, String? refundId}) {
    final DateTime now = DateTime.now();
    final DateTime refundDate = DateTime(now.year, now.month, now.day - index);

    return {
      'identifier': refundId ?? _createIdentifier(),
      'total': _randomInt(floor: 100, ceiling: 500),
      'status': faker.randomGenerator.boolean() ? 'refund paid' : 'refund pending',
      'created_at': refundDate.toIso8601String()
    };
  }

  static Map<String, dynamic> generateMessage({int index = 0}) {
    final DateTime now = DateTime.now();
    final String messageDate = DateTime(now.year, now.month, now.day - index).toIso8601String();

    final bool fromBusiness = faker.randomGenerator.boolean();
    final bool hasUnreadReply = faker.randomGenerator.boolean();
    
    return {
      'identifier': _createIdentifier(),
      'title': faker.lorem.sentence(),
      'body': faker.lorem.sentences(_randomInt(floor: 2, ceiling: 5)).reduce((value, element) => "$value. $element"),
      'sent_by_business': fromBusiness,
      'read': fromBusiness ? true : faker.randomGenerator.boolean(),
      'unread_reply': hasUnreadReply,
      'latest_reply': messageDate,
      'created_at': messageDate,
      'updated_at': messageDate,
      'replies': _generateReplies(hasUnreadReply: hasUnreadReply, index: index)
    };
  }
  
  static Map<String, dynamic> generateCustomer({String? customerId, String? customerFirst, String? customerLast}) {
    return {
      'identifier': customerId ?? _createIdentifier(),
      'email': faker.internet.email(),
      'first_name': customerFirst ?? faker.person.firstName(),
      'last_name': customerLast ?? faker.person.lastName(),
      'photo': generatePhoto()
    };
  }

  static Map<String, dynamic> generatePhoto() {
    return {
      'name': faker.lorem.word(),
      'small_url': faker.image.image(width: 250, height: 250, keywords: ['person']),
      'large_url': faker.image.image(width: 500, height: 500, keywords: ['person'])
    };
  }

  static Map<String, dynamic> generateEmployee({String? employeeFirst, String? employeeLast}) {
    return {
      'identifier': _createIdentifier(),
      'external_id': faker.guid.guid(),
      'first_name': employeeFirst ?? faker.person.firstName(),
      'last_name': employeeLast ?? faker.person.lastName(),
      'email': faker.randomGenerator.boolean() ? faker.internet.email() : null
    };
  }

  static List<Map<String, dynamic>> _generateRefunds({required bool hasRefunds, required int index}) {
    if (!hasRefunds) return [];

    final bool createRefunds = faker.randomGenerator.boolean();
    if (!createRefunds) return [];

    final int numberRefunds = _randomInt(floor: 1, ceiling: 4);

    return List.generate(numberRefunds, (index) {
      return generateRefund(index: index);
    });
  }

  static List<Map<String, dynamic>> _generateReplies({required bool hasUnreadReply, required int index}) {
    final bool hasReplies = hasUnreadReply || faker.randomGenerator.boolean();
    if (!hasReplies) return [];

    final int numberReplies = _randomInt(floor: 1, ceiling: 15);
    final DateTime now = DateTime.now();
    final DateTime replyDate = DateTime(now.year, now.month, now.day - index);

    return List.generate(
      numberReplies, 
      (index) {
        return generateReply(index: index, replyDate: replyDate, hasUnreadReply: hasUnreadReply);
      }
    );
  }

  static List<Map<String, dynamic>> _generatePurchasedItems() {
    final int numberPurchasedItems = _randomInt(floor: 1, ceiling: 10);
    
    return List.generate(numberPurchasedItems, (index) {
      return generatePurchasedItem();
    });
  }

  static Map<String, dynamic> generateIssue() {
    final List<String> issueTypes = ['wrong_bill', 'error_in_bill', 'other'];
    return {
      'identifier': _createIdentifier(),
      'type': issueTypes[_randomInt(floor: 0, ceiling: 2)],
      'issue': faker.lorem.sentence(),
      'resolved': faker.randomGenerator.boolean(),
      'updated_at': DateTime.now().toIso8601String()
    };
  }

  static Map<String, dynamic> generateAddress() {
    return {
      'address': faker.address.streetAddress(),
      'address_secondary': faker.randomGenerator.boolean() ? faker.address.buildingNumber() : null,
      'city': faker.address.city(),
      'state': 'NC',
      'zip': faker.address.zipCode()
    };
  }

  static Map<String, dynamic> generateBankAccount() {
    return {
      'identifier': _createIdentifier(),
      'address': {
        'address': faker.address.streetAddress(),
        'address_secondary': faker.address.buildingNumber(),
        'city': faker.address.city(),
        'state': 'NC',
        'zip': faker.address.zipCode()
      },
      'first_name': faker.person.firstName(),
      'last_name': faker.person.lastName(),
      'routing_number': 'XXXXX2731',
      'account_number': 'XXXXX4278',
      'account_type': 'checking'
    };
  }

  static Map<String, dynamic> generateBusinessAccount() {
    return {
      'identifier': _createIdentifier(),
      'ein': faker.randomGenerator.boolean() ? "12-3456789" : null,
      'business_name': faker.company.name(),
      'address': generateAddress(),
      'entity_type': 'llc'
    };
  }

  static Map<String, dynamic> generateEmployeeTip() {
    return {
      'first_name': faker.person.firstName(),
      'last_name': faker.person.lastName(),
      'tips': _randomInt(floor: 100, ceiling: 2000)
    };
  }

  static Map<String, dynamic> generateHours({String earliest = "8:00 AM", String latest = "1:00 AM"}) {
    return {
      'identifier': _createIdentifier(),
      'sunday': "10:00 AM - 9:00 PM",
      'monday': "closed",
      'tuesday': "12:00 PM - 9:00 PM",
      'wednesday': "$earliest - 9:00 PM",
      'thursday': "10:00 AM - 11:00 PM",
      'friday': "9:00 AM - $latest",
      'saturday': "11:00 AM - 9:00 PM",
    };
  }

  static Map<String, dynamic> generateLocation() {
    return {
      'identifier': _createIdentifier(),
      'lat': 35.927560,
      'lng': -79.035534,
      'radius': 50
    };
  }

  static Map<String, dynamic> generateOwnerAccount() {
    return {
      'identifier': _createIdentifier(),
      'address': {
        'address': faker.address.streetAddress(),
        'address_secondary': "",
        'city': faker.address.city(),
        'state': "NC",
        'zip': faker.address.zipCode()
      },
      'dob': '05/28/1980',
      'ssn': "XXXXX3738",
      'last_name': faker.person.lastName(),
      'first_name': faker.person.firstName(),
      'title': faker.job.title(),
      'phone': '3629632518',
      'email': faker.internet.email(),
      'primary': true,
      'percent_ownership': 25
    };
  }

  static Map<String, dynamic> generatePosAccount() {
    return {
      'identifier': _createIdentifier(),
      'type': 'square',
      'takes_tips': true,
      'allows_open_tickets': true,
      'status': {
        'name': 'Successfully Connected',
        'code': 200
      }
    };
  }

  static Map<String, dynamic> generateAccounts() {
    return {
      'business_account': generateBusinessAccount(),
      'owner_accounts': [
        generateOwnerAccount()
      ],
      'bank_account': generateBankAccount(),
      'account_status': {
        'name': 'Account Active',
        'code': 200
      }
    };
  }

  static Map<String, dynamic> generatePhotos() {
    return {
      'logo':  {
        'name': faker.lorem.word(),
        'small_url': faker.image.image(width: 200, height: 200, keywords: ['logo']),
        'large_url': faker.image.image(width: 400, height: 400, keywords: ['logo'])
      },
      'banner': {
        'name': faker.lorem.word(),
        'small_url': faker.image.image(width: 500, height: 325, keywords: ['logo']),
        'large_url': faker.image.image(width: 1000, height: 650, keywords: ['logo'])
      },
    };
  }

  static Map<String, dynamic> generateProfile() {
    return {
      'identifier': _createIdentifier(),
      'name': faker.company.name(),
      'website': "www.${faker.lorem.word()}.com",
      'description': faker.lorem.sentences(5).join(),
      'phone': '7896523645',
      'hours': generateHours()
    };
  }

  static Map<String, dynamic> generateBusiness() {
    return {
      'identifier': _createIdentifier(),
      'email': faker.internet.email(),
      'profile': generateProfile(),
      'photos': generatePhotos(),
      'accounts': generateAccounts(),
      'location': generateLocation(),
      'pos_account': generatePosAccount()
    };
  }

  static Map<String, dynamic> generateNotification() {
    final DateTime now = DateTime.now();
    return {
      'last': "auto_paid_sent",
      'exit_sent': true,
      'time_exit_sent': DateTime(now.year, now.month, now.day, now.hour - _randomInt(floor: 1, ceiling: 10)).toIso8601String(),
      'bill_closed_sent': true,
      'time_bill_closed_sent': DateTime(now.year, now.month, now.day, now.hour - _randomInt(floor: 1, ceiling: 10)).toIso8601String(),
      'auto_paid_sent': true,
      'time_auto_paid_sent': DateTime(now.year, now.month, now.day, now.hour - _randomInt(floor: 1, ceiling: 10)).toIso8601String(),
      'fix_bill_sent': faker.randomGenerator.boolean(),
      'time_fix_bill_sent': DateTime(now.year, now.month, now.day, now.hour - _randomInt(floor: 1, ceiling: 10)).toIso8601String(),
      'number_times_fix_bill_sent': 2,
      'updated_at': now.toIso8601String()
    };
  }

  static Map<String, dynamic> generateCustomerTransaction({int? index}) {
    Map<String, dynamic> transaction = generateTransaction(index: index ?? 0);
    final Map<String, dynamic> purchasedItems = { 'purchased_items': _generatePurchasedItems() };
    final Map<String, dynamic> refunds =  { 'refunds': _generateRefunds(hasRefunds: faker.randomGenerator.boolean(), index: index ?? 0) };
    transaction.addAll(purchasedItems..addAll(refunds));
    return transaction;
  }

  static Map<String, dynamic> generateCustomerResource({int? index}) {
    final DateTime now = DateTime.now();
    return {
      'customer': generateCustomer(),
      'transaction': generateCustomerTransaction(index: index),
      'notification': generateNotification(),
      'entered_at': DateTime(now.year, now.month, now.day, now.hour - _randomInt(floor: 1, ceiling: 15)).toIso8601String(),
    };
  }

  static Map<String, dynamic> generateReply({int index = 0, bool hasUnreadReply = true, DateTime? replyDate}) {
    final bool fromBusiness = faker.randomGenerator.boolean();
    replyDate = replyDate ?? DateTime.now();
    return {
      'identifier': _createIdentifier(),
      'body': faker.lorem.sentences(_randomInt(floor: 1, ceiling: 6)).reduce((value, element) => "$value. $element"),
      'sent_by_business': fromBusiness,
      'read': !(index == 0 && hasUnreadReply),
      'created_at': DateTime(replyDate.year, replyDate.month, replyDate.day - index).toIso8601String(),
      'updated_at': DateTime(replyDate.year, replyDate.month, replyDate.day - index).toIso8601String()
    };
  }

  static Map<String, dynamic> generateRefundResource({
    int index = 0,
    String? refundId,
    String? transactionId,
    String? customerFirst,
    String? customerLast,
    String? customerId
  }) {
    final Map<String, dynamic> refund = generateRefund(index: index, refundId: refundId);
    return {
      'refund': refund,
      'transaction_resource': {
        'transaction': generateTransaction(transactionId: transactionId, index: index),
        'customer': generateCustomer(customerId: customerId, customerFirst: customerFirst, customerLast: customerLast),
        'employee': faker.randomGenerator.boolean() ? generateEmployee() : null,
        'refunds': _generateRefunds(hasRefunds: true, index: index)..add(refund),
        'purchased_items': _generatePurchasedItems(),
        'issue': generateIssue()
      }
    };
  }

  static Map<String, dynamic> generatePurchasedItem() {
    final int price = _randomInt(floor: 50, ceiling: 5000);
    final int quantity = _randomInt(floor: 1, ceiling: 5);
    
    return {
      'name': faker.lorem.word(),
      'sub_name': faker.randomGenerator.boolean() ? faker.lorem.word() : null,
      'price': price,
      'main_id': faker.guid.guid(),
      'sub_id': faker.randomGenerator.boolean() ? faker.guid.guid() : null,
      'quantity': quantity,
      'total': price * quantity
    };
  }

  static Map<String, dynamic> generateTransactionResource({
    int index = 0,
    String? transactionId,
    Status? status,
    String? customerId,
    String? customerFirst,
    String? customerLast,
    bool hasEmployees = true,
    String? employeeFirst,
    String? employeeLast,
    bool hasRefunds = true
  }) {
    return {
      'transaction': generateTransaction(transactionId: transactionId, index: index, status: status),
      'customer': generateCustomer(customerId: customerId, customerFirst: customerFirst, customerLast: customerLast),
      'employee': hasEmployees ? generateEmployee(employeeFirst: employeeFirst, employeeLast: employeeLast) : (faker.randomGenerator.boolean() ? generateEmployee() : null),
      'refunds': _generateRefunds(hasRefunds: hasRefunds, index: index),
      'purchased_items': _generatePurchasedItems(),
      'issue': generateIssue()
    };
  }

  static Map<String, dynamic> generateUnassignedTransaction({int index = 0}) {
    return {
      'transaction': generateUnAssignedTransactionTransaction(),
      'employee': generateEmployee()
    };
  }

  static Map<String, dynamic> generateUnAssignedTransactionTransaction({int index = 0}) {
    final int netSales = _randomInt(floor: 100, ceiling: 10000);
    final int taxes = (netSales * 0.1).round();
    final int total = netSales + taxes;
    final DateTime now = DateTime.now();
    
    return {
      'identifier': _createIdentifier(),
      'tax': taxes,
      'net_sales': netSales,
      'total': total,
      'created_at': DateTime(now.year, now.month, now.day - index).toIso8601String(),
      'updated_at': DateTime(now.year, now.month, now.day - index).toIso8601String(),
      'purchased_items': _generatePurchasedItems()
    };
  }

  static int _randomInt({required int floor, required int ceiling}) {
    final Random _rnd = Random();
    return floor + _rnd.nextInt(ceiling - floor);
  }

  static String _createIdentifier() {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(32, 
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
    ));
  }

  static String? _parseStringFromUrl({required String url, required String needle}) {
    if (!url.contains(needle)) return null;

    String foundNeedle;
    final String splitFirst = url.split(needle)[1];
    if (splitFirst.contains("&")) {
      foundNeedle = splitFirst.substring(0, splitFirst.indexOf("&"));
    } else {
      foundNeedle = splitFirst;
    }

    return foundNeedle;
  }
}