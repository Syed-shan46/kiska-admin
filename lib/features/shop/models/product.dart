// The following lines are ignore rules for the Dart analyzer.
// These rules tell the analyzer to ignore warnings or recommendations for
// missing public member documentation and constructor sorting order.
// This is useful when you are focusing on functionality and want to skip
// certain formatting or documentation rules.
// `ignore_for_file: public_member_api_docs, sort_constructors_first`
import 'dart:convert'; // Importing the `dart:convert` library to allow JSON encoding and decoding.

// Defining a class named `Product` that represents a product object with multiple properties.
class Product {
  // Final variables for each product property. `final` means that these variables
  // can only be set once and cannot be changed later.
  final String id; // Unique identifier for the product.
  final String productName; // Name of the product.
  final int productPrice; // Price of the product (stored as an integer).
  final int quantity; // Quantity of the product available in stock.
  final String description; // Detailed description of the product.
  final String category; // Category to which the product belongs.
  final List<String>
      images; // List of image URLs or paths associated with the product.

  // The constructor for the `Product` class. It takes all required parameters
  // to initialize a product object with specific values for each field.
  Product({
    required this.id, // Assigns the `id` parameter to the `id` property.
    required this.productName, // Assigns the `productName` parameter to the `productName` property.
    required this.productPrice, // Assigns the `productPrice` parameter to the `productPrice` property.
    required this.quantity, // Assigns the `quantity` parameter to the `quantity` property.
    required this.description, // Assigns the `description` parameter to the `description` property.
    required this.category, // Assigns the `category` parameter to the `category` property.
    required this.images, // Assigns the `images` parameter to the `images` property.
  });

  // Method `toMap` converts the `Product` object into a map (key-value pairs).
  // This is useful when you need to serialize the object to store it in a database or transfer it over a network.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id, // Storing the `id` field in the map with a key of 'id'.
      'productName':
          productName, // Storing the `productName` field in the map with a key of 'productName'.
      'productPrice':
          productPrice, // Storing the `productPrice` field in the map with a key of 'productPrice'.
      'quantity':
          quantity, // Storing the `quantity` field in the map with a key of 'quantity'.
      'description':
          description, // Storing the `description` field in the map with a key of 'description'.
      'category':
          category, // Storing the `category` field in the map with a key of 'category'.
      'images':
          images, // Storing the `images` list in the map with a key of 'images'.
    };
  }

  // `factory` constructor to create a `Product` object from a map.
  // The map is typically received from an external source like a database or API.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']
          as String, // Extracts the `id` from the map and assigns it to the `id` field.
      productName: map['productName']
          as String, // Extracts the `productName` from the map and assigns it.
      productPrice: map['productPrice']
          as int, // Extracts the `productPrice` from the map and assigns it.
      quantity: map['quantity']
          as int, // Extracts the `quantity` from the map and assigns it.
      description: map['description']
          as String, // Extracts the `description` from the map and assigns it.
      category: map['category']
          as String, // Extracts the `category` from the map and assigns it.
      // The `images` field is extracted as a list from the map. The `List<String>.from` method ensures
      // that the list is properly cast to a list of strings.
      images: List<String>.from((map['images'] as List<String>)),
    );
  }

  // Method `toJson` converts the `Product` object to a JSON string by first calling `toMap`
  // and then encoding the resulting map to JSON using `json.encode`.
  String toJson() => json.encode(toMap());

  // `factory` constructor to create a `Product` object from a JSON string.
  // It first decodes the JSON string into a map using `json.decode`, then
  // passes that map to the `fromMap` constructor to create the `Product`.
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
