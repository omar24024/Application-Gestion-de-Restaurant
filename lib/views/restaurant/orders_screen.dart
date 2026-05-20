import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_details_screen.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({super.key});
  @override
  State<RestaurantOrdersScreen> createState() => _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState extends State<RestaurantOrdersScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> commandes = [];
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _listen();
  }

  void _listen() {
    _supabase
        .from('commandes')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen((data) {
          if (mounted) setState(() => commandes = data);
        });
  }

  Future<void> _updateStatut(int id, String statut) async {
    await _supabase.from('commandes').update({'statut': statut}).eq('id', id);
  }

  Color _statusColor(String statut) {
    switch (statut) {
      case 'acceptee': return Colors.green;
      case 'refusee': return Colors.red;
      default: return Colors.orange;
    }
  }

  List<Map<String, dynamic>> get _filtered =>
      _filter == 'all' ? commandes : commandes.where((c) => c['statut'] == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commandes'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filtres
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _FilterChip(label: 'Toutes', value: 'all', current: _filter,
                    onTap: () => setState(() => _filter = 'all')),
                const SizedBox(width: 8),
                _FilterChip(label: 'En attente', value: 'en_attente', current: _filter,
                    onTap: () => setState(() => _filter = 'en_attente')),
                const SizedBox(width: 8),
                _FilterChip(label: 'Acceptées', value: 'acceptee', current: _filter,
                    onTap: () => setState(() => _filter = 'acceptee')),
                const SizedBox(width: 8),
                _FilterChip(label: 'Refusées', value: 'refusee', current: _filter,
                    onTap: () => setState(() => _filter = 'refusee')),
              ],
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('Aucune commande'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final cmd = _filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (_) => OrderDetailsScreen(
                                orderId: cmd['id'],
                                total: (cmd['total'] as num).toDouble(),
                                latitude: cmd['latitude']?.toString(),
                                longitude: cmd['longitude']?.toString(),
                              ))),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Commande #${cmd['id']}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _statusColor(cmd['statut']).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: _statusColor(cmd['statut'])),
                                      ),
                                      child: Text(cmd['statut'],
                                          style: TextStyle(color: _statusColor(cmd['statut']), fontSize: 11)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Total: ${cmd['total']} DA'),
                                if (cmd['latitude'] != null)
                                  Text('GPS: ${cmd['latitude']}, ${cmd['longitude']}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                if (cmd['statut'] == 'en_attente') ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                          icon: const Icon(Icons.check, color: Colors.white),
                                          label: const Text('Accepter', style: TextStyle(color: Colors.white)),
                                          onPressed: () => _updateStatut(cmd['id'], 'acceptee'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                          icon: const Icon(Icons.close, color: Colors.white),
                                          label: const Text('Refuser', style: TextStyle(color: Colors.white)),
                                          onPressed: () => _updateStatut(cmd['id'], 'refusee'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.value, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.orange : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.orange : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade700,
                fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
