import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:kiska_admin/features/shop/global_variables.dart';
import 'package:kiska_admin/features/shop/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:kiska_admin/services/http_response.dart';

class CategoryController {
  uploadCategory({
    required dynamic pickedImage,
    required String name,
    required context,
  }) async {
    // Upload Categories

    try {
      final cloudinary = CloudinaryPublic("dwhidbfrj", "rhimclrg");

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'Picked Image', folder: 'Category images'),
      );

      String image = imageResponse.secureUrl;

      Category category = Category(id: '', name: name, image: image);

      http.Response response = await http.post(
        Uri.parse("http://192.168.31.58:3000/api/category"),
        body: category.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Uploaded category');
        },
      );
    } catch (e) {
      print("Error uploading category: $e"); // Debug print for errors
      showSnackBar(context, 'Error: $e');
    }
  }

  // Fetch categories
  Future<List<Category>> loadCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();
        return categories;
      } else {
        throw Exception('Failed to Load Categories');
      }
    } catch (e) {
      throw Exception('Error loading Categories $e');
    }
  }
}
