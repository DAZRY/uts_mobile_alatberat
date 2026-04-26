// Abstract class: kontrak yang harus diikuti oleh implementasi
// Prinsip Dependency Inversion (DIP) dari SOLID
import 'package:provider_app/features/cart/domain/entities/product.dart';

abstract class CartRepository {
  List<Product> getCartItems();
  void addItem(Product product);
  void removeAllItems();
  bool isItemInCart(String productId);
}
