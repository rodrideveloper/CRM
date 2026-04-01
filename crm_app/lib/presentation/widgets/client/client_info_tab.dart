import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  late TextEditingController _dealValueController;
  String _currency = 'ARS';
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
    _dealValueController = TextEditingController(
      text: widget.client.dealValue != null
          ? widget.client.dealValue!.toStringAsFixed(2)
          : '',
    );
    _currency = widget.client.currency ?? 'ARS';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _sourceController.dispose();
    _dealValueController.dispose();
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
    final dealVal = _dealValueController.text.trim().isNotEmpty
        ? double.tryParse(_dealValueController.text.trim())
        : null;
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
      dealValue: dealVal,
      currency: _currency,
      clearDealValue: _dealValueController.text.trim().isEmpty,
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
            // Info card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DesignTokens.surfaceContainerLow,
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                border: Border.all(
                  color: DesignTokens.outlineVariant.withValues(alpha: 0.12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NOMBRE COMPLETO',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: DesignTokens.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                      ),
                      if (!_editing)
                        GestureDetector(
                          onTap: () => setState(() => _editing = true),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 18,
                            color: DesignTokens.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (_editing)
                    TextFormField(
                      controller: _nameController,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? context.l10n.required
                          : null,
                    )
                  else
                    Text(
                      widget.client.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TELÉFONO',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: DesignTokens.onSurfaceVariant,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (_editing)
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                              )
                            else
                              Text(
                                widget.client.phone ?? '—',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: DesignTokens.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ESTADO',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: DesignTokens.onSurfaceVariant,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(
                                  DesignTokens.radiusFull,
                                ),
                              ),
                              child: Text(
                                widget.client.status
                                    .localizedLabel(context)
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_editing) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: context.l10n.email,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _companyController,
                      decoration: InputDecoration(
                        labelText: context.l10n.company,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _sourceController,
                      decoration: InputDecoration(
                        labelText: context.l10n.source,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _dealValueController,
                            decoration: InputDecoration(
                              labelText: context.l10n.dealValue,
                              prefixText: '\$ ',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _currency,
                            decoration: InputDecoration(
                              labelText: context.l10n.currency,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'ARS',
                                child: Text('ARS'),
                              ),
                              DropdownMenuItem(
                                value: 'USD',
                                child: Text('USD'),
                              ),
                              DropdownMenuItem(
                                value: 'BRL',
                                child: Text('BRL'),
                              ),
                              DropdownMenuItem(
                                value: 'EUR',
                                child: Text('EUR'),
                              ),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => _currency = v);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Deal value display (always visible)
                  if (widget.client.dealValue != null && !_editing) ...[
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.dealValue.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: DesignTokens.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$ ${NumberFormat('#,##0.00', 'es_AR').format(widget.client.dealValue)} ${widget.client.currency ?? 'ARS'}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DesignTokens.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'FECHA DE CREACIÓN',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: DesignTokens.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateLong(widget.client.createdAt),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: DesignTokens.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Follow-up reminder card
            _buildFollowUpCard(context, theme),
            const SizedBox(height: 16),
            if (_editing) ...[
              Container(
                decoration: BoxDecoration(
                  gradient: DesignTokens.primaryGradient,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(context.l10n.save),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  _nameController.text = widget.client.name;
                  _phoneController.text = widget.client.phone ?? '';
                  _emailController.text = widget.client.email ?? '';
                  _companyController.text = widget.client.company ?? '';
                  _sourceController.text = widget.client.source ?? '';
                  _dealValueController.text = widget.client.dealValue != null
                      ? widget.client.dealValue!.toStringAsFixed(2)
                      : '';
                  _currency = widget.client.currency ?? 'ARS';
                  setState(() => _editing = false);
                },
                child: Text(context.l10n.cancel),
              ),
              const SizedBox(height: 16),
            ],
            // Delete button
            OutlinedButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_rounded),
              label: Text(context.l10n.deleteClient),
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignTokens.error,
                side: BorderSide(
                  color: DesignTokens.error.withValues(alpha: 0.2),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUpCard(BuildContext context, ThemeData theme) {
    final followUp = widget.client.nextFollowUp;
    final isDue = widget.client.hasFollowUpDue;
    final cardColor = isDue
        ? DesignTokens.error.withValues(alpha: 0.08)
        : DesignTokens.surfaceContainerLow;
    final borderColor = isDue
        ? DesignTokens.error.withValues(alpha: 0.3)
        : DesignTokens.outlineVariant.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDue ? Icons.alarm_on_rounded : Icons.schedule_rounded,
                size: 20,
                color: isDue ? DesignTokens.error : DesignTokens.primary,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.followUpReminder,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDue ? DesignTokens.error : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (followUp != null) ...[
            Text(
              isDue ? context.l10n.followUpDue : context.l10n.followUpScheduled,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDue
                    ? DesignTokens.error
                    : DesignTokens.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(followUp),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDue ? DesignTokens.error : null,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickFollowUpDate(context),
                    icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                    label: Text(context.l10n.followUpDate),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _clearFollowUp(context),
                    icon: const Icon(Icons.clear_rounded, size: 16),
                    label: Text(context.l10n.removeFollowUp),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DesignTokens.error,
                      side: BorderSide(
                        color: DesignTokens.error.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _pickFollowUpDate(context),
                icon: const Icon(Icons.add_alarm_rounded, size: 18),
                label: Text(context.l10n.setFollowUp),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DesignTokens.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickFollowUpDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate:
          widget.client.nextFollowUp ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: widget.client.nextFollowUp != null
          ? TimeOfDay.fromDateTime(widget.client.nextFollowUp!)
          : const TimeOfDay(hour: 10, minute: 0),
    );
    if (!mounted) return;

    final selectedTime = time ?? const TimeOfDay(hour: 10, minute: 0);
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final repo = ref.read(clientRepositoryProvider);
    await repo.updateClient(widget.client.id, nextFollowUp: dateTime);
    await ref.read(clientsProvider.notifier).refresh();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.followUpUpdated)));
    }
  }

  Future<void> _clearFollowUp(BuildContext context) async {
    final repo = ref.read(clientRepositoryProvider);
    await repo.updateClient(widget.client.id, clearFollowUp: true);
    await ref.read(clientsProvider.notifier).refresh();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.followUpUpdated)));
    }
  }

  String _formatDateLong(DateTime dt) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${dt.day} de ${months[dt.month - 1]}, ${dt.year}';
  }
}
