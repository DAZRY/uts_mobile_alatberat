import 'package:flutter/material.dart';
import 'package:uts_mobile_alatberat/features/auth/catalog/data/catalog_repository.dart';
import 'package:uts_mobile_alatberat/features/catalog/domain/data/catalog_repository.dart';
import 'package:uts_mobile_alatberat/features/catalog/domain/product_model.dart';
import 'package:uts_mobile_alatberat/features/catalog\domain\product_model.dart';

class CatalogProvider extends ChangeNotifier {
  final _repo = CatalogRepository();

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts(String jwt) async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _repo.getProducts(jwt);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}