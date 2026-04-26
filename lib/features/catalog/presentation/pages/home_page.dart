import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uts_mobile_alatberat/features/auth/presentation/providers/auth_provider.dart';
import 'package:uts_mobile_alatberat/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:uts_mobile_alatberat/features/cart/presentation/providers/cart_provider.dart';

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
      print('JWT di HomePage: $jwt');
      context.read<CatalogProvider>().fetchProducts(jwt);
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final cart    = context.watch<CartProvider>();
    final auth    = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('MyCatalog', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
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
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : catalog.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 12),
                      Text('Gagal memuat produk', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          final jwt = context.read<AuthProvider>().jwtToken ?? '';
                          context.read<CatalogProvider>().fetchProducts(jwt);
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : catalog.products.isEmpty
                  ? const Center(child: Text('Belum ada produk'))
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: catalog.products.length,
                        itemBuilder: (ctx, i) {
                          final p = catalog.products[i];
                          final inCart = cart.isInCart(p.id);
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar produk
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                  child: p.imageUrl != null && p.imageUrl!.isNotEmpty
                                      ? Image.network(
                                          p.imageUrl!,
                                          height: 130,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            height: 130,
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.image_not_supported,
                                              size: 50, color: Colors.grey),
                                          ),
                                        )
                                      : Container(
                                          height: 130,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.inventory_2,
                                            size: 50, color: Colors.grey),
                                        ),
                                ),
                                // Info produk
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp ${p.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                        // Tombol tambah keranjang
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: inCart
                                                  ? Colors.grey
                                                  : Colors.teal,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: inCart ? null : () {
                                              context.read<CartProvider>().addItem(p);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('${p.name} ditambahkan!'),
                                                  duration: const Duration(seconds: 1),
                                                  backgroundColor: Colors.teal,
                                                ),
                                              );
                                            },
                                            child: Text(
                                              inCart ? 'Ditambahkan ✓' : '+ Keranjang',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}