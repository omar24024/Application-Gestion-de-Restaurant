import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../controllers/plat_controller.dart';
import '../../controllers/commande_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/plat.dart';
import '../auth/login_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import '../../l10n/app_localizations.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PlatController>().fetchPlats());
  }

  @override
  Widget build(BuildContext context) {
    final platCtrl = context.watch<PlatController>();
    final cmdCtrl = context.watch<CommandeController>();
    final auth = context.read<AuthController>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menu),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: (val) {
              context.read<LocaleProvider>().setLocale(
                val == 'fr' ? const Locale('fr') : const Locale('en'),
              );
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'fr', child: Text(l10n.french)),
              PopupMenuItem(value: 'en', child: Text(l10n.english)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.receipt),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const OrdersScreen())),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
              if (cmdCtrl.count > 0)
                Positioned(
                  right: 6, top: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text('${cmdCtrl.count}',
                        style: const TextStyle(fontSize: 11, color: Colors.white)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: platCtrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : platCtrl.plats.isEmpty
              ? const Center(child: Text('Aucun plat disponible'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: platCtrl.plats.length,
                  itemBuilder: (context, index) {
                    return PlatCard(plat: platCtrl.plats[index]);
                  },
                ),
    );
  }
}

class PlatCard extends StatelessWidget {
  final Plat plat;
  const PlatCard({super.key, required this.plat});

  @override
  Widget build(BuildContext context) {
    final cmdCtrl = context.read<CommandeController>();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: plat.imageUrl != null
                  ? Image.network(plat.imageUrl!, fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plat.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(plat.description,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${plat.prix.toStringAsFixed(0)} DA',
                        style: const TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        cmdCtrl.ajouterAuPanier(plat);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${plat.nom} ajouté !'),
                          duration: const Duration(seconds: 1),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: const Icon(Icons.add, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.orange.shade50,
      child: const Center(
          child: Icon(Icons.fastfood, size: 50, color: Colors.orange)),
    );
  }
}
