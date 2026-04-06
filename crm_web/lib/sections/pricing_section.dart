import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

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
      color: WebTheme.bgDeep,
      child: Column(
        children: [
          Text(
            'Empezá gratis. Crecé sin límites.',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sin tarjeta de crédito. Upgrade cuando quieras.',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          const SizedBox(height: 48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: isMobile
                ? Column(
                    children: [
                      _PricingCard(plan: _freePlan),
                      const SizedBox(height: 20),
                      _PricingCard(plan: _proPlan),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _PricingCard(plan: _freePlan)),
                      const SizedBox(width: 24),
                      Expanded(child: _PricingCard(plan: _proPlan)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

final _freePlan = _Plan(
  name: 'Free',
  price: '\$0',
  period: '/siempre',
  description: 'Ideal para arrancar y probar TRATAR',
  features: [
    'Hasta 15 clientes',
    'Pipeline visual tipo kanban',
    'Notas y tareas por cliente',
    'Contacto directo por WhatsApp',
    'Formulario de captación',
    'Tema claro y oscuro',
  ],
  cta: 'Crear cuenta gratis',
  highlighted: false,
);

final _proPlan = _Plan(
  name: 'Pro',
  price: '\$3.999',
  period: '/mes',
  description: 'Para los que quieren vender en serio',
  features: [
    'Clientes ilimitados',
    'Pipeline visual tipo kanban',
    'Notas y tareas por cliente',
    'Contacto directo por WhatsApp',
    'Formulario de captación',
    'Exportar datos (CSV)',
    'Tema claro y oscuro',
    'Soporte prioritario',
    'Todas las actualizaciones incluidas',
  ],
  cta: 'Empezar con Pro',
  highlighted: true,
);

class _Plan {
  final String name;
  final String price;
  final String period;
  final String description;
  final List<String> features;
  final String cta;
  final bool highlighted;

  const _Plan({
    required this.name,
    required this.price,
    required this.period,
    required this.description,
    required this.features,
    required this.cta,
    required this.highlighted,
  });
}

class _PricingCard extends StatefulWidget {
  final _Plan plan;
  const _PricingCard({required this.plan});

  @override
  State<_PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<_PricingCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: WebTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: plan.highlighted
                ? WebTheme.primaryColor
                : _hovering
                ? Colors.white24
                : Colors.white10,
            width: plan.highlighted ? 2 : 1,
          ),
          boxShadow: plan.highlighted
              ? [
                  BoxShadow(
                    color: WebTheme.primaryColor.withValues(alpha: 0.15),
                    blurRadius: 40,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plan.highlighted)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: WebTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Más popular',
                  style: TextStyle(
                    color: WebTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Text(
              plan.name,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    plan.period,
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.description,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white10),
            const SizedBox(height: 24),
            ...plan.features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: WebTheme.primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        f,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: plan.highlighted
                  ? ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: Text(plan.cta),
                    )
                  : OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: Text(plan.cta),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
