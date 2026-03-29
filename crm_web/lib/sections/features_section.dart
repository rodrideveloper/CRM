import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final crossAxisCount = isMobile ? 1 : (width < 1100 ? 2 : 3);

    final features = [
      _Feature(
        icon: Icons.view_kanban,
        title: 'Pipeline visual',
        description:
            'Visualizá todos tus clientes organizados por etapa de venta. '
            'Movelos con un toque a medida que avanzan.',
        color: Colors.blue,
      ),
      _Feature(
        icon: Icons.chat,
        title: 'WhatsApp en un toque',
        description:
            'Contactá a tus clientes directamente desde la app. '
            'Sin copiar números, sin perder tiempo.',
        color: WebTheme.primaryColor,
      ),
      _Feature(
        icon: Icons.task_alt,
        title: 'Tareas de seguimiento',
        description:
            'Creá recordatorios para cada cliente. '
            'Nunca más pierdas una oportunidad por olvidarte de hacer follow-up.',
        color: Colors.orange,
      ),
      _Feature(
        icon: Icons.note_alt,
        title: 'Notas por cliente',
        description:
            'Registrá toda la información importante de cada conversación. '
            'Tené el contexto siempre a mano.',
        color: Colors.purple,
      ),
      _Feature(
        icon: Icons.phone_android,
        title: '100% mobile',
        description:
            'Diseñado para usar desde el celular. '
            'Gestioná tus ventas desde donde estés, cuando quieras.',
        color: Colors.cyan,
      ),
      _Feature(
        icon: Icons.dark_mode,
        title: 'Modo oscuro',
        description:
            'Cuidá tus ojos con el tema oscuro. '
            'Perfecto para usar de noche o en ambientes con poca luz.',
        color: Colors.indigo,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      color: const Color(0xFF0B1121),
      child: Column(
        children: [
          Text(
            'Todo lo que necesitás',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Herramientas simples y poderosas para cerrar más ventas',
            style: TextStyle(
              color: Colors.white54,
              fontSize: isMobile ? 15 : 18,
            ),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = crossAxisCount == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - (crossAxisCount - 1) * 24) /
                      crossAxisCount;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: features.map((f) {
                  return SizedBox(
                    width: cardWidth,
                    child: _FeatureCard(feature: f),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  const _FeatureCard({required this.feature});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hovering
              ? WebTheme.cardBg.withValues(alpha: 0.8)
              : WebTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovering
                ? widget.feature.color.withValues(alpha: 0.4)
                : Colors.white10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.feature.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.feature.icon,
                color: widget.feature.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.feature.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.feature.description,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
