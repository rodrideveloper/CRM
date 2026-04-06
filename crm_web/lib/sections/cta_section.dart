import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 32 : 56),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [WebTheme.gradientStart, WebTheme.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(
              '¿Listo para vender más?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 28 : 40,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const Text(
                'Empezá hoy gratis y llevá tu seguimiento comercial al siguiente nivel.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              icon: const Icon(Icons.rocket_launch, size: 20),
              label: const Text('Empezar mi prueba gratis'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: WebTheme.gradientEnd,
                minimumSize: const Size(260, 56),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '14 días gratis · Sin tarjeta de crédito · Cancelá cuando quieras',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
