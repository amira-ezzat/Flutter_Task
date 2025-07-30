import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/bloc/peoduct_state.dart';
import '../model/product.dart';
import '../data/product_repository.dart';


class CategoriesProductsCubit extends Cubit<CategoriesProductsState> {
  final ProductRepository repository;

  CategoriesProductsCubit(this.repository)
      : super(CategoriesProductsState(selectedCategory: 'أفضل العروض', products: []));

  void loadProducts() async {
    final items = await repository.fetchProducts();
    emit(CategoriesProductsState(selectedCategory: state.selectedCategory, products: items));
  }

  void selectCategory(String category) {
    emit(CategoriesProductsState(selectedCategory: category, products: state.products));
  }

  void increment(Product product) {
    product.quantity++;
    emit(CategoriesProductsState(selectedCategory: state.selectedCategory, products: List.from(state.products)));
  }

  void decrement(Product product) {
    if (product.quantity > 0) product.quantity--;
    emit(CategoriesProductsState(selectedCategory: state.selectedCategory, products: List.from(state.products)));
  }
}
