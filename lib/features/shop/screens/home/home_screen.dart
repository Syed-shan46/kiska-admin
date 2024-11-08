import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiska_admin/features/shop/controllers/order_controller.dart';
import 'package:kiska_admin/features/shop/models/order.dart';
import 'package:kiska_admin/providers/order_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    // Assuming this is for accessing the current user (admin).

    // You don't need the user object for fetching all orders for the admin
    final orderController = OrderController();

    try {
      // Fetch all orders, no need to pass userId anymore
      final orders = await orderController.loadOrders();
      print(
          'Fetched orders count: ${orders.length}'); // Debug log for orders count

      // Set the fetched orders to the provider state
      ref.read(orderProvider.notifier).setOrders(orders);
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders found Now'),
            )
          : Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final Order order = orders[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey
                                    .withOpacity(0.1), // Base color for the box

                                // No border in light mode
                                borderRadius: BorderRadius.circular(
                                    12), // Optional rounded corners
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // image
                                        Container(
                                            width: 65,
                                            height: 65,
                                            decoration: BoxDecoration(
                                                color: Colors.cyan
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Image.network(order.image)),

                                        const SizedBox(width: 16),

                                        /// title, price, size
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  /// Category
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.cyan
                                                                .withOpacity(
                                                                    0.8),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 0),
                                                        child: Text(
                                                            order.category),
                                                      )
                                                    ],
                                                  ),

                                                  /// Price
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '₹${order.totalAmount}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),

                                              const SizedBox(height: 2),

                                              /// Product name
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    order.productName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium,
                                                  )),

                                              const SizedBox(height: 2),

                                              /// Quantity
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Row(
                                                    children: [
                                                      InkWell(
                                                          child: Text(
                                                        'Quantity:',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(order.quantity
                                                          .toString())
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Delivery address',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 3),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${order.country} ${order.city}'),
                                        const SizedBox(height: 3),
                                        Text(
                                          'To: ${order.name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text('${order.phone} ${order.address}')
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.9),
                                                foregroundColor: Colors.white),
                                            onPressed: () {},
                                            child: const Text('Cancel')),
                                            const SizedBox(width: 16),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue
                                                    .withOpacity(0.9),
                                                foregroundColor: Colors.white),
                                            onPressed: () {},
                                            child: const Text('Accept')),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
