import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [WebTheme.darkBg, WebTheme.bgSubtle],
        ),
      ),
      child: Column(
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: WebTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: WebTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: WebTheme.primaryColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  'CRM #1 para ventas por WhatsApp',
                  style: TextStyle(
                    color: WebTheme.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 32 : 40),
          // Main headline
          Text(
            'Vendé más por WhatsApp\ncon un CRM pensado para vos',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 32 : 56,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          // Subtitle
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Organizá tus clientes en un pipeline visual, registrá notas, '
              'creá tareas de seguimiento y contactá por WhatsApp en un toque. '
              'Todo desde tu celular.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: isMobile ? 16 : 19,
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 40 : 48),
          // CTA buttons
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                icon: const Icon(Icons.rocket_launch, size: 20),
                label: const Text('Probá 14 días gratis'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(240, 56),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_circle_outline, size: 20),
                label: const Text('Ver demo'),
              ),
            ],
          ),
          const SizedBox(height: 48),
          // Social proof
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stacked avatars
              SizedBox(
                width: 88,
                height: 36,
                child: Stack(
                  children: List.generate(3, (i) {
                    return Positioned(
                      left: i * 26.0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: WebTheme.primaryColor,
                        child: Text(
                          ['M', 'L', 'J'][i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (_) =>
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Sumate a las PyMEs que ya usan VentasApp',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
