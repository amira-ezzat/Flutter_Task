import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/model/product.dart';

Future<List<Product>> fetchAllProducts() async {
  final url = Uri.parse('https://<host>/plugins/appx_offline_support_plugin/service/v1/GetAllProducts');

  final body = jsonEncode({
    "class": "sa.com.doit.cart.service.request.GetAllProductsRequest",
    "size": 20,
    "start": 20
  });

  // طبعا هنا محتاج تحط التوكن في الهيدر
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer <your_token_here>",
  };

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final List<dynamic> list = data['list'] ?? [];

    return list.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load products: ${response.statusCode}');
  }
}
