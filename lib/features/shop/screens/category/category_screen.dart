import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiska_admin/features/shop/controllers/category_controller.dart';
import 'package:kiska_admin/features/shop/screens/category/widgets/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController categoryController = CategoryController();
  late String name;

  final ImagePicker picker = ImagePicker();
  File? _selectedImage; // Variable to hold the selected image

  // Function to pick an image
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
  void uploadCategory() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage != null) {
        // Convert the image to bytes
        Uint8List imageBytes = await _selectedImage!.readAsBytes();

        // Call the upload function in the controller
        categoryController.uploadCategory(
          pickedImage: imageBytes, // Pass the image bytes
          name: name,
          context: context,
        );
      } else {
        // Handle the case where no image is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  // Container to display the selected image
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
                  // File picker
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        chooseImage();
                      },
                      child: const Text('Pick Image'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Category Name Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Please enter category name';
                      }
                    },
                    decoration: (const InputDecoration(
                      labelText: 'Category Name',
                    )),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Cancel and Save Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 5),
                  // Save button
                  ElevatedButton(
                      onPressed: () {
                        uploadCategory();
                      },
                      child: const Text('Save')),
                ],
              ),

              const SizedBox(height: 30),
              const CategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
