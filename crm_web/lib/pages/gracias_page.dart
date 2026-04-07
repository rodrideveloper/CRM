import 'package:flutter/material.dart';
import '../core/theme/web_theme.dart';

class GraciasPage extends StatelessWidget {
  const GraciasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: WebTheme.darkBg,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: WebTheme.primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: WebTheme.primaryColor,
                  size: 72,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '¡Gracias por suscribirte! 🎉',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 28 : 40,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Tu plan Pro ya está activo.\nAbrí la app y disfrutá de clientes ilimitados.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: isMobile ? 16 : 19,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/'),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Volver al inicio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WebTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
