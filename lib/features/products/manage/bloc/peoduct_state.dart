import '../../data/model/product.dart';

class CategoriesProductsState {
  final String selectedCategory;
  final List<Product> products;
  final bool isLoading; // ✅ أضف هذا

  CategoriesProductsState({
    required this.selectedCategory,
    required this.products,
    this.isLoading = false,
  });

  CategoriesProductsState copyWith({
    String? selectedCategory,
    List<Product>? products,
    bool? isLoading,
  }) {
    return CategoriesProductsState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
