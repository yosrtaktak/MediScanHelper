import 'package:flutter/material.dart';
import 'package:mediscanhelper/core/constants/app_colors.dart';
import 'package:mediscanhelper/core/constants/app_sizes.dart';
import 'package:mediscanhelper/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mediscanhelper/l10n/app_localizations.dart';

/// Page de démarrage avec animation moderne et professionnelle
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToAuth();
  }

  /// Navigation automatique vers la vérification d'authentification après 3.5 secondes
  Future<void> _navigateToAuth() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AuthWrapper(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: Stack(
          children: [
            // Background Pattern / Blobs (Optional for "Premium" feel)
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ).animate(onPlay: (c) => c.repeat()).scale(
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
              ).then().scale(
                 duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
                 begin: const Offset(1.1, 1.1),
                end: const Offset(1, 1),
              ),
            ),
             Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    
                    // Logo Container avec Glassmorphism subtle
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingXl),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_hospital_rounded, // Icone plus medicale
                        size: 80, // Plus grand
                        color: AppColors.white,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut),

                    const SizedBox(height: AppSizes.spacingXl),

                    // Nom de l'application
                    Text(
                      l10n.appName.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .moveY(begin: 20, end: 0, delay: 400.ms, duration: 600.ms, curve: Curves.easeOut),

                    const SizedBox(height: AppSizes.spacingS),

                    // Description / Slogan
                    Text(
                      l10n.appDescription,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300,
                          ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms),

                    const Spacer(),

                    // Loading Indicator moderne
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white.withOpacity(0.8)),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1000.ms),
                    
                    const SizedBox(height: AppSizes.spacingXl),
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

