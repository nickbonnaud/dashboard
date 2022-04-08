import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PurchasedItem extends Equatable {
  final String name;
  final String? subName;
  final int price;
  final String mainId;
  final String? subId;
  final int quantity;
  final int total;

  const PurchasedItem({
    required this.name, 
    this.subName, 
    required this.price,
    required this.mainId,
    this.subId,
    required this.quantity,
    required this.total
  });

  PurchasedItem.fromJson({required Map<String, dynamic> json})
    : name = json['name']!,
      subName = json['sub_name'],
      price = json['price']!,
      mainId = json['main_id']!,
      subId = json['sub_id'],
      quantity = json['quantity']!,
      total = json['total']!;

  @override
  List<Object?> get props => [
    name,
    subName,
    price,
    mainId,
    subId,
    quantity,
    price
  ];

  @override
  String toString() => '''PurchasedItem {
    name: $name,
    subName: $subName,
    price: $price,
    mainId: $mainId,
    subId: $subId,
    quantity: $quantity,
    price: $price
  }''';
}