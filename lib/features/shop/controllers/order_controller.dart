import 'dart:convert';

import 'package:kiska_admin/features/shop/global_variables.dart';
import 'package:kiska_admin/features/shop/models/order.dart';
import 'package:http/http.dart' as http;

class OrderController { 
  Future<List<Order>> loadOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$uri/api/all-orders/'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((orderJson) => Order.fromJson(orderJson)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading orders: $e'); // Logs detailed error
      throw Exception('Error loading orders: $e');
    }
  }
}