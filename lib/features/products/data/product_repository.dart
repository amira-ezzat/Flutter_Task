import 'dart:convert';
import 'dart:typed_data'; // Import for Uint8List
import 'package:http/http.dart' as http;
import 'model/product.dart';

class ProductRepository {
  final String baseUrl = 'https://dev1.appxcart.com/plugins/appx_offline_support_plugin/service/v1';
  final String authToken =
'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0IiwiYXB4c3JjIjoidGVzdC1wYyIsImlzcyI6ImRldi5hcHB4Y2FydC5jb20iLCJhbm9ueW1vdXMiOmZhbHNlLCJleHAiOjE3NTQ0ODQ1MDgsImlhdCI6MTc1NDQ4MDkwOH0.DIcKtb2HhKfIqYTHZavc0EHIzpWk5R1zx23q8cO7GsnTKw7a6-_wlQuOW-QBPfNzZ7x9YX8-94mRrdqyp3lI9A'
  ;
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };

  Future<void> assignStoreToSession() async {
    final url = Uri.parse('$baseUrl/AssignStoreToSession');

    final body = jsonEncode({
      "class": "sa.com.doit.cart.service.request.store.AssignStoreToSessionRequest",
      "storeId": "2c346a67-943e-4b77-bc4e-a29fab885ef5",
    });

    try {
      print('📦 Assigning store...');
      print(' Assigning store...');
      final response = await http.post(url, headers: headers, body: body);
      print('✅ Status: ${response.statusCode}');
      print('📨 Body: ${response.body}');
      print(' Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('❌ Failed to assign store: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 Error in assignStoreToSession: $e');
      print(' Error in assignStoreToSession: $e');
      rethrow;
    }
  }
  Future<List<Category>> fetchAllCategories() async {
    final response = await http.post(
      Uri.parse('$baseUrl/GetAllCategories'),
      headers: headers,
      body: jsonEncode({
        "class": "sa.com.doit.cart.service.request.AllCategoriesRequest"
      }),
    );

    final data = jsonDecode(response.body);
    final List list = data['categories'] ?? [];

    return list.map((e) => Category.fromJson(e)).toList();
  }

  Future<List<Product>> fetchProductsByCategory(String categoryId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/GetAllProducts'),
      headers: headers,
      body: jsonEncode({
        "class": "sa.com.doit.cart.service.request.GetAllProductsRequest",
        "categoryId": categoryId,
        "size": 20,
        "start": 0,
      }),
    );

    final data = jsonDecode(response.body);
    final List list = data['list'] ?? [];

    return list.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> fetchAllProducts() async {
    final url = Uri.parse('$baseUrl/GetAllProducts');

    final body = jsonEncode({
      "class": "sa.com.doit.cart.service.request.GetAllProductsRequest",
      "size": 20,
      "start": 0
    });

    try {
      await assignStoreToSession();

      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📦 Fetch All Products Status: ${response.statusCode}');
      print('📨 Body: ${response.body}');
      print(' Fetch All Products Status: ${response.statusCode}');
      print(' Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'] ?? [];
        return list.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('❌ Failed to fetch products');
      }
    } catch (e) {
      print('🚨 Error fetching all products: $e');
      print(' Error fetching all products: $e');
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final url = Uri.parse('$baseUrl/SearchProducts');

    final body = jsonEncode({
      "class": "sa.com.doit.cart.service.request.SearchProductsRequest",
      "productProperties": [
        {
          "class": "sa.com.doit.cart.model.FilterAttribute",
          "title": "productName",
          "value": query,
        }
      ],
      "size": 20,
      "orderBy": "UPC",
      "asc": true
    });

    try {
      await assignStoreToSession();

      final request = http.Request('POST', url)
        ..headers.addAll(headers)
        ..body = body;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('🔍 SearchProducts Status: ${response.statusCode}');
      print('📨 Response body: ${response.body}');
      print(' SearchProducts Status: ${response.statusCode}');
      print(' Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['products'] ?? [];

        print('✅ Found ${list.length} products');
        if (list.isNotEmpty) {
          print('🔹 First product: ${list.first}');
          print(' First product: ${list.first}');
        }

        return list.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('❌ Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 Error searching products: $e');
      print(' Error searching products: $e');
      rethrow;
    }
  }

  // New function to fetch product image
  Future<Uint8List?> fetchProductImage(String imageId) async {
    final url = Uri.parse('$baseUrl/GetResource');
    final body = jsonEncode({
      "class": "sa.com.doit.cart.service.request.ImageRequest",
      "imageId": imageId,
      "quality": "MED" // You can adjust quality if needed (e.g., "HIGH", "LOW")
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? base64Data = data['resource']?['hashx']?['base64Data'];

          if (base64Data != null && base64Data.isNotEmpty) {
            print('Base64 Data length: ${base64Data.length}');
            print('First 50 chars of Base64 Data: ${base64Data.substring(0, base64Data.length > 50 ? 50 : base64Data.length)}');
            // Decode the base64 string to Uint8List
            return base64Decode(base64Data);

        } else {
          print('⚠️ No base64Data found for imageId: $imageId');
          return null;
        }
      } else {
        print('❌ Failed to fetch image for ID $imageId: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(' Error fetching image for ID $imageId: $e');
      return null;
    }
  }
}
