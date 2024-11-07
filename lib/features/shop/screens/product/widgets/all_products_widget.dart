// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:kiska_admin/features/shop/models/product.dart';
// import 'package:kiska_admin/features/shop/screens/product/widgets/circular_container.dart';
// import 'package:kiska_admin/features/shop/controllers/product_controller.dart';
// import 'package:get/get.dart';
// import 'package:kiska_admin/providers/product_provider.dart';

// class AllProductsWidget extends ConsumerStatefulWidget {
//   const AllProductsWidget({super.key});

//   @override
//   ConsumerState<AllProductsWidget> createState() => _AllProductsWidgetState();
// }

// class _AllProductsWidgetState extends ConsumerState<AllProductsWidget> {
//   final ProductController _productController =
//       Get.put(ProductController()); // Using GetX controller
//   late Future<List<Product>> futureProducts;

//   @override
//   void initState() {
//     super.initState();
//     futureProducts =
//         _productController.loadProducts(); // Load products via controller
//   }

//   // Fetching products //
//   Future<void> _fetchProduct() async {
//     final ProductController productController = ProductController();
//     try {
//       final products = await productController.loadProducts();
//       ref.read(productProvider.notifier).setProducts(products);
//     } catch (e) {
//       print('Error $e');
//     }
//   }

//   void showDeleteConfirmationDialog(BuildContext context, String productId) {
//     if (!mounted) return; // Ensure the widget is still in the widget tree

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Delete Product"),
//           content: Text("Are you sure you want to delete this product?"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Delete"),
//               onPressed: () async {
//                 Navigator.of(context).pop();

//                 // Show loading indicator or feedback to the user
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Deleting product...")),
//                 );

//                 // Ensure that the widget is still mounted before calling the controller
//                 try {
//                   await _productController.deleteProduct(context, productId);
//                   if (mounted) {
//                     setState(() {
//                       futureProducts = _productController.loadProducts();
//                     });
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Product deleted successfully")),
//                     );
//                   }
//                 } catch (e) {
//                   print("Error during product deletion: $e");
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Error deleting product")),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final products = ref.watch(productProvider);
//     return ListView.separated(
//       itemCount: products.length,
//       separatorBuilder: (context, index) => const SizedBox(height: 16),
//       itemBuilder: (context, index) {
//         final product = products[index];
//         return Container(
//           padding: const EdgeInsets.only(left: 12),
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             children: [
//               /// Thumbnail
//               MyCircularContainer(
//                 height: 120,
//                 padding: const EdgeInsets.all(10),
//                 backgroundColor: Colors.grey.withOpacity(0.3),
//                 child: Stack(
//                   children: [
//                     /// Thumbnail Image
//                     SizedBox(
//                       height: 120,
//                       width: 120,
//                       child: product.images.isNotEmpty
//                           ? Image.network(product.images[0])
//                           : const Icon(Icons.image_not_supported),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(
//                 width: 230,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 10, left: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.productName,
//                         style: TextStyle(color: Colors.black.withOpacity(0.9)),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text(
//                             product.category, // Example static brand
//                             style:
//                                 TextStyle(color: Colors.black.withOpacity(0.9)),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           /// Pricing
//                           Flexible(
//                             child: Text(
//                               '${product.productPrice}', // Assume 'price' is a property in Product model
//                               style: TextStyle(
//                                   color: Colors.black.withOpacity(0.9)),
//                             ),
//                           ),

//                           /// Edit button
//                           Row(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.cyan.withOpacity(0.8),
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(20)),
//                                 ),
//                                 child: SizedBox(
//                                   height: 40,
//                                   width: 40,
//                                   child: Center(
//                                     child: IconButton(
//                                       onPressed: () {
//                                         // Edit button functionality
//                                       },
//                                       icon: const Icon(Iconsax.edit),
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               const SizedBox(width: 10),

//                               /// Delete button
//                               InkWell(
//                                 onTap: () async {
//                                   try {
//                                     // Delete the product from the backend using the controller
//                                     await _productController.deleteProduct(
//                                         context, product.id);

//                                     // Remove product from the UI by updating the Riverpod state
//                                     ref
//                                         .read(productProvider.notifier)
//                                         .removeProduct(product.id);

//                                     // Show success message
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                           content: Text(
//                                               "Product deleted successfully")),
//                                     );
//                                   } catch (e) {
//                                     print("Error during product deletion: $e");
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                           content:
//                                               Text("Error deleting product")),
//                                     );
//                                   }
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.red.withOpacity(0.8),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(20)),
//                                   ),
//                                   child: const SizedBox(
//                                     height: 40,
//                                     width: 40,
//                                     child: Center(
//                                       child: Icon(
//                                         Icons.delete,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Product Card Widget
// }
