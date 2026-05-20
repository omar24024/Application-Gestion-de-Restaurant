import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plat.dart';

class PlatController extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Plat> plats = [];
  bool isLoading = false;

  Future<void> fetchPlats() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _supabase
          .from('plats')
          .select()
          .eq('disponible', true);
      plats = (data as List).map((e) => Plat.fromMap(e)).toList();
    } catch (e) {
      plats = [];
    }
    isLoading = false;
    notifyListeners();
  }
}