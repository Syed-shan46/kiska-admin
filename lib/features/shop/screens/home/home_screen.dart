import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiska_admin/features/shop/screens/banner/banner_screen.dart';
import 'package:kiska_admin/features/shop/screens/category/category_screen.dart';
import 'package:kiska_admin/features/shop/screens/product/product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Kiska Admin')),
        drawer: Drawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => const UploadScreen()),
                      child: const Text('Add Product'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => const CategoryScreen()),
                      child: const Text('Add Category'),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.to(() => const BannerScreen()),
                      child: const Text('Add Banner'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Orders'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
