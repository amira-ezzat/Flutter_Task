
import '../model/product.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(Duration(milliseconds: 500)); // simulate loading
    return [
      Product(id: 1, name: 'Double Whopper', price: 56.99, image: 'assets/icons/burger.png'),
      Product(id: 2, name: 'Fries', price: 2.99, image:  'assets/icons/burger.png'),
      Product(id: 3, name: 'Drink', price: 1.99, image: 'assets/icons/burger.png'),
      Product(id: 4, name: 'Double Whopper', price: 5.99, image: 'assets/icons/burger.png'),
      Product(id: 5, name: 'Fries', price: 25.99, image:  'assets/icons/burger.png'),
      Product(id: 6, name: 'Drink', price: 1.99, image: 'assets/icons/burger.png'),

    ];
  }
}
