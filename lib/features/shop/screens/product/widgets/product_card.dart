import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiska_admin/features/shop/models/product.dart';
import 'package:kiska_admin/providers/product_provider.dart';

class MyProductCard extends ConsumerStatefulWidget {
  const MyProductCard(this.product,
      {super.key,
      required this.imageUrl,
      required this.productName,
      required this.price,
      required this.onTap,
      required this.productId,
      required this.category});

  final String imageUrl;
  final String productName;
  final String category;
  final String productId;
  final int price;
  final VoidCallback onTap;
  final Product? product;

  @override
  _MyProductCardState createState() => _MyProductCardState();
}

class _MyProductCardState extends ConsumerState<MyProductCard> {
  bool isAdded = false;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    // Additional initialization if needed
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    height: 120,
                    width: double.infinity,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image loaded successfully
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                      ); // Show error icon if the image fails to load
                    },
                  ),
                  Positioned(
                    top: 5,
                    left: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.8),
                          shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              isFavorited = !isFavorited;
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white.withOpacity(0.9),
                          )),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Product'),
                                  content: const Text(
                                      'Are you sure you want to delete this product?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(false); // User pressed "No"
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(true); // User pressed "Yes"
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldDelete == true) {
                              try {
                                await ref
                                    .read(productProvider.notifier)
                                    .deleteProduct(widget.productId);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Product deleted successfully'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                print(
                                    "Error deleting product: $e"); // Log error
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Error deleting product')),
                                  );
                                }
                              }
                            }
                          },
                          icon:  Icon(
                            Icons.delete,
                            color: Colors.white.withOpacity(0.9),
                          )),
                    ),
                  ),
                ],
              ),
              // Category
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // Product name
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.productName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

              // Price and Discount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Row(
                      children: [
                        const Text(
                          '₹9999',
                          style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '₹${widget.price}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
