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
            'Planes simples, sin sorpresas',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Empezá gratis. Escalá cuando lo necesites.',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          const SizedBox(height: 48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: isMobile
                ? Column(
                    children: [
                      _PricingCard(plan: _plans[0]),
                      const SizedBox(height: 24),
                      _PricingCard(plan: _plans[1]),
                      const SizedBox(height: 24),
                      _PricingCard(plan: _plans[2]),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _plans
                        .map(
                          (p) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: _PricingCard(plan: p),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

final _plans = [
  _Plan(
    name: 'Gratis',
    price: '\$0',
    period: 'por siempre',
    description: 'Para empezar a organizar tus ventas',
    features: [
      '1 usuario',
      'Hasta 50 clientes',
      'Pipeline visual',
      'Notas y tareas',
      'WhatsApp en un toque',
    ],
    cta: 'Empezar gratis',
    highlighted: false,
  ),
  _Plan(
    name: 'Pro',
    price: 'USD 9.99',
    period: '/mes',
    description: 'Para vendedores que quieren crecer',
    features: [
      'Todo lo del plan Gratis',
      'Clientes ilimitados',
      'Modo oscuro',
      'Exportar datos',
      'Sin marca de agua',
      'Soporte prioritario',
    ],
    cta: 'Elegir Pro',
    highlighted: true,
  ),
  _Plan(
    name: 'Equipo',
    price: 'USD 24.99',
    period: '/mes',
    description: 'Para equipos de venta',
    features: [
      'Todo lo del plan Pro',
      'Hasta 5 usuarios',
      'Base de datos compartida',
      'Reportes y métricas',
      'Soporte dedicado',
    ],
    cta: 'Elegir Equipo',
    highlighted: false,
  ),
];

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
