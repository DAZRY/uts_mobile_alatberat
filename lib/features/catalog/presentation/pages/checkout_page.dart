import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:uts_mobile_alatberat/features/auth/presentation/providers/cart_provider.dart';
import 'package:uts_mobile_alatberat/features/catalog/presentation/providers/cart_provider.dart';
import 'package:uts_mobile_alatberat/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_mobile_alatberat/core/constants/api_constants.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  Future<void> _checkout(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();

    final items = cart.items.map((e) => {
      'product_id': e.productId,
      'quantity':   e.qty,
    }).toList();

    final response = await http.post(
      Uri.parse(ApiConstants.checkout),
      headers: {
        'Content-Type':  'application/json',
        'Authorization': 'Bearer ${auth.jwtToken}',
      },
      body: jsonEncode({'items': items}),
    );

    if (!context.mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      cart.clearCart();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Pesanan Berhasil!'),
          content: const Text('Terima kasih, pesanan kamu sedang diproses.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checkout gagal, coba lagi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items[i];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.qty} x Rp ${item.price.toStringAsFixed(0)}'),
                  trailing: Text('Rp ${(item.price * item.qty).toStringAsFixed(0)}'),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Rp ${cart.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _checkout(context),
                    child: const Text('Konfirmasi Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}