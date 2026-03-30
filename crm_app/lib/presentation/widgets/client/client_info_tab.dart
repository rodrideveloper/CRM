import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
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
    _companyController = TextEditingController(
      text: widget.client.company ?? '',
    );
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

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteClient),
        content: Text(context.l10n.deleteClientConfirm(widget.client.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: DesignTokens.error),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await ref
          .read(clientsProvider.notifier)
          .softDeleteClient(widget.client.id);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.clientDeleted),
            action: SnackBarAction(
              label: context.l10n.undo,
              onPressed: () {
                ref
                    .read(clientsProvider.notifier)
                    .restoreClient(widget.client.id);
              },
            ),
          ),
        );
      }
    }
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
      ).showSnackBar(SnackBar(content: Text(context.l10n.clientUpdated)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = DesignTokens.statusColor(widget.client.status.value);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.client.status.localizedLabel(context),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Form fields in a card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                boxShadow: DesignTokens.shadowSoft,
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: context.l10n.name,
                      prefixIcon: const Icon(Icons.person_outlined),
                    ),
                    enabled: _editing,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? context.l10n.required
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: context.l10n.phone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      hintText: context.l10n.phoneHint,
                    ),
                    enabled: _editing,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: context.l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    enabled: _editing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: context.l10n.company,
                      prefixIcon: const Icon(Icons.business_outlined),
                    ),
                    enabled: _editing,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _sourceController,
                    decoration: InputDecoration(
                      labelText: context.l10n.source,
                      prefixIcon: const Icon(Icons.source_outlined),
                      hintText: context.l10n.sourceHint,
                    ),
                    enabled: _editing,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_editing) ...[
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded),
                label: Text(context.l10n.save),
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
                child: Text(context.l10n.cancel),
              ),
            ] else
              OutlinedButton.icon(
                onPressed: () => setState(() => _editing = true),
                icon: const Icon(Icons.edit_rounded),
                label: Text(context.l10n.edit),
              ),
            const SizedBox(height: 20),
            // Metadata
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: DesignTokens.bgSubtle,
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: Column(
                children: [
                  _buildMetaRow(
                    Icons.calendar_today_rounded,
                    context.l10n.created,
                    _formatDate(widget.client.createdAt),
                    theme,
                  ),
                  const SizedBox(height: 6),
                  _buildMetaRow(
                    Icons.update_rounded,
                    context.l10n.updated,
                    _formatDate(widget.client.updatedAt),
                    theme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Delete button
            OutlinedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_rounded),
              label: Text(context.l10n.deleteClient),
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignTokens.error,
                side: BorderSide(
                  color: DesignTokens.error.withValues(alpha: 0.3),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label: $value',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
