import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kiska_admin/features/shop/screens/category/category_screen.dart';
import 'package:kiska_admin/features/shop/screens/home/home_screen.dart';
import 'package:kiska_admin/features/shop/screens/product/product_screen.dart';

class NavigationMenu extends StatelessWidget {
  // Create an instance of the NavigationController
  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: navigationController
              .selectedIndex.value, // Use index from GetX controller
          children:
              navigationController.screens, // List of screens to switch between
        ),
        bottomNavigationBar: Container(
          color: const Color.fromARGB(15, 0, 187, 212),
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ), // Optional padding for a more spaced-out design
          child: GNav(
            // Can be transparent or any color
            color: Colors.grey, // Default icon color
            activeColor: Theme.of(context)
                .colorScheme
                .primary, // Color when item is active
            tabBackgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(0.1), // Background for active tab
            gap: 8, // Gap between icon and text
            padding: const EdgeInsets.all(7), // Padding for each item
            selectedIndex:
                navigationController.selectedIndex.value, // GetX index
            onTabChange: (index) {
              navigationController
                  .changeTabIndex(index); // Call method to change tab
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Iconsax.shop,
                text: 'Store',
              ),
              GButton(
                icon: Iconsax.heart,
                text: 'Wishlist',
              ),
              GButton(
                icon: Iconsax.user,
                text: 'Settings',
              ),
            ],
          ),
        ),
      );
    });
  }
}

class NavigationController extends GetxController {
  // Store selected index as an observable
  var selectedIndex = 0.obs;

  // List of screens
  final screens = [
    const HomeScreen(),
    const UploadScreen(),
    const CategoryScreen(),
    const UploadScreen(),
  ];

  // Method to change the selected index
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
