import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/product.dart';

class ProductRepository {
  final String baseUrl = 'https://dev1.appxcart.com/plugins/appx_offline_support_plugin/service/v1';
  final String authToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0IiwiYXB4c3JjIjoidGVzdC1wYyIsImlzcyI6ImRldi5hcHB4Y2FydC5jb20iLCJhbm9ueW1vdXMiOmZhbHNlLCJleHAiOjE3NTQzODM1MzMsImlhdCI6MTc1NDM3OTkzM30.nDcZvj1CrjDkzKmanHJ_Xh2G6DuGBXVSjr0ZoKAz2RhKcboBOflprhwMW0Yr3zkxmpXL9wfeO4KsjhFYtuBucQ'

 ;

  Future<void> assignStoreToSession() async {
    final url = Uri.parse('$baseUrl/AssignStoreToSession');

    final body = jsonEncode({
      "class": "sa.com.doit.cart.service.request.store.AssignStoreToSessionRequest",
      "storeId": "2c346a67-943e-4b77-bc4e-a29fab885ef5",
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',

    };


    try {
      print('Calling AssignStoreToSession...');
      print('Fetching products...');
      print('URL: $url');
      print('Headers: $headers');
      print('Body: $body');

      final response = await http.post(url, headers: headers, body: body);
      print('AssignStoreToSession status: ${response.statusCode}');

      print('AssignStoreToSession body: ${response.body}');

      if (response.statusCode == 200) {
        print('Store assigned successfully!');
      } else {
        throw Exception('Failed to assign store: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in assignStoreToSession: $e');
      throw Exception('Failed to assign store: $e');
    }
  }

  Future<List<Product>> fetchAllProducts() async {
    final url = Uri.parse('$baseUrl/GetAllProducts');

    final body = jsonEncode({
      "class": "sa.com.doit.cart.service.request.GetAllProductsRequest",
      "size": 20,
      "start": 20
    });

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
    };

    try {
      await assignStoreToSession();

      print('Fetching products...');
      // final response = await http.post(url, headers: headers, body: body);

      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Full request URL: $url');
      print('Request headers: ${request.headers}');
      print('Request body: ${request.body}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Get all products successfully!');
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'] ?? [];

        return list.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }
  Future<List<Product>> searchProducts(String query) async {
    final url = Uri.parse('$baseUrl/SearchProducts');

    final body = jsonEncode({
      "class": "sa.com.doit.cart.service.request.SearchProductsRequest",
      "productProperties": [
        {
          "class": "sa.com.doit.cart.model.FilterAttribute",
          "title": "Tag",
          "value": query,
        }
      ],
      "size": 20,
      "orderBy": "UPC",
      "asc": true
    });

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
    };

    try {
      await assignStoreToSession();

      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['products'] ?? [];

        return list.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching products: $e');
      throw Exception('Failed to search products: $e');
    }
  }


}
