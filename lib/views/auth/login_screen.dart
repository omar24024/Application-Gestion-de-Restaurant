import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../restaurant/dashboard_screen.dart';
import '../client/menu_screen.dart';
import 'register_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Bouton langue en haut à droite
            Positioned(
              top: 8,
              right: 8,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.language, color: Colors.orange),
                onSelected: (val) {
                  context.read<LocaleProvider>().setLocale(
                    val == 'fr' ? const Locale('fr') : const Locale('en'),
                  );
                },
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'fr', child: Text(l10n.french)),
                  PopupMenuItem(value: 'en', child: Text(l10n.english)),
                ],
              ),
            ),
            // Contenu principal centré
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.restaurant, size: 80, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(l10n.appTitle,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  if (auth.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(auth.errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              final ok = await auth.login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                              if (ok && context.mounted) {
                                final role = auth.userRole;
                                if (role == 'restaurant') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const RestaurantDashboardScreen()),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const MenuScreen()),
                                  );
                                }
                              }
                            },
                      child: auth.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(l10n.login,
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: Text(l10n.noAccount),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
