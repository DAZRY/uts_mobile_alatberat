// Implementasi konkret dari CartRepository
// Di sini bisa diganti dengan API call, database, dll
import 'package:uts_mobile_alatberat/features/cart/domain/entities/product.dart';
import 'package:uts_mobile_alatberat/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<Product> _items = [];

  @override 
  List<Product> getCartItems() => List.unmodifiable(_items);

  @override
  void addItem(Product product) => _items.add(product);

  @override
  @override
  bool isItemInCart(String productId) => _items.any((p) => p.id == productId);

  @override
  void removeAllItems() {
    // TODO: implement removeAllItems
  }
}
