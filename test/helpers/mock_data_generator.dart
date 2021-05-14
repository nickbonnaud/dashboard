import 'package:dashboard/models/business/address.dart' as BusinessAddress;
import 'package:dashboard/models/business/employee.dart';
import 'package:dashboard/models/business/hours.dart';
import 'package:dashboard/models/business/owner_account.dart';
import 'package:dashboard/models/business/photos.dart';
import 'package:dashboard/models/business/profile.dart';
import 'package:dashboard/models/customer/customer.dart';
import 'package:dashboard/models/customer/customer_resource.dart';
import 'package:dashboard/models/customer/notification.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/message/reply.dart';
import 'package:dashboard/models/photo.dart';
import 'package:dashboard/models/refund/refund.dart';
import 'package:dashboard/models/refund/refund_resource.dart';
import 'package:dashboard/models/status.dart';
import 'package:dashboard/models/customer/transaction.dart' as CustomerTransaction;
import 'package:dashboard/models/transaction/purchased_item.dart';
import 'package:dashboard/models/transaction/transaction.dart';
import 'package:dashboard/models/transaction/transaction_resource.dart';
import 'package:dashboard/models/unassigned_transaction/unassigned_transaction.dart';
import 'package:faker/faker.dart';
import 'package:dashboard/models/unassigned_transaction/transaction.dart' as Unassigned;

class MockDataGenerator {

  CustomerResource createCustomerResource({bool requiresTransaction = false, bool requiresRefund = false}) {
    return CustomerResource(
      customer: createCustomer(),
      transaction: requiresTransaction
        ? createCustomerTransaction(requiresRefund: requiresRefund) 
        : faker.randomGenerator.boolean()
          ? createCustomerTransaction(requiresRefund: requiresRefund)
          : null,
      notification: faker.randomGenerator.boolean()
        ? Notification(
            last: "Bill paid", 
            exitSent: true, 
            billClosedSent: true, 
            autoPaidSent: true, 
            fixBillSent: false, 
            numberTimesFixBillSent: 0, 
            updatedAt: faker.date.dateTime(minYear: 2018, maxYear: 2021), 
          )
        : null, 
      enteredAt: faker.date.dateTime(minYear: 2018, maxYear: 2021)
    );
  }

  CustomerTransaction.Transaction createCustomerTransaction({bool requiresRefund = false}) {
    return CustomerTransaction.Transaction(
      identifier: faker.guid.guid(), 
      tax: faker.randomGenerator.integer(1000, min: 100), 
      tip: faker.randomGenerator.integer(1000, min: 100),
      netSales: faker.randomGenerator.integer(1000, min: 100),
      total: faker.randomGenerator.integer(1000, min: 100),
      partialPayments: 0, 
      locked: true,
      billCreatedAt: faker.date.dateTime(minYear: 2018, maxYear: 2021),
      updatedAt: faker.date.dateTime(minYear: 2018, maxYear: 2021), 
      status: Status(name: "Paid", code: 200),
      refunds: requiresRefund
        ? List.generate(
            faker.randomGenerator.integer(3, min: 1), 
            (index) => createRefund())
        : faker.randomGenerator.boolean()
          ? List.generate(
              faker.randomGenerator.integer(3, min: 1), 
              (index) => createRefund())
          : [],
      purchasedItems: List.generate(
        faker.randomGenerator.integer(8, min: 1),
        (index) => createPurchasedItem())
    );
  }

  Refund createRefund() {
    return Refund(
      identifier: faker.guid.guid(),
      total: faker.randomGenerator.integer(1000, min: 100), 
      status: "Settled", 
      createdAt: faker.date.dateTime(minYear: 2018, maxYear: 2021), 
    );
  }

  PurchasedItem createPurchasedItem() {
    return PurchasedItem(
      name: faker.lorem.word(),
      subName: faker.lorem.word(),
      price: faker.randomGenerator.integer(1000, min: 50), 
      mainId: faker.guid.guid(), 
      quantity: faker.randomGenerator.integer(3, min: 1), 
      total: faker.randomGenerator.integer(1000, min: 100)
    );
  }

  Hours createHours() {
    return Hours(
      identifier: faker.guid.guid(),
      sunday: "closed",
      monday:"8:00 AM - 10:00 PM",
      tuesday: "8:00 AM - 10:00 PM",
      wednesday: "8:00 AM - 1:00 PM || 5:00 PM - 10:00 PM", 
      thursday: "8:00 AM - 10:00 PM",
      friday: "8:00 AM - 10:00 PM",
      saturday: "8:00 AM - 10:00 PM",
      empty: false
    );
  }

  Transaction createTransaction() {
    final int netSales = faker.randomGenerator.integer(10000, min: 100);
    final int tax = (netSales * 0.04).round();
    final int tip = ((netSales + tax) * 0.2).round();
    final int total = netSales + tax + tip;
    return Transaction(
      identifier: faker.guid.guid(), 
      tax: tax, 
      tip: tip,
      netSales: netSales,
      total: total,
      partialPayments: 0, 
      locked: true,
      createdAt: faker.date.dateTime(minYear: 2018, maxYear: 2021),
      updatedAt: faker.date.dateTime(minYear: 2018, maxYear: 2021),
      status: Status(name: "Paid", code: 200)
    );
  }

  Customer createCustomer() {
    return Customer(
      identifier: faker.guid.guid(), 
      email: faker.internet.email(), 
      firstName: faker.person.firstName(), 
      lastName: faker.person.lastName(), 
      photo: Photo(
        name: faker.guid.guid(), 
        smallUrl: faker.image.image(width: 250, height: 250, keywords: ['person']), 
        largeUrl: faker.image.image(width: 500, height: 500, keywords: ['person'])
      )
    );
  }
  
  TransactionResource createTransactionResource() {
    return TransactionResource(
      transaction: createTransaction(),
      customer: createCustomer(),
      refunds: List.generate(faker.randomGenerator.integer(3, min: 1), (index) => createRefund()),
      purchasedItems: List.generate(faker.randomGenerator.integer(4, min: 1), (index) => createPurchasedItem())
    );
  }

  UnassignedTransaction createUnassignedTransaction() {
    final int netSales = faker.randomGenerator.integer(10000, min: 100);
    final int tax = (netSales * 0.04).round();
    final int total = netSales + tax;
    return UnassignedTransaction(
      transaction: Unassigned.Transaction(
        identifier: faker.guid.guid(),
        netSales: netSales,
        tax: tax,
        total: total,
        purchasedItems: List<PurchasedItem>.generate(faker.randomGenerator.integer(4, min: 1), (index) => createPurchasedItem()),
        updatedAt: faker.date.dateTime(minYear: 2018, maxYear: 2021),
        createdAt: faker.date.dateTime(minYear: 2018, maxYear: 2021)
      ),
      employee: createEmployee()
    );
  }

  Employee createEmployee() {
    return Employee(
      identifier: faker.guid.guid(),
      externalId: faker.guid.guid(),
      firstName: faker.person.firstName(),
      lastName: faker.person.lastName()
    );
  }
  
  RefundResource createRefundResource() {
    return RefundResource(
      refund: Refund(
        identifier: faker.guid.guid(),
        total: faker.randomGenerator.integer(1000, min: 100),
        status: "Paid",
        createdAt: DateTime.now()
      ), 
      transactionResource: createTransactionResource()
    );
  }

  Message createMessage({required int index, int? numberReplies}) {
    DateTime now = DateTime.now();
    bool hasUnreadReply = index == 0;
    return Message(
      identifier: faker.guid.guid(),
      title: faker.lorem.sentence(),
      body: faker.lorem.sentences(faker.randomGenerator.integer(5, min: 1)).fold("", (previousValue, currentValue) => "$previousValue $currentValue").trim(),
      fromBusiness: index != 0,
      read: index != 0,
      unreadReply: hasUnreadReply,
      latestReply: DateTime(now.year, now.month, now.day - index),
      createdAt: DateTime(now.year, now.month, now.day - index),
      updatedAt: DateTime(now.year, now.month, now.day - index),
      replies: List.generate(numberReplies ?? faker.randomGenerator.integer(4, min: 1), 
        (_) => createReply(index: index))
    );
  }

  Reply createReply({int index = 1, String? body}) {
    DateTime now = DateTime.now();
    return Reply(
      identifier: faker.guid.guid(),
      body: body ?? faker.lorem.sentences(faker.randomGenerator.integer(5, min: 1)).fold("", (previousValue, currentValue) => "$previousValue $currentValue").trim(),
      fromBusiness: index != 0,
      read: index != 0,
      createdAt: DateTime(now.year, now.month, now.day - index),
      updatedAt: DateTime(now.year, now.month, now.day - index),
    );
  }

  OwnerAccount createOwner({required int index}) {
    return OwnerAccount(
      identifier: faker.guid.guid(),
      dob: "11/12/1990",
      ssn: "123456789",
      firstName: faker.person.firstName(),
      lastName: faker.person.lastName(),
      title: faker.company.position(),
      phone: faker.phoneNumber.us(), 
      email: faker.internet.email(),
      primary: index == 0,
      percentOwnership: 10, 
      address: BusinessAddress.Address(
        address: faker.address.streetAddress(),
        addressSecondary: faker.address.buildingNumber(),
        city: faker.address.city(),
        state: 'NC',
        zip: faker.address.zipCode()
      )
    );
  }

  Photos createBusinessPhotos() {
    return Photos(
      logo: Photo(
        name: faker.guid.guid(),
        smallUrl: faker.image.image(width: 200, height: 200, keywords: ['logo']),
        largeUrl: faker.image.image(width: 400, height: 400, keywords: ['logo'])
      ),
      banner: Photo(
        name: faker.guid.guid(),
        smallUrl: faker.image.image(width: 500, height: 325, keywords: ['logo']),
        largeUrl: faker.image.image(width: 1000, height: 650, keywords: ['logo'])
      )
    );
  }

  Profile createProfile() {
    return Profile(
      identifier: faker.guid.guid(),
      name: faker.company.name(),
      website: "www.${faker.lorem.word()}.com",
      description: faker.lorem.sentences(5).join(),
      phone: "9362963431",
      hours: createHours()
    );
  }
}