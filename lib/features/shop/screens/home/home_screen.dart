import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiska_admin/features/shop/controllers/order_controller.dart';
import 'package:kiska_admin/features/shop/global_variables.dart';
import 'package:kiska_admin/features/shop/models/order.dart';
import 'package:kiska_admin/providers/order_provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<bool> _isButtonDisabled = [];
  List<String> _buttonTexts = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Fetch Orders
  Future<void> _fetchOrders() async {
    final orderController = OrderController();
    try {
      final orders = await orderController.loadOrders();
      ref.read(orderProvider.notifier).setOrders(orders);

      // Initialize button states
      setState(() {
        _isButtonDisabled = List<bool>.filled(orders.length, false);
        _buttonTexts = List<String>.filled(orders.length, "Accept Order");
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  // API Call for Accepting Order
  Future<void> _acceptOrder(String orderId, int index) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/api/accept-order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'orderId': orderId}),
      );

      if (response.statusCode == 200) {
        print('Order accepted successfully.');
        setState(() {
          _isButtonDisabled[index] = true;
          _buttonTexts[index] = "Order Accepted";
        });
      } else {
        print('Error accepting order: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders found now'),
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Product Image
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.cyan.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.network(order.image),
                              ),
                              const SizedBox(width: 16),

                              // Order Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Category
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.cyan.withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(order.category),
                                        ),

                                        // Total Price
                                        Text(
                                          '₹${order.totalAmount}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Product Name
                                    Text(
                                      order.productName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                    const SizedBox(height: 4),

                                    // Quantity
                                    Text('Quantity: ${order.quantity}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Delivery Address
                          Text(
                            'Delivery Address',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text('${order.country}, ${order.city}'),
                          const SizedBox(height: 4),
                          Text('To: ${order.name}'),
                          Text('${order.phone}, ${order.address}'),
                          const SizedBox(height: 10),

                          // Accept and Cancel Buttons
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.withOpacity(0.9),
                                ),
                                onPressed: _isButtonDisabled[index]
                                    ? null
                                    : () {
                                        setState(() {
                                          _isButtonDisabled[index] = true;
                                        });
                                        print('Order cancelled.');
                                      },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isButtonDisabled[index]
                                      ? Colors.grey
                                      : Colors.blue.withOpacity(0.9),
                                ),
                                onPressed: _isButtonDisabled[index]
                                    ? null
                                    : () async {
                                        await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Accept Order'),
                                              content: const Text(
                                                  'Are you sure you want to accept this order?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false); // No
                                                  },
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context)
                                                        .pop(true); // Yes
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((confirmed) async {
                                          if (confirmed == true) {
                                            await _acceptOrder(order.id, index);
                                          }
                                        });
                                      },
                                child: Text(_buttonTexts[index]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
