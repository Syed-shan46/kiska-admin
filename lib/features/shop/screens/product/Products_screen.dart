import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiska_admin/features/shop/screens/product/add_product_screen.dart';
import 'package:kiska_admin/features/shop/screens/product/widgets/all_products_widget.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          IconButton(
              onPressed: () => Get.to(() => const AddProductScreen()),
              icon: const Icon(Icons.add))
        ],
      ),
      body: const AllProductsWidget(),
    );
  }
}
