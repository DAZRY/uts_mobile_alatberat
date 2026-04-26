import 'package:flutter/material.dart';
import 'package:uts_mobile_alatberat/core/routes/app_router.dart';
import 'package:uts_mobile_alatberat/features/cart/domain/entities/product.dart';
import 'package:uts_mobile_alatberat/features/auth/presentation/widget/add_button_widget.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});
  static final List<Product> _products = [
    Product(id: '1', name: 'Excavator', price: 750000000),
    Product(id: '2', name: 'Vibrator Roller', price: 400000000),
    Product(id: '3', name: 'Crane', price: 950000000),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Alat Berat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, AppRouter.cart),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_products[index].name),
          subtitle: Text('Rp ${_products[index].price}'),
          trailing: AddButtonWidget(product: _products[index]),
        ),
      ),
    );
  }
}
