import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:kiska_admin/features/shop/global_variables.dart';
import 'package:kiska_admin/features/shop/models/product.dart';
  import 'package:kiska_admin/services/http_response.dart';
  import 'package:http/http.dart' as http;

class ProductController {
  void uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required List<File> pickedImages,
    required context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic("dwhidbfrj", "rhimclrg");
      List<String> images = [];
      for (var i = 0; i < pickedImages.length; i++) {
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
        );
        images.add(cloudinaryResponse.secureUrl);
      }

      if (category.isNotEmpty) {
        final Product product = Product(
            id: 'id',
            productName: productName,
            productPrice: productPrice,
            quantity: quantity,
            description: description,
            category: category,
            images: images);

        http.Response response = await http.post(
          Uri.parse('$uri/api/add-product'),
          body: product.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );

        manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Product uploaded");
          },
        );
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  Future<List<Product>> loadProducts() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();

        return products;
      } else {
        throw Exception('Failed to Load Products');
      }
    } catch (e) {
      throw Exception('Error loading Products $e');
    }
  }

  // Fetch Product by ID
  Future<Product> fetchProduct(String id) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/$id'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Failed , Error: $e');
    }
  }

  // Function to delete a product from the backend
  Future<void> deleteProductFromBackend(String productId) async {
    final response = await http.delete(
      Uri.parse('$uri/api/products/$productId'),
    );

    if (response.statusCode == 200) {
      // Product deleted successfully
      print('Product deleted from backend');
    } else {
      // Handle the error from the backend
      throw Exception('Failed to delete product from backend');
    }
  }
}
