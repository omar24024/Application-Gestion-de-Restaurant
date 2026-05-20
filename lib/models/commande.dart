class Commande {
  final int id;
  final String userId;
  final String statut;
  final double total;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;

  Commande({
    required this.id,
    required this.userId,
    required this.statut,
    required this.total,
    required this.createdAt,
    this.latitude,
    this.longitude,
  });

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      id: map['id'],
      userId: map['user_id'],
      statut: map['statut'],
      total: (map['total'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
    );
  }
}