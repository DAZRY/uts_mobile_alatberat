import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_mobile_alatberat/features/cart/domain/entities/product.dart';
import 'package:uts_mobile_alatberat/features/auth/presentation/providers/cart_provider.dart';
import 'package:uts_mobile_alatberat/features/catalog/domain/product_model.dart';

class AddButtonWidget extends StatelessWidget {
  final Product product;
  const AddButtonWidget({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final isInCart = context.select<CartProvider, bool>(
      (provider) => provider.isInCart(product.id as int),
    );
    
    return TextButton(
      onPressed: isInCart
          ? null
          : () => context.read<CartProvider>().addItem(product as ProductModel),
      child: isInCart
          ? const Icon(Icons.check, color: Colors.green)
          : const Text('TAMBAH'),
    );
  }
}
