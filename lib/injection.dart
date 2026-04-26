// Mengatur semua dependency di satu tempat
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:provider_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:provider_app/main.dart';

Widget buildApp() {
  final cartRepository = CartRepositoryImpl();
  return ChangeNotifierProvider(
    create: (_) => CartProvider(repository: cartRepository),
    child: const MyApp(),
  );
}

void main() => runApp(buildApp());
