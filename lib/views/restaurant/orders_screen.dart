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
  String _filter = 'en_attente';

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

  String _statusLabel(String statut) {
    switch (statut) {
      case 'acceptee': return 'Acceptée';
      case 'refusee': return 'Refusée';
      default: return 'En attente';
    }
  }

  List<Map<String, dynamic>> get _filtered =>
      _filter == 'all'
          ? commandes
          : commandes.where((c) => c['statut'] == _filter).toList();

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
          Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  _FilterChip(label: 'En attente', value: 'En attente', current: _filter,
                      onTap: () => setState(() => _filter = 'En attente')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Toutes', value: 'all', current: _filter,
                      onTap: () => setState(() => _filter = 'all')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Acceptées', value: 'acceptee', current: _filter,
                      onTap: () => setState(() => _filter = 'acceptee')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Refusées', value: 'refusee', current: _filter,
                      onTap: () => setState(() => _filter = 'refusee')),
                ],
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 60, color: Colors.orange),
                        SizedBox(height: 12),
                        Text('Aucune commande',
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final cmd = _filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
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
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 16)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _statusColor(cmd['statut']).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: _statusColor(cmd['statut'])),
                                      ),
                                      child: Text(_statusLabel(cmd['statut']),
                                          style: TextStyle(
                                              color: _statusColor(cmd['statut']),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Total: ${cmd['total']} DA',
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold)),
                                Text(cmd['created_at'].toString().substring(0, 16),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                if (cmd['latitude'] != null)
                                  const Row(children: [
                                    Icon(Icons.location_on, color: Colors.green, size: 14),
                                    Text(' GPS disponible',
                                        style: TextStyle(color: Colors.green, fontSize: 12)),
                                  ]),
                                if (cmd['statut'] == 'En attente') ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          icon: const Icon(Icons.check, color: Colors.white),
                                          label: const Text('Accepter',
                                              style: TextStyle(color: Colors.white)),
                                          onPressed: () => _updateStatut(cmd['id'], 'acceptee'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          icon: const Icon(Icons.close, color: Colors.white),
                                          label: const Text('Refuser',
                                              style: TextStyle(color: Colors.white)),
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
  const _FilterChip(
      {required this.label, required this.value,
      required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.orange : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? Colors.orange : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade700,
                fontSize: 13, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
