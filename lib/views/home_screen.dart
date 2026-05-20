import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'auth/login_screen.dart';
import 'client/menu_screen.dart';
import 'restaurant/dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    if (!auth.isLoggedIn) return const LoginScreen();
    if (auth.userRole == 'restaurant') return const RestaurantDashboardScreen();
    return const MenuScreen();
  }
}
