class Plat {
  final int id;
  final String nom;
  final String description;
  final double prix;
  final String? imageUrl;
  final bool disponible;

  Plat({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
    this.imageUrl,
    required this.disponible,
  });

  factory Plat.fromMap(Map<String, dynamic> map) {
    return Plat(
      id: map['id'],
      nom: map['nom'],
      description: map['description'] ?? '',
      prix: (map['prix'] as num).toDouble(),
      imageUrl: map['image_url'],
      disponible: map['disponible'] ?? true,
    );
  }
}