import '../../data/model/product.dart';

class CategoriesProductsState {
  final List<Product> products;
  final String selectedCategory;
  final bool isLoading;

  CategoriesProductsState({
    required this.products,
    required this.selectedCategory,
    this.isLoading = false,
  });

  CategoriesProductsState copyWith({
    List<Product>? products,
    String? selectedCategory,
    bool? isLoading,
  }) {
    return CategoriesProductsState(
      products: products ?? this.products,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
