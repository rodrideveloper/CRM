import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/theme/web_theme.dart';

class LeadCaptureSection extends StatefulWidget {
  const LeadCaptureSection({super.key});

  @override
  State<LeadCaptureSection> createState() => _LeadCaptureSectionState();
}

class _LeadCaptureSectionState extends State<LeadCaptureSection> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _loading = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _error = 'Ingresá tu número de WhatsApp');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      const formToken = String.fromEnvironment('FORM_TOKEN',
          defaultValue: 'c91eda2c-c647-4c52-a0b0-28ffb3d044d3');

      await Supabase.instance.client.rpc('submit_lead', params: {
        'p_form_token': formToken,
        'p_name': _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        'p_phone': phone,
      });
      setState(() {
        _submitted = true;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Hubo un error. Intentá de nuevo.';
        _loading = false;
      });
    }
  }

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
          Icon(
            Icons.chat_bubble_outline,
            color: WebTheme.primaryColor,
            size: 40,
          ),
          const SizedBox(height: 20),
          Text(
            '¿Querés ver cómo funciona?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 26 : 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Dejanos tu WhatsApp y te hacemos una demo personalizada',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 17),
          ),
          const SizedBox(height: 40),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _submitted ? _buildSuccess() : _buildForm(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: WebTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WebTheme.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WebTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: WebTheme.primaryColor,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '¡Listo! Te contactamos pronto',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Te vamos a escribir por WhatsApp para coordinar la demo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: WebTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Tu nombre (opcional)',
              labelStyle: TextStyle(color: Colors.white38),
              prefixIcon: Icon(Icons.person_outline, color: Colors.white38),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Tu número de WhatsApp',
              labelStyle: TextStyle(color: Colors.white38),
              hintText: 'Ej: 11 2345-6789',
              hintStyle: TextStyle(color: Colors.white24),
              prefixIcon: Icon(Icons.phone_android, color: Colors.white38),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(color: WebTheme.error, fontSize: 13),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loading ? null : _submit,
            icon: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send, size: 20),
            label: Text(_loading ? 'Enviando...' : 'Quiero mi demo'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No spam. Solo te contactamos para la demo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
