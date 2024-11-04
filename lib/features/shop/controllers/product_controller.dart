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
      if (pickedImages != null) {
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
      } else {
        showSnackBar(context, 'Select Image');
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }
}
