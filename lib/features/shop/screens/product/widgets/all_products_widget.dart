import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiska_admin/features/shop/models/product.dart';
import 'package:kiska_admin/features/shop/screens/product/edit_product.dart';
import 'package:kiska_admin/features/shop/screens/product/widgets/circular_container.dart';

import '../../../controllers/product_controller.dart';

class AllProductsWidget extends StatefulWidget {
  const AllProductsWidget({super.key});

  @override
  State<AllProductsWidget> createState() => _AllProductsWidgetState();
}

class _AllProductsWidgetState extends State<AllProductsWidget> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductController().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Products'),
            );
          } else {
            final products = snapshot.data!;
            return ListView.separated(
              itemCount: products.length,
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final product = products[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ProductCardVertical(product),
                );
              },
            );
          }
        });
  }

  Container ProductCardVertical(Product product) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          /// Thumbnail
          MyCircularContainer(
            height: 120,
            padding: const EdgeInsets.all(10),
            backgroundColor: Colors.grey.withOpacity(0.3),
            child: Stack(
              children: [
                /// Thumbnail Image
                SizedBox(
                  height: 120,
                  width: 120,
                  child: product.images.isNotEmpty
                      ? Image.network(product.images[0])
                      : const Icon(Icons.image_not_supported),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 230,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TextStyle(color: Colors.black.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        product.category, // Example static brand
                        style: TextStyle(color: Colors.black.withOpacity(0.9)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Pricing
                      Flexible(
                        child: Text(
                          '${product.productPrice}', // Assume 'price' is a property in Product model
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.9)),
                        ),
                      ),

                      /// Edit button
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.cyan.withOpacity(0.8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Iconsax.edit),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          /// Delete button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
