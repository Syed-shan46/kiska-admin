import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiska_admin/features/shop/controllers/banner_controller.dart';
import 'package:kiska_admin/features/shop/screens/banner/widgets/banner_widget.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BannerController _bannerController = BannerController();
  final ImagePicker picker = ImagePicker();
  File? _selectedImage; // Variable to hold the selected image

  Future<void> chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Save the selected image
      });
    } else {
      print('No image selected');
    }
  }

  // Function to upload the category
  void uploadBanner() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage != null) {
        // Convert the image to bytes
        Uint8List imageBytes = await _selectedImage!.readAsBytes();

        // Call the upload function in the controller
        _bannerController.uploadBanner(
          pickedImage: imageBytes,
          context: context,
        );  
      } else {
        // Handle the case where no image is selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Banner'),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image container and Save button
                Row(
                  children: [
                    // Image container
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!)
                            : const Center(
                                child: Text('Category Image'),
                              ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Save button
                    ElevatedButton(
                      onPressed: () {
                        uploadBanner();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Upload button
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      chooseImage();
                    },
                    child: const Text('Pick Image'),
                  ),
                ),

                const Divider(color: Colors.grey),
                const BannerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
