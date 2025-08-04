import '../../data/model/product.dart';

class CategoriesProductsState {
  final String selectedCategory;
  final List<Product> products;

  CategoriesProductsState({
    required this.selectedCategory,
    required this.products,
  });

  CategoriesProductsState copyWith({
    String? selectedCategory,
    List<Product>? products,
  }) {
    return CategoriesProductsState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      products: products ?? this.products,
    );
  }
}
