import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plat.dart';
import '../models/commande.dart';

class CommandeController extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Plat> panier = [];
  List<Commande> commandes = [];

  void ajouterAuPanier(Plat plat) {
    panier.add(plat);
    notifyListeners();
  }

  void retirerDuPanier(Plat plat) {
    panier.remove(plat);
    notifyListeners();
  }

  void viderPanier() {
    panier.clear();
    notifyListeners();
  }

  double get total => panier.fold(0, (sum, p) => sum + p.prix);
  int get count => panier.length;

  Future<bool> passerCommande(String userId, {double? lat, double? lng}) async {
    try {
      final commande = await _supabase.from('commandes').insert({
        'user_id': userId,
        'statut': 'en_attente',
        'total': total,
        'latitude': lat,
        'longitude': lng,
      }).select().single();

      for (var plat in panier) {
        await _supabase.from('commande_items').insert({
          'commande_id': commande['id'],
          'plat_id': plat.id,
          'quantite': 1,
          'prix_unitaire': plat.prix,
        });
      }
      viderPanier();
      return true;
    } catch (e) {
      return false;
    }
  }

  void ecouterCommandes(String userId) {
    _supabase
        .from('commandes')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .listen((data) {
          commandes = data.map((e) => Commande.fromMap(e)).toList();
          notifyListeners();
        });
  }
}