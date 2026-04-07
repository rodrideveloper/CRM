import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class LeadCaptureSection extends StatelessWidget {
  const LeadCaptureSection({super.key});

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [WebTheme.darkBg, WebTheme.bgDeep],
        ),
      ),
      child: Column(
        children: [
          // Section badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: WebTheme.teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WebTheme.teal.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: WebTheme.teal, size: 16),
                const SizedBox(width: 6),
                Text(
                  'PLAN PRO',
                  style: TextStyle(
                    color: WebTheme.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Captá leads desde tu web',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 26 : 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: const Text(
              'Con el plan Pro, generás un formulario embebible para tu '
              'sitio web. Cada contacto cae directo a tu pipeline como '
              'cliente nuevo, listo para que lo gestiones.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Two-column layout: mockup + features
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: isMobile
                ? Column(
                    children: [
                      _buildFormMockup(),
                      const SizedBox(height: 32),
                      _buildFeatureList(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFormMockup()),
                      const SizedBox(width: 48),
                      Expanded(child: _buildFeatureList()),
                    ],
                  ),
          ),
          const SizedBox(height: 48),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            icon: const Icon(Icons.rocket_launch, size: 20),
            label: const Text('Empezá gratis'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(260, 56)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gratis para siempre · Upgrade a Pro cuando quieras',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// Visual mockup of the lead capture form (non-interactive).
  Widget _buildFormMockup() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: WebTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: WebTheme.primaryColor.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: WebTheme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: WebTheme.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: WebTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Formulario de captación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Fake name field
          _buildMockField(Icons.person_outline, 'Nombre'),
          const SizedBox(height: 12),
          // Fake phone field
          _buildMockField(Icons.phone_android, 'Teléfono'),
          const SizedBox(height: 20),
          // Fake submit button
          Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: WebTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Enviar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Arrow + label showing it goes to pipeline
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_downward_rounded,
                color: WebTheme.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Cae directo a tu pipeline',
                style: TextStyle(
                  color: WebTheme.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMockField(IconData icon, String label) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: WebTheme.bgDeep,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white24, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white24, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    const features = [
      _Feature(
        Icons.link,
        'Link único para tu negocio',
        'Compartilo por WhatsApp, redes o embebelo en tu web.',
      ),
      _Feature(
        Icons.bolt,
        'Leads automáticos',
        'Cada contacto se crea como cliente nuevo en tu pipeline.',
      ),
      _Feature(
        Icons.notifications_active_outlined,
        'Notificación al instante',
        'Te enterás apenas alguien completa el formulario.',
      ),
      _Feature(
        Icons.shield_outlined,
        'Sin límite de leads',
        'Con el plan Pro, recibí todos los contactos que necesites.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features
          .map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: WebTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(f.icon, color: WebTheme.primaryColor, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          f.description,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  const _Feature(this.icon, this.title, this.description);
}
