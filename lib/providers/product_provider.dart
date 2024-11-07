import 'package:kiska_admin/features/shop/controllers/product_controller.dart';
import 'package:kiska_admin/features/shop/models/product.dart';
import 'package:riverpod/riverpod.dart';

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider() : super([]);
  ProductController productController = ProductController();

  void setProducts(List<Product> products) {
    state = products;
  }

  // Delete a product from the list both locally and on the backend
  Future<void> deleteProduct(String id) async {
    try {
      // Delete the product from the backend
      await productController.deleteProductFromBackend(id);

      // If backend deletion was successful, update local state
      state = state.where((product) => product.id != id).toList();
    } catch (error) {
      print('Error deleting product: $error');
      throw error;
    }
  }
}

final productProvider =
    StateNotifierProvider<ProductProvider, List<Product>>((ref) {
  return ProductProvider();
});
