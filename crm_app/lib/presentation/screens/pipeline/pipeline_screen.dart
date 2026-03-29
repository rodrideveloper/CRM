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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
              Text(
                'Nuevo cliente',
                style: Theme.of(
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
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
                child: const Text('Crear'),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...ClientStatus.values
                  .where((s) => s != client.status)
                  .map(
                    (status) => ListTile(
                      leading: Icon(
                        _statusIcon(status),
                        color: _statusColor(status),
                      ),
                      title: Text(status.label),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
      ClientStatus.newClient => Icons.fiber_new,
      ClientStatus.contacted => Icons.phone_callback,
      ClientStatus.interested => Icons.thumb_up_outlined,
      ClientStatus.negotiating => Icons.handshake_outlined,
      ClientStatus.closedWon => Icons.check_circle_outline,
      ClientStatus.closedLost => Icons.cancel_outlined,
    };
  }

  Color _statusColor(ClientStatus status) {
    return DesignTokens.statusColor(status.value);
  }

  @override
  Widget build(BuildContext context) {
    final pipeline = ref.watch(pipelineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pipeline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchSheet(),
          ),
        ],
      ),
      body: pipeline.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $err'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.read(clientsProvider.notifier).refresh(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (pipelineMap) {
          final statuses = ClientStatus.values;
          return Column(
            children: [
              // Status tabs (scrollable chips)
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: statuses.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final status = statuses[index];
                    final isSelected = _currentPage == index;
                    return ChoiceChip(
                      label: Text(
                        '${status.label} (${pipelineMap[status]?.length ?? 0})',
                      ),
                      selected: isSelected,
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
              // Pipeline columns (swipeable)
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateClientDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar clientes...',
              prefixIcon: Icon(Icons.search),
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
                  return const Center(child: Text('Escribí para buscar'));
                }
                if (clients.isEmpty) {
                  return const Center(child: Text('Sin resultados'));
                }
                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(client.name[0].toUpperCase()),
                      ),
                      title: Text(client.name),
                      subtitle: Text(client.status.label),
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
