import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    final steps = [
      _Step(
        number: '1',
        title: 'Registrate gratis',
        description: 'Creá tu cuenta en 30 segundos. Sin tarjeta de crédito.',
        icon: Icons.person_add,
      ),
      _Step(
        number: '2',
        title: 'Cargá tus clientes',
        description:
            'Agregá tus contactos al pipeline y organizalos por etapa.',
        icon: Icons.people,
      ),
      _Step(
        number: '3',
        title: 'Gestioná y vendé',
        description:
            'Hacé seguimiento, enviá WhatsApp y cerrá más ventas desde tu celular.',
        icon: Icons.trending_up,
      ),
    ];

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
          colors: [WebTheme.bgDeep, WebTheme.darkBg],
        ),
      ),
      child: Column(
        children: [
          Text(
            '¿Cómo funciona?',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Empezá a vender más en 3 simples pasos',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          const SizedBox(height: 56),
          isMobile
              ? Column(
                  children: steps
                      .map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _StepCard(step: s),
                        ),
                      )
                      .toList(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: steps
                      .map(
                        (s) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: _StepCard(step: s),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _Step {
  final String number;
  final String title;
  final String description;
  final IconData icon;

  const _Step({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _StepCard extends StatelessWidget {
  final _Step step;
  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [WebTheme.gradientStart, WebTheme.gradientEnd],
                ),
                boxShadow: [
                  BoxShadow(
                    color: WebTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  step.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          step.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          step.description,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 15,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
