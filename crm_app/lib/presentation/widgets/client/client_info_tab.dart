import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/client.dart';
import '../../providers/client_provider.dart';
import '../../providers/repository_providers.dart';

class ClientInfoTab extends ConsumerStatefulWidget {
  final Client client;
  const ClientInfoTab({super.key, required this.client});

  @override
  ConsumerState<ClientInfoTab> createState() => _ClientInfoTabState();
}

class _ClientInfoTabState extends ConsumerState<ClientInfoTab> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _companyController;
  late TextEditingController _sourceController;
  bool _editing = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _phoneController = TextEditingController(text: widget.client.phone ?? '');
    _emailController = TextEditingController(text: widget.client.email ?? '');
    _companyController = TextEditingController(text: widget.client.company ?? '');
    _sourceController = TextEditingController(text: widget.client.source ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(clientRepositoryProvider);
    await repo.updateClient(
      widget.client.id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
      company: _companyController.text.trim().isNotEmpty
          ? _companyController.text.trim()
          : null,
      source: _sourceController.text.trim().isNotEmpty
          ? _sourceController.text.trim()
          : null,
    );
    await ref.read(clientsProvider.notifier).refresh();
    if (mounted) {
      setState(() => _editing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cliente actualizado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status badge
            Center(
              child: Chip(
                label: Text(
                  widget.client.status.label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                avatar: const Icon(Icons.circle, size: 12),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person_outlined),
              ),
              enabled: _editing,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone_outlined),
                hintText: '+5491112345678',
              ),
              enabled: _editing,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              enabled: _editing,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Empresa',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              enabled: _editing,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Origen',
                prefixIcon: Icon(Icons.source_outlined),
                hintText: 'Ej: Instagram, referido, web',
              ),
              enabled: _editing,
            ),
            const SizedBox(height: 24),
            if (_editing) ...[
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  _nameController.text = widget.client.name;
                  _phoneController.text = widget.client.phone ?? '';
                  _emailController.text = widget.client.email ?? '';
                  _companyController.text = widget.client.company ?? '';
                  _sourceController.text = widget.client.source ?? '';
                  setState(() => _editing = false);
                },
                child: const Text('Cancelar'),
              ),
            ] else
              OutlinedButton.icon(
                onPressed: () => setState(() => _editing = true),
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
              ),
            const SizedBox(height: 16),
            // Metadata
            Text(
              'Creado: ${_formatDate(widget.client.createdAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Actualizado: ${_formatDate(widget.client.updatedAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
