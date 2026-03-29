import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/client.dart';
import '../../providers/client_provider.dart';
import '../../widgets/pipeline/pipeline_column.dart';

class PipelineScreen extends ConsumerStatefulWidget {
  const PipelineScreen({super.key});

  @override
  ConsumerState<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends ConsumerState<PipelineScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showCreateClientDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final companyController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: DesignTokens.primaryLight,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: DesignTokens.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Nuevo cliente',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'El nombre es requerido'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (con código de país)',
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: '+5491112345678',
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: companyController,
                decoration: const InputDecoration(
                  labelText: 'Empresa',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  Navigator.pop(ctx);
                  await ref
                      .read(clientsProvider.notifier)
                      .createClient(
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim().isNotEmpty
                            ? phoneController.text.trim()
                            : null,
                        email: emailController.text.trim().isNotEmpty
                            ? emailController.text.trim()
                            : null,
                        company: companyController.text.trim().isNotEmpty
                            ? companyController.text.trim()
                            : null,
                      );
                },
                child: const Text('Crear cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangeStatusSheet(Client client) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mover "${client.name}" a:',
                style: Theme.of(
                  ctx,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...ClientStatus.values
                  .where((s) => s != client.status)
                  .map(
                    (status) => ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _statusColor(status).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusS,
                          ),
                        ),
                        child: Icon(
                          _statusIcon(status),
                          color: _statusColor(status),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        status.label,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusS,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(ctx);
                        await ref
                            .read(clientsProvider.notifier)
                            .updateClientStatus(client.id, status);
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _statusIcon(ClientStatus status) {
    return switch (status) {
      ClientStatus.newClient => Icons.fiber_new_rounded,
      ClientStatus.contacted => Icons.phone_callback_rounded,
      ClientStatus.interested => Icons.thumb_up_rounded,
      ClientStatus.negotiating => Icons.handshake_rounded,
      ClientStatus.closedWon => Icons.check_circle_rounded,
      ClientStatus.closedLost => Icons.cancel_rounded,
    };
  }

  Color _statusColor(ClientStatus status) {
    return DesignTokens.statusColor(status.value);
  }

  @override
  Widget build(BuildContext context) {
    final pipeline = ref.watch(pipelineProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pipeline 🎯'),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: DesignTokens.bgSubtle,
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: const Icon(Icons.search_rounded, size: 20),
            ),
            onPressed: () => _showSearchSheet(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pipeline.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😕', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                'Algo salió mal',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$err',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.read(clientsProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (pipelineMap) {
          final statuses = ClientStatus.values;
          return Column(
            children: [
              // Status chips
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: statuses.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final status = statuses[index];
                    final count = pipelineMap[status]?.length ?? 0;
                    final isSelected = _currentPage == index;
                    final statusColor = _statusColor(status);
                    return ChoiceChip(
                      label: Text('${status.label} ($count)'),
                      selected: isSelected,
                      selectedColor: statusColor.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? statusColor
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                      side: isSelected
                          ? BorderSide(
                              color: statusColor.withValues(alpha: 0.3),
                            )
                          : BorderSide(color: Colors.grey.shade200),
                      onSelected: (_) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Pipeline columns
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: statuses.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final status = statuses[index];
                    final clients = pipelineMap[status] ?? [];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: PipelineColumn(
                        status: status,
                        clients: clients,
                        onChangeStatus: _showChangeStatusSheet,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateClientDialog,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Nuevo'),
      ),
    );
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) =>
            _SearchSheet(scrollController: scrollController),
      ),
    );
  }
}

class _SearchSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const _SearchSheet({required this.scrollController});

  @override
  ConsumerState<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends ConsumerState<_SearchSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(filteredClientsProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar clientes...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (value) {
              ref.read(clientSearchQueryProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (clients) {
                if (_searchController.text.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        Text(
                          'Escribí para buscar',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (clients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🤷', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        Text(
                          'Sin resultados',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: DesignTokens.statusColor(
                          client.status.value,
                        ).withValues(alpha: 0.15),
                        child: Text(
                          client.name[0].toUpperCase(),
                          style: TextStyle(
                            color: DesignTokens.statusColor(
                              client.status.value,
                            ),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(
                        client.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(client.status.label),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusS,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/client/${client.id}');
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
