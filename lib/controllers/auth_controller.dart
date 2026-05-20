import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      await loadUserDataPublic();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName,
      {String role = 'client'}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'role': role},
      );
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadUserDataPublic() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (data != null) {
        currentUser = UserModel(
          id: data['id'],
          fullName: data['full_name'] ?? '',
          role: data['role'] ?? 'client',
          email: user.email ?? '',
        );
      }
    } catch (e) {
      currentUser = UserModel(
        id: user.id,
        fullName: '',
        role: 'client',
        email: user.email ?? '',
      );
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    currentUser = null;
    notifyListeners();
  }

  bool get isLoggedIn => _supabase.auth.currentUser != null;
  String? get userId => _supabase.auth.currentUser?.id;
  String? get userRole => currentUser?.role;
  String? get userName => currentUser?.fullName;
}
