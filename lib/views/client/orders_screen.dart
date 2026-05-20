import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/commande_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../l10n/app_localizations.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthController>().userId!;
    context.read<CommandeController>().ecouterCommandes(userId);
  }

  Color _statusColor(String statut) {
    switch (statut) {
      case 'acceptee': return Colors.green;
      case 'refusee': return Colors.red;
      default: return Colors.orange;
    }
  }

  IconData _statusIcon(String statut) {
    switch (statut) {
      case 'acceptee': return Icons.check_circle;
      case 'refusee': return Icons.cancel;
      default: return Icons.hourglass_empty;
    }
  }

  String _statusLabel(String statut) {
    switch (statut) {
      case 'acceptee': return 'Acceptée';
      case 'refusee': return 'Refusée';
      default: return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cmdCtrl = context.watch<CommandeController>();
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myOrders),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: cmdCtrl.commandes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(l10n.noOrders, style: const TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cmdCtrl.commandes.length,
              itemBuilder: (context, index) {
                final cmd = cmdCtrl.commandes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _statusColor(cmd.statut).withOpacity(0.15),
                      child: Icon(_statusIcon(cmd.statut), color: _statusColor(cmd.statut)),
                    ),
                    title: Text('${l10n.orderNumber}${cmd.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Total: ${cmd.total.toStringAsFixed(0)} DA\n${cmd.createdAt.toString().substring(0, 16)}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(cmd.statut).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _statusColor(cmd.statut)),
                      ),
                      child: Text(_statusLabel(cmd.statut),
                          style: TextStyle(
                              color: _statusColor(cmd.statut),
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
