import 'package:flutter/material.dart';
import 'dart:typed_data'; // Import for Uint8List
import '../../features/products/data/model/product.dart';
import '../../features/products/data/product_repository.dart'; // Import ProductRepository
import '../utils/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductCard({
    super.key,
    required this.product,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    // Instantiate ProductRepository to fetch images
    final ProductRepository productRepository = ProductRepository();

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 1),
                    ),
                    child: ClipOval(
                      child: product.imageId != null && product.imageId!.isNotEmpty
                          ? FutureBuilder<Uint8List?>(
                        future: productRepository.fetchProductImage(product.imageId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError || snapshot.data == null) {
                            // Fallback to default image if error or no data
                            return Image.asset('assets/icons/burger.png', width: 55, height: 55, );
                          } else {
                            // Display the image from Uint8List
                            return Image.memory(snapshot.data!, fit: BoxFit.cover,width: 55,height: 44,);
                          }
                        },
                      )
                          : Image.asset('assets/icons/burger.png', width: 55, height: 55, ), // Default image if no imageId
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.orange, width: 1),
                      ),
                      child: product.storeImageId != null && product.storeImageId!.isNotEmpty
                          ? FutureBuilder<Uint8List?>(
                        future: productRepository.fetchProductImage(product.storeImageId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || snapshot.data == null) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset('assets/icons/burger.png', fit: BoxFit.cover),
                            );
                          } else {
                            return ClipOval(
                              child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                            );
                          }
                        },
                      )
                          : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset('assets/icons/burger.png', fit: BoxFit.cover),
                      ),                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              product.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${product.price} \$',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFFeaf6f8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onDecrement,
                        icon: Icon(Icons.remove, size: 14, color: Colors.grey),
                      ),
                      Text(
                        '${product.quantity}',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: AppColors.darkText),
                      ),
                      IconButton(
                        onPressed: onIncrement,
                        icon: Icon(Icons.add, color: AppColors.primaryBlue, size: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
