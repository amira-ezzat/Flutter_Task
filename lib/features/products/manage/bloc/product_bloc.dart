import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/product.dart';
import '../../data/product_repository.dart';
import 'peoduct_state.dart';

class CategoriesProductsCubit extends Cubit<CategoriesProductsState> {
  final ProductRepository repository;

  List<Category> categories = [];

  CategoriesProductsCubit(this.repository)
      : super(CategoriesProductsState(selectedCategory: '', products: [], isLoading: false));

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));

    try {
      categories = await repository.fetchAllCategories();
      if (categories.isNotEmpty) {
        final first = categories.first;
        emit(state.copyWith(selectedCategory: first.name));
        await fetchProductsByCategory(first.id);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> fetchProductsByCategory(String categoryId) async {
    emit(state.copyWith(isLoading: true));

    try {
      final products = await repository.fetchProductsByCategory(categoryId);
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectCategory(Category category) async {
    emit(state.copyWith(selectedCategory: category.name));
    await fetchProductsByCategory(category.id);
  }

  void increment(Product product) {
    product.quantity += 1;
    emit(state.copyWith(products: List.from(state.products)));
  }

  void decrement(Product product) {
    if (product.quantity > 0) {
      product.quantity -= 1;
      emit(state.copyWith(products: List.from(state.products)));
    }
  }
}