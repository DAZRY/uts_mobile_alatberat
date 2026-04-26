import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uts_mobile_alatberat/core/constants/api_constants.dart';
import 'package:uts_mobile_alatberat/features/catalog/domain/product_model.dart';

class CatalogRepository {
  Future<List<ProductModel>> getProducts(String jwt) async {
  print('URL: ${ApiConstants.products}');
  final response = await http.get(
    Uri.parse(ApiConstants.products),
    headers: {'Authorization': 'Bearer $jwt'},
  );
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
  
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    final List data = body['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  } else {
    throw Exception('Gagal mengambil produk');
  }
}
}