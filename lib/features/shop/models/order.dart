import 'dart:convert';

class Order {
  final String id; // Order ID (MongoDB _id)
  final String userId; // User ID (refers to the user who placed the order)
  final String name;
  final String phone;
  final String country;
  final String city;
  final String address;
  final String state;
  final String pin;
  final String productName;
  final int quantity; // Ensuring quantity is an integer
  final String category;
  final String image;
  final int totalAmount; // Ensuring totalAmount is an integer
  final String paymentStatus; // Payment status like 'Pending', 'Success'
  final bool delivered; // Boolean for delivered status

  Order({
    required this.id,
    required this.userId, // Include userId
    required this.name,
    required this.phone,
    required this.country,
    required this.city,
    required this.state,
    required this.pin,
    required this.address,
    required this.productName,
    required this.quantity,
    required this.category,
    required this.image,
    required this.totalAmount,
    required this.paymentStatus,
    required this.delivered,
  });

  // Convert the Order object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id, // MongoDB _id
      'userId': userId, // Reference to the user who placed the order
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

  // Convert the Order object to JSON
  String toJson() => json.encode(toMap());

  // Factory constructor to create an Order from a Map (e.g., from a response)
  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String? ?? '', // MongoDB _id is typically returned as '_id'
      userId: map['userId'] as String? ?? '', // Add userId from the response
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
