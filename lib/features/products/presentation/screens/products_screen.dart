import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/bottom_cart_bar.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/product_card.dart';
import '../../manage/bloc/peoduct_state.dart';
import '../../manage/bloc/product_bloc.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<String> categories = const [
    'أفضل العروض',
    'مستورد',
    'أجبان قابلة للدهن',
    'أجبان',
  ];

  @override
  void initState() {
    super.initState();
   // context.read<CategoriesProductsCubit>().fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onSearchChanged: (value) {
          context.read<CategoriesProductsCubit>().searchProducts(value);
        },
      ),
      body: BlocBuilder<CategoriesProductsCubit, CategoriesProductsState>(
        builder: (context, state) {
          final products = state.products;
          final selectedCategory = state.selectedCategory;
          print('Products in UI: ${products.length}');

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category == selectedCategory;
                          return CategoryChip(
                            label: category,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<CategoriesProductsCubit>().selectCategory(category);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: products.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        print('Product name: ${product.name}, price: ${product.price}');
                        return ProductCard(
                          product: product,
                          onIncrement: () {
                            context.read<CategoriesProductsCubit>().increment(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added one ${product.name}', style: TextStyle(color: Colors.white)),
                                backgroundColor: AppColors.primaryBlue,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          onDecrement: () {
                            context.read<CategoriesProductsCubit>().decrement(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Removed one ${product.name}', style: TextStyle(color: Colors.white)),
                                backgroundColor: AppColors.primaryBlue,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: BottomCartBar(total: calculateTotal(products)),
              ),
            ],
          );
        },
      ),
    );
  }

  double calculateTotal(List products) {
    return products.fold<double>(0, (sum, p) => sum + p.price * p.quantity);
  }
}
