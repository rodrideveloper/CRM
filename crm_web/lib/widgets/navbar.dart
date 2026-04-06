import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class Navbar extends StatelessWidget {
  final VoidCallback? onFeatures;
  final VoidCallback? onPricing;
  final VoidCallback? onHowItWorks;

  const Navbar({super.key, this.onFeatures, this.onPricing, this.onHowItWorks});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: WebTheme.darkBg.withValues(alpha: 0.95),
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 48),
      child: Row(
        children: [
          // Logo
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat, color: WebTheme.primaryColor, size: 28),
              const SizedBox(width: 8),
              Text(
                'TRATAR',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (!isMobile) ...[
            _NavLink(label: 'Funciones', onTap: () => onFeatures?.call()),
            const SizedBox(width: 32),
            _NavLink(label: 'Precios', onTap: () => onPricing?.call()),
            const SizedBox(width: 32),
            _NavLink(label: 'Cómo funciona', onTap: () => onHowItWorks?.call()),
            const SizedBox(width: 32),
          ],
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(100, 40)),
            child: const Text('Iniciar sesión'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(140, 40)),
            child: const Text('Empezar gratis'),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: TextStyle(
            color: _hovering ? WebTheme.primaryColor : Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
