import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/bottom_cart_bar.dart';
import '../../../../core/widgets/category_chip.dart';
import '../../../../core/widgets/product_card.dart';
import '../../data/model/product.dart';
import '../../data/product_repository.dart';
import '../../manage/bloc/peoduct_state.dart';
import '../../manage/bloc/product_bloc.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> searchResults = [];

  @override
  void initState() {
    super.initState();
    context.read<CategoriesProductsCubit>().init(); // fetch categories and first products
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoriesProductsCubit>().state;
    final cubit = context.read<CategoriesProductsCubit>();

    final allCategories = cubit.categories;
    final selectedCategory = state.selectedCategory;

    final currentProducts =
    searchResults.isNotEmpty ? searchResults : state.products;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onSearchChanged: (query) async {
          if (query.isEmpty) {
            setState(() {
              searchResults = [];
            });
            return;
          }

          final productRepository = ProductRepository();
          final results = await productRepository.searchProducts(query);

          setState(() {
            searchResults = results;
          });
        },
      ),
      body: state.isLoading && currentProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
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
                    itemCount: allCategories.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = allCategories[index];
                      final isSelected =
                          category.name == selectedCategory;

                      return CategoryChip(
                        label: category.name,
                        isSelected: isSelected,
                        onTap: () {
                          cubit.selectCategory(category);
                          setState(() {
                            searchResults = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: currentProducts.isEmpty
                    ? const Center(child: Text('لا توجد منتجات'))
                    : GridView.builder(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 12, bottom: 100),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: currentProducts.length,
                  itemBuilder: (context, index) {
                    final product = currentProducts[index];
                    return ProductCard(
                      product: product,
                      onIncrement: () {
                        cubit.increment(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إضافة ${product.name}',
                              style: const TextStyle(
                                  color: Colors.white),
                            ),
                            backgroundColor: AppColors.primaryBlue,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      onDecrement: () {
                        cubit.decrement(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إزالة ${product.name}',
                              style: const TextStyle(
                                  color: Colors.white),
                            ),
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
            child: BottomCartBar(total: calculateTotal(currentProducts)),
          ),
        ],
      ),
    );
  }

  double calculateTotal(List<Product> products) {
    return products.fold<double>(
        0, (sum, p) => sum + (p.price * (p.quantity)));
  }
}
