import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:kiska_admin/features/shop/global_variables.dart';
import 'package:kiska_admin/features/shop/models/banner.dart';
import 'package:kiska_admin/services/http_response.dart';
import 'package:http/http.dart' as http;

class BannerController {
  uploadBanner({required dynamic pickedImage, required context}) async {
    try {
      final cloudinary = CloudinaryPublic("dwhidbfrj", "rhimclrg");
      CloudinaryResponse imageResponses = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(pickedImage,
              identifier: 'PickedImage', folder: 'Banners'));

      String image = imageResponses.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: image);

      http.Response response = await http.post(
        Uri.parse('$uri/api/banner'),
        body: bannerModel.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Banner uploaded");
          });
    } catch (e) {
      showSnackBar(context, 'Error $e');
    }
  }

  // Fetch banners
  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();

        return banners;
      } else {
        throw Exception('Failed to Load banners');
      }
    } catch (e) {
      throw Exception('Error loading Banners $e');
    }
  }
}
