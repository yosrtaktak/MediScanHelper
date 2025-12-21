import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediscanhelper/features/auth/presentation/providers/auth_provider.dart' as auth;
import 'package:mediscanhelper/features/auth/presentation/pages/login_page.dart';
import 'package:mediscanhelper/features/home/presentation/pages/home_page.dart';

/// Wrapper qui gère la navigation en fonction de l'état d'authentification
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = context.read<auth.AuthProvider>();
    await authProvider.loadCurrentUser();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Consumer<auth.AuthProvider>(
      builder: (context, authProvider, child) {
        // Si l'utilisateur est connecté, afficher la page d'accueil
        if (authProvider.isAuthenticated) {
          return const HomePage();
        }

        // Sinon, afficher la page de connexion
        return const LoginPage();
      },
    );
  }
}

