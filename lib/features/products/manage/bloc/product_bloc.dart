import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/products/manage/bloc/peoduct_state.dart';
import '../../data/model/product.dart';
import '../../data/product_repository.dart';

class CategoriesProductsCubit extends Cubit<CategoriesProductsState> {
  final ProductRepository repository;

  CategoriesProductsCubit(this.repository)
      : super(CategoriesProductsState(selectedCategory: 'أفضل العروض', products: []));

  Future<void> fetchAllProducts() async {
    try {
      final products = await repository.fetchAllProducts();
      print('Cubit loaded products: ${products.length}');
      emit(state.copyWith(products: products));
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
    // هنا ممكن تضيف فلترة حسب category لو حابب
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
