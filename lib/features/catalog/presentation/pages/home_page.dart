import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_mobile_alatberat/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_mobile_alatberat/features/cart/presentation/providers/cart_provider.dart';
import '../../presentation/providers/catalog_provider.dart';
import 'package:uts_mobile_alatberat/features/cart/presentation/pages/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jwt = context.read<AuthProvider>().jwtToken ?? '';
      context.read<CatalogProvider>().fetchProducts(jwt);
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final cart    = context.watch<CartProvider>();
    final auth    = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyCatalog'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartPage())),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 6, top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text('${cart.itemCount}',
                      style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: catalog.isLoading
          ? const Center(child: CircularProgressIndicator())
          : catalog.error != null
              ? Center(child: Text('Error: ${catalog.error}'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: catalog.products.length,
                  itemBuilder: (ctx, i) {
                    final p = catalog.products[i];
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: p.imageUrl != null
                                ? Image.network(p.imageUrl!,
                                    width: double.infinity, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image, size: 60))
                                : const Icon(Icons.image, size: 60),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                                Text('Rp ${p.price.toStringAsFixed(0)}',
                                  style: const TextStyle(color: Colors.teal)),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<CartProvider>().addItem(p);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${p.name} ditambahkan ke keranjang')),
                                      );
                                    },
                                    child: const Text('+ Keranjang', style: TextStyle(fontSize: 12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}