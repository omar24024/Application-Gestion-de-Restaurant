import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final double total;
  final String? latitude;
  final String? longitude;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.total,
    this.latitude,
    this.longitude,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderItems();
  }

  Future<void> _fetchOrderItems() async {
    try {
      final data = await _supabase
          .from('commande_items')
          .select('*, plats(nom, prix)')
          .eq('commande_id', widget.orderId);
      setState(() {
        items = data as List<Map<String, dynamic>>;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.orderDetails}${widget.orderId}'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.deliveryInformation,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (widget.latitude != null && widget.longitude != null)
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  'GPS: ${widget.latitude}, ${widget.longitude}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          else
                            Text(
                              l10n.positionNotAvailable,
                              style: const TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.orderedItems,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: items.isEmpty
                        ? Center(child: Text(l10n.noItems))
                        : ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final plat = item['plats'];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    child: Icon(Icons.fastfood, color: Colors.white),
                                  ),
                                  title: Text(plat['nom'] ?? l10n.unknownDish),
                                  subtitle: Text('${l10n.quantity} ${item['quantite']}'),
                                  trailing: Text(
                                    '${(plat['prix'] as num).toDouble().toStringAsFixed(0)} DA',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.total,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.total.toStringAsFixed(0)} DA',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
