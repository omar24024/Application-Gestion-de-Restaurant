import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../controllers/commande_controller.dart';
import '../../controllers/auth_controller.dart';
import 'orders_screen.dart';
import '../../l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isOrdering = false;

  Future<Position?> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  Future<void> _passerCommande() async {
    final cmdCtrl = context.read<CommandeController>();
    final authCtrl = context.read<AuthController>();
    final l10n = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirmOrder),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.confirmOrderQuestion),
            const SizedBox(height: 12),
            ...cmdCtrl.panier.map((p) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(p.nom),
                Text('${p.prix.toStringAsFixed(0)} DA',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.total, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${cmdCtrl.total.toStringAsFixed(0)} DA',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 8),
            const Row(children: [
              Icon(Icons.location_on, color: Colors.orange, size: 16),
              SizedBox(width: 4),
              Text('Localisation GPS sera envoyée', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
            const Row(children: [
              Icon(Icons.payments, color: Colors.orange, size: 16),
              SizedBox(width: 4),
              Text('Paiement à la livraison', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;
    setState(() => _isOrdering = true);

    final position = await _getLocation();
    final ok = await cmdCtrl.passerCommande(
      authCtrl.userId!,
      lat: position?.latitude,
      lng: position?.longitude,
    );

    if (!context.mounted) return;
    setState(() => _isOrdering = false);

    if (ok) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              Text(l10n.orderSent,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.restaurantProcessing,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
              if (position != null) ...[
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text('Localisation envoyée ✅',
                        style: TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const OrdersScreen()));
                },
                child: Text(l10n.viewMyOrders,
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.orderError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cmdCtrl = context.watch<CommandeController>();
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myCart),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: cmdCtrl.panier.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(l10n.cartEmpty, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cmdCtrl.panier.length,
                    itemBuilder: (context, index) {
                      final plat = cmdCtrl.panier[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.fastfood, color: Colors.white),
                        ),
                        title: Text(plat.nom),
                        subtitle: Text('${plat.prix.toStringAsFixed(0)} DA'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => cmdCtrl.retirerDuPanier(plat),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.total,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('${cmdCtrl.total.toStringAsFixed(0)} DA',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(children: [
                        Icon(Icons.payments, color: Colors.grey, size: 16),
                        SizedBox(width: 4),
                        Text('Paiement à la livraison',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ]),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: _isOrdering
                              ? const SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.check_circle, color: Colors.white),
                          label: Text(
                              _isOrdering ? l10n.sendingInProgress : l10n.order,
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: _isOrdering ? null : _passerCommande,
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
