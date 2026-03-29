import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 48,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: isMobile ? _buildMobile(context) : _buildDesktop(context),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat, color: WebTheme.primaryColor, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'VentasApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'CRM para ventas por WhatsApp.\nPensado para PyMEs argentinas.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ],
          ),
        ),
        // Links
        Expanded(
          child: _FooterColumn(
            title: 'Producto',
            links: ['Funciones', 'Precios', 'Demo'],
          ),
        ),
        Expanded(
          child: _FooterColumn(
            title: 'Empresa',
            links: ['Sobre nosotros', 'Contacto', 'Blog'],
          ),
        ),
        Expanded(
          child: _FooterColumn(
            title: 'Legal',
            links: ['Términos', 'Privacidad'],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat, color: WebTheme.primaryColor, size: 24),
            const SizedBox(width: 8),
            const Text(
              'VentasApp',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'CRM para ventas por WhatsApp.',
          style: TextStyle(color: Colors.white38, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Text(
          '© 2026 VentasApp. Todos los derechos reservados.',
          style: TextStyle(color: Colors.white24, fontSize: 12),
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (l) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              l,
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
