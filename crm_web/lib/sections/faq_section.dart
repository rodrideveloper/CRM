import 'package:flutter/material.dart';

import '../core/theme/web_theme.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

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
            'Preguntas frecuentes',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 40),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: const Column(
              children: [
                _FaqItem(
                  question: '¿Puedo probarlo gratis?',
                  answer:
                      'Sí. Tenés 14 días de prueba gratis con acceso completo a todas las funcionalidades. No necesitás tarjeta de crédito.',
                ),
                _FaqItem(
                  question: '¿Se conecta directo a WhatsApp?',
                  answer:
                      'TRATAR no es una integración de WhatsApp. Lo que hace es permitirte abrir una conversación con tu cliente en WhatsApp desde la app, en un toque, sin copiar números. Simple y directo.',
                ),
                _FaqItem(
                  question: '¿Funciona en iPhone y Android?',
                  answer:
                      'Sí, TRATAR funciona en ambos sistemas operativos. Es una app nativa que podés descargar e instalar en tu celular.',
                ),
                _FaqItem(
                  question: '¿Mis datos están seguros?',
                  answer:
                      'Tus datos son privados y están protegidos. Cada usuario solo puede ver sus propios clientes. Usamos encriptación y servidores seguros.',
                ),
                _FaqItem(
                  question: '¿Qué es el precio fundador?',
                  answer:
                      'Los primeros 50 usuarios que se suscriban pagan \$2.999/mes en lugar de \$5.999/mes. Es nuestro precio especial de lanzamiento y se mantiene mientras sigas suscripto.',
                ),
                _FaqItem(
                  question: '¿Puedo cancelar en cualquier momento?',
                  answer:
                      'Sí, podés cancelar cuando quieras. Sin contratos, sin permanencia mínima, sin letra chica.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: WebTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 16,
          ),
          title: Text(
            widget.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: AnimatedRotation(
            turns: _expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.expand_more, color: Colors.white54),
          ),
          onExpansionChanged: (v) => setState(() => _expanded = v),
          children: [
            Text(
              widget.answer,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
