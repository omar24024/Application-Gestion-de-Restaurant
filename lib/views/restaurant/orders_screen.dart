import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_details_screen.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  final bool isHistory;
  const RestaurantOrdersScreen({super.key, this.isHistory = false});
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
    _fetchCommandes();
  }

  Future<void> _fetchCommandes() async {
    try {
      final data = await _supabase
          .from('commandes_with_email')
          .select()
          .order('created_at', ascending: false);
      if (mounted) setState(() => commandes = List<Map<String, dynamic>>.from(data));
    } catch (e) {
      final data = await _supabase
          .from('commandes')
          .select()
          .order('created_at', ascending: false);
      if (mounted) setState(() => commandes = List<Map<String, dynamic>>.from(data));
    }
  }

  Future<void> _updateStatut(int id, String statut) async {
    await _supabase.from('commandes').update({'statut': statut}).eq('id', id);
    _fetchCommandes();
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

  List<Map<String, dynamic>> get _filtered {
    if (!widget.isHistory) {
      return commandes.where((c) => c['statut'] == 'en_attente').toList();
    }
    final historique = commandes.where((c) => c['statut'] != 'en_attente').toList();
    if (_filter == 'all') return historique;
    return historique.where((c) => c['statut'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isHistory ? 'Historique' : 'Commandes en attente'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (widget.isHistory)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(
                children: [
                  _Chip(label: 'Toutes', value: 'all', current: _filter,
                      onTap: () => setState(() => _filter = 'all')),
                  const SizedBox(width: 8),
                  _Chip(label: 'Acceptées', value: 'acceptee', current: _filter,
                      onTap: () => setState(() => _filter = 'acceptee')),
                  const SizedBox(width: 8),
                  _Chip(label: 'Refusées', value: 'refusee', current: _filter,
                      onTap: () => setState(() => _filter = 'refusee')),
                ],
              ),
            ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 60,
                            color: widget.isHistory ? Colors.grey : Colors.orange),
                        const SizedBox(height: 12),
                        Text(widget.isHistory ? 'Aucune commande' : 'Aucune commande en attente',
                            style: const TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final cmd = _filtered[index];
                      final email = cmd['client_email'] ?? 'Inconnu';
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
                                      child: Text(_statusLabel(cmd['statut']),
                                          style: TextStyle(color: _statusColor(cmd['statut']),
                                              fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.email, color: Colors.grey, size: 14),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(email,
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      overflow: TextOverflow.ellipsis)),
                                ]),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.access_time, color: Colors.grey, size: 14),
                                  const SizedBox(width: 4),
                                  Text(cmd['created_at'].toString().substring(0, 16),
                                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ]),
                                const SizedBox(height: 4),
                                Text('Total: ${cmd['total']} DA',
                                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                if (cmd['latitude'] != null)
                                  const Row(children: [
                                    Icon(Icons.location_on, color: Colors.green, size: 14),
                                    Text(' GPS disponible',
                                        style: TextStyle(color: Colors.green, fontSize: 12)),
                                  ]),
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

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.value, required this.current, required this.onTap});

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
          border: Border.all(color: selected ? Colors.orange : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade700,
                fontSize: 13, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
