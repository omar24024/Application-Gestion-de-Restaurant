import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/auth_controller.dart';
import '../../main.dart';
import '../../l10n/app_localizations.dart';
import '../auth/login_screen.dart';
import 'orders_screen.dart';
import 'menu_management_screen.dart';
import 'stats_screen.dart';

class RestaurantDashboardScreen extends StatefulWidget {
  const RestaurantDashboardScreen({super.key});
  @override
  State<RestaurantDashboardScreen> createState() => _RestaurantDashboardScreenState();
}

class _RestaurantDashboardScreenState extends State<RestaurantDashboardScreen> {
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    Supabase.instance.client
        .from('commandes')
        .stream(primaryKey: ['id'])
        .eq('statut', 'en_attente')
        .listen((data) {
          if (mounted) setState(() => _pendingCount = data.length);
        });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Restaurant'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 28,
                    child: Icon(Icons.restaurant, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bienvenue !',
                          style: TextStyle(color: Colors.orange.shade700, fontSize: 13)),
                      Text(auth.userName ?? 'Restaurant',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _StatCard(
                  icon: Icons.pending_actions,
                  label: 'En attente',
                  value: '$_pendingCount',
                  color: Colors.orange,
                )),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(
                  icon: Icons.check_circle,
                  label: 'Acceptées',
                  value: '—',
                  color: Colors.green,
                )),
              ],
            ),
            const SizedBox(height: 20),
            // Commandes en attente — bouton dédié
            _MenuCard(
              icon: Icons.pending_actions,
              color: Colors.orange,
              title: 'Commandes en attente',
              subtitle: '$_pendingCount nouvelle(s) commande(s)',
              badge: _pendingCount > 0 ? '$_pendingCount' : null,
              onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const RestaurantOrdersScreen(isHistory: false))),
            ),
            const SizedBox(height: 12),
            // Historique — toutes sauf en attente
            _MenuCard(
              icon: Icons.history,
              color: Colors.green,
              title: 'Historique des commandes',
              subtitle: 'Acceptées et refusées',
              onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const RestaurantOrdersScreen(isHistory: true))),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              icon: Icons.fastfood,
              color: Colors.blue,
              title: 'Gestion du menu',
              subtitle: 'Ajouter, modifier, supprimer des plats',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MenuManagementScreen())),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              icon: Icons.bar_chart,
              color: Colors.purple,
              title: 'Statistiques',
              subtitle: 'Revenus et commandes',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const StatsScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _MenuCard({required this.icon, required this.color, required this.title,
      required this.subtitle, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: badge != null
            ? CircleAvatar(radius: 12, backgroundColor: Colors.red,
                child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 11)))
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}