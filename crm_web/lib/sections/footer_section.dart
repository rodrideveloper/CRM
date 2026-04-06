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
                    'TRATAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'CRM para ventas por WhatsApp.\nPensado para PyMEs argentinas.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                '© 2026 TRATAR. Todos los derechos reservados.',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ],
          ),
        ),
        // Contact
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contacto',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'hola@tratar.app',
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ],
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
              'TRATAR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
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
          '© 2026 TRATAR. Todos los derechos reservados.',
          style: TextStyle(color: Colors.white24, fontSize: 12),
        ),
      ],
    );
  }
}
