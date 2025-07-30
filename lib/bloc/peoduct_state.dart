

import '../model/product.dart';

class CategoriesProductsState {
  final String selectedCategory;
  final List<Product> products;

  CategoriesProductsState({
    required this.selectedCategory,
    required this.products,
  });
}