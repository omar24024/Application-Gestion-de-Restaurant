import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});
  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _supabase = Supabase.instance.client;
  int totalCommandes = 0;
  int commandesAcceptees = 0;
  int commandesRefusees = 0;
  int commandesEnAttente = 0;
  double totalRevenu = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final all = await _supabase.from('commandes').select('statut, total');
    int total = 0, acceptees = 0, refusees = 0, attente = 0;
    double revenu = 0;
    for (final c in all) {
      total++;
      if (c['statut'] == 'acceptee') { acceptees++; revenu += (c['total'] as num).toDouble(); }
      if (c['statut'] == 'refusee') refusees++;
      if (c['statut'] == 'en_attente') attente++;
    }
    setState(() {
      totalCommandes = total;
      commandesAcceptees = acceptees;
      commandesRefusees = refusees;
      commandesEnAttente = attente;
      totalRevenu = revenu;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Revenu total
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.white, size: 40),
                        const SizedBox(height: 8),
                        Text('${totalRevenu.toStringAsFixed(0)} DA',
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        const Text('Revenu total', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _StatCard(label: 'Total commandes', value: '$totalCommandes', color: Colors.blue, icon: Icons.receipt_long),
                      _StatCard(label: 'Acceptées', value: '$commandesAcceptees', color: Colors.green, icon: Icons.check_circle),
                      _StatCard(label: 'Refusées', value: '$commandesRefusees', color: Colors.red, icon: Icons.cancel),
                      _StatCard(label: 'En attente', value: '$commandesEnAttente', color: Colors.orange, icon: Icons.hourglass_empty),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
