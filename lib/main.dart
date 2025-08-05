import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/products/data/product_repository.dart';
import 'features/products/manage/bloc/product_bloc.dart';
import 'features/products/presentation/screens/products_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/products/data/product_repository.dart';
import 'features/products/manage/bloc/product_bloc.dart';
import 'features/products/presentation/screens/products_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,

      home: BlocProvider(
        create: (_) => CategoriesProductsCubit(ProductRepository())..init(),
        child: const ProductsScreen(),
      ),
    );
  }
}
