// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Order {
  final String id;
  final String name;
  final String phone;
  final String country;
  final String city;
  final String address;
  final String state;
  final String pin;
  final String productName;
  final int quantity;
  final String category;
  final String image;
  final int totalAmount;
  final String paymentStatus;
  final bool delivered;
  Order({
    required this.id,
    required this.name,
    required this.phone,
    required this.country,
    required this.city,
    required this.pin,
    required this.state,
    required this.address,
    required this.productName,
    required this.quantity,
    required this.category,
    required this.image,
    required this.totalAmount,
    required this.paymentStatus,
    required this.delivered,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': id,
      'name': name,
      'phone': phone,
      'country': country,
      'city': city,
      'state': state,
      'pin': pin,
      'address': address,
      'productName': productName,
      'quantity': quantity,
      'category': category,
      'image': image,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'delivered': delivered,
    };
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['userId'] as String? ?? '', // Default to empty string if null
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      state: map['state'] as String? ?? '',
      pin: map['pin'] as String? ?? '',
      country: map['country'] as String? ?? '',
      city: map['city'] as String? ?? '',
      address: map['address'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      quantity: (map['quantity'] is int)
          ? map['quantity'] as int
          : int.tryParse(map['quantity'] as String) ?? 0,
      category: map['category'] as String? ?? '',
      image: map['image'] as String? ?? '',
      totalAmount: (map['totalAmount'] is int)
          ? map['totalAmount'] as int
          : int.tryParse(map['totalAmount'] as String) ?? 0,
      paymentStatus: map['paymentStatus'] as String? ?? 'Pending',
      delivered: map['delivered'] as bool? ?? false,
    );
  }
}
