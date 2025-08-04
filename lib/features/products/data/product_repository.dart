import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/product.dart';

class ProductRepository {
  Future<List<Product>> fetchAllProducts() async {
    final url = Uri.parse('https://dev1.appxcart.com/plugins/appx_offline_support_plugin/service/v1/GetAllProducts');

    final body = jsonEncode({
      "class": "sa.com.doit.cart.service.request.GetAllProductsRequest",
      "size": 20,
      "start": 20
    });

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "eyJhbGciOiJIUzI1NiJ9.eyJhcHhzcmMiOiJteUFwcCIsInN1YiI6InNhbWVoIiwiaWF0IjoxNjQ3OTM5NDM3LCJleHAiOjE2NDc5NDMwMzcsImp0aSI6ImM0MmQ0M2JjLTM3MTktNDg4OC1hYjVjLTQ3MWViNTFhMTNjZiJ9.eKWRp8yNkTuaIpFDBVojccGQwJFPKYIEDwcrPgiCW40",
    };

    final response = await http.post(Uri.parse('https://dev1.appxcart.com/plugins/appx_offline_support_plugin/service/v1/GetAllProducts'), headers:  {
      "Content-Type": "application/json",
       "Authorization": "eyJhbGciOiJIUzI1NiJ9.eyJhcHhzcmMiOiJteUFwcCIsInN1YiI6InNhbWVoIiwiaWF0IjoxNjQ3OTM5NDM3LCJleHAiOjE2NDc5NDMwMzcsImp0aSI6ImM0MmQ0M2JjLTM3MTktNDg4OC1hYjVjLTQ3MWViNTFhMTNjZiJ9.eKWRp8yNkTuaIpFDBVojccGQwJFPKYIEDwcrPgiCW40",
    }, body: jsonEncode({
     "class": "sa.com.doit.cart.service.request.GetAllProductsRequest",
    "size": 20,
    "start": 20
    }),);


    if (response.statusCode == 200) {
      print('success+++++++++++');
      final data = jsonDecode(response.body);

      print('Response data: $data');
      final List<dynamic> list = data['list'] ?? [];
      print('Products list length: ${list.length}');
      print('Failed response body: ${response.body}');
      return list.map((item) => Product.fromJson(item)).toList();
    } else {
      print('Failed response body: ${response.statusCode}');
      print('Failed response body: ${response.body}');
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
