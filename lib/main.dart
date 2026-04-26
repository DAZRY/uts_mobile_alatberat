import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uts_mobile_alatberat/features/catalog./presentation/pages/cart_page.dart';
import 'package:uts_mobile_alatberat/features/catalog./presentation/pages/checkout_page.dart';
import 'firebase_options.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/catalog/presentation/providers/catalog_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/catalog/presentation/pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CatalogProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCatalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login':    (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home':     (_) => const HomePage(),
        '/cart':     (_) => const CartPage(),
        '/checkout': (_) => const CheckoutPage(),
      },
    );
  }
}