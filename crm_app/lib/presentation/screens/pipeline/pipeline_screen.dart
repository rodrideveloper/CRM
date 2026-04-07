import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../domain/entities/client.dart';
import '../../../domain/entities/pipeline_stage_config.dart';
import '../../providers/client_provider.dart';
import '../../providers/metrics_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../widgets/paywall_bottom_sheet.dart';
import '../../widgets/pipeline/pipeline_column.dart';

class PipelineScreen extends ConsumerStatefulWidget {
  const PipelineScreen({super.key});

  @override
  ConsumerState<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends ConsumerState<PipelineScreen> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
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
      useRootNavigator: true,
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
                      color: DesignTokens.primaryContainer.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: DesignTokens.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.newClient,
                    style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.name,
                  prefixIcon: const Icon(Icons.person_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.trim().isEmpty
                    ? context.l10n.nameRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: context.l10n.phoneWithCountry,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  hintText: context.l10n.phoneHint,
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: context.l10n.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: companyController,
                decoration: InputDecoration(
                  labelText: context.l10n.company,
                  prefixIcon: const Icon(Icons.business_outlined),
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: DesignTokens.primaryGradient,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(context.l10n.createClient),
                ),
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
      useRootNavigator: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.moveClientTo(client.name),
                style: Theme.of(
                  ctx,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...ClientStatus.values.where((s) => s != client.status).map((
                status,
              ) {
                final stages = ref.read(allPipelineStagesProvider);
                final stage = stages.firstWhere(
                  (s) => s.key == status.value,
                  orElse: () => PipelineStageConfig(
                    key: status.value,
                    label: status.label,
                    visible: true,
                    position: 0,
                  ),
                );
                return ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _statusColor(status).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    ),
                    child: Icon(
                      _statusIcon(status),
                      color: _statusColor(status),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    stage.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await ref
                        .read(clientsProvider.notifier)
                        .updateClientStatus(client.id, status);
                  },
                );
              }),
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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (ctx) => _FilterSheet(),
    );
  }

  void _showMetricsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) =>
            _MetricsSheet(scrollController: scrollController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pipeline = ref.watch(pipelineProvider);
    final hasFilters = ref.watch(hasActiveFiltersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.pipelineTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            onPressed: () => _showSearchSheet(),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_rounded, size: 22),
                onPressed: () => _showFilterSheet(),
              ),
              if (hasFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: DesignTokens.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, size: 22),
            onPressed: () => _showMetricsSheet(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: pipeline.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: DesignTokens.primary),
        ),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.somethingWentWrong,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$err',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: DesignTokens.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.read(clientsProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
        data: (pipelineMap) {
          final stages = ref.watch(pipelineStagesProvider);
          final totalClients = pipelineMap.values.fold<int>(
            0,
            (sum, list) => sum + list.length,
          );
          final currentStage = _currentPage < stages.length
              ? stages[_currentPage]
              : stages.first;
          final currentCount = pipelineMap[currentStage.status]?.length ?? 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Left: count
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$currentCount',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: DesignTokens.primary,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${currentStage.label.toUpperCase()} LEADS',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: DesignTokens.onSurfaceVariant,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Right: total with plan limit
                    Consumer(
                      builder: (context, ref, _) {
                        final limitsAsync = ref.watch(userLimitsProvider);
                        return limitsAsync.when(
                          loading: () => Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$totalClients',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: DesignTokens.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Total',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: DesignTokens.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          error: (_, __) => Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$totalClients',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: DesignTokens.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Total',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: DesignTokens.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          data: (limits) {
                            final isNearLimit =
                                !limits.isUnlimited &&
                                limits.remaining <= 3 &&
                                limits.remaining > 0;
                            final isAtLimit =
                                !limits.canCreateClient && !limits.isUnlimited;
                            return GestureDetector(
                              onTap: isAtLimit
                                  ? () => showPaywallBottomSheet(
                                      context,
                                      limits: limits,
                                    )
                                  : null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    limits.isUnlimited
                                        ? '$totalClients'
                                        : '${limits.clientCount}/${limits.clientLimit}',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          color: isAtLimit
                                              ? DesignTokens.error
                                              : isNearLimit
                                              ? DesignTokens.warning
                                              : DesignTokens.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    limits.isUnlimited ? 'Pro ∞' : 'Free',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: limits.isUnlimited
                                          ? DesignTokens.primary
                                          : DesignTokens.onSurfaceVariant,
                                      fontWeight: limits.isUnlimited
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Active filters banner
              if (hasFilters)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: DesignTokens.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                      border: Border.all(
                        color: DesignTokens.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.filter_list_rounded,
                          size: 16,
                          color: DesignTokens.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _buildFilterDescription(context),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: DesignTokens.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref.read(dateRangeFilterProvider.notifier).state =
                                null;
                            ref.read(sourceFilterProvider.notifier).state =
                                null;
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: DesignTokens.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Status chips
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final stage = stages[index];
                    final count = pipelineMap[stage.status]?.length ?? 0;
                    final isSelected = _currentPage == index;
                    final statusColor = _statusColor(stage.status);
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? statusColor.withValues(alpha: 0.15)
                              : DesignTokens.surfaceContainer,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusFull,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? statusColor.withValues(alpha: 0.3)
                                : DesignTokens.outlineVariant.withValues(
                                    alpha: 0.12,
                                  ),
                          ),
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
                              stage.label,
                              style: TextStyle(
                                color: isSelected
                                    ? statusColor
                                    : DesignTokens.onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$count',
                              style: TextStyle(
                                color: isSelected
                                    ? statusColor
                                    : DesignTokens.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Pipeline columns
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: stages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final stage = stages[index];
                    final clients = pipelineMap[stage.status] ?? [];
                    return PipelineColumn(
                      status: stage.status,
                      clients: clients,
                      onChangeStatus: _showChangeStatusSheet,
                      onRefresh: () =>
                          ref.read(clientsProvider.notifier).refresh(),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom:
              kBottomNavigationBarHeight +
              MediaQuery.of(context).padding.bottom +
              16,
        ),
        child: FloatingActionButton(
          onPressed: () {
            final limits = ref.read(userLimitsProvider).valueOrNull;
            if (limits != null && !limits.canCreateClient) {
              showPaywallBottomSheet(context, limits: limits);
            } else {
              _showCreateClientDialog();
            }
          },
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  String _buildFilterDescription(BuildContext context) {
    final parts = <String>[];
    final dateRange = ref.read(dateRangeFilterProvider);
    final source = ref.read(sourceFilterProvider);
    if (dateRange != null) {
      String fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
      parts.add('${fmt(dateRange.start)} → ${fmt(dateRange.end)}');
    }
    if (source != null) {
      parts.add(source);
    }
    return parts.join(' · ');
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
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
            decoration: InputDecoration(
              hintText: context.l10n.searchClients,
              prefixIcon: const Icon(Icons.search_rounded),
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
                    child: Text(
                      context.l10n.typeToSearch,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: DesignTokens.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                if (clients.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.noResults,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: DesignTokens.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    final statusColor = DesignTokens.statusColor(
                      client.status.value,
                    );
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: statusColor.withValues(alpha: 0.15),
                        child: Text(
                          client.name[0].toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(
                        client.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(client.status.localizedLabel(context)),
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

// ── Filter Sheet ───────────────────────────────────────────

class _FilterSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedSource;

  @override
  void initState() {
    super.initState();
    final dateRange = ref.read(dateRangeFilterProvider);
    _startDate = dateRange?.start;
    _endDate = dateRange?.end;
    _selectedSource = ref.read(sourceFilterProvider);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? now) : (_endDate ?? now),
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '—';
    return '${d.day}/${d.month}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sources = ref.watch(availableSourcesProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryContainer.withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                  child: const Icon(
                    Icons.filter_list_rounded,
                    color: DesignTokens.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.l10n.filters,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Date range filter
            Text(
              context.l10n.filterByDate,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(isStart: true),
                    icon: const Icon(Icons.calendar_today_rounded, size: 16),
                    label: Text(_formatDate(_startDate)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: DesignTokens.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(isStart: false),
                    icon: const Icon(Icons.calendar_today_rounded, size: 16),
                    label: Text(_formatDate(_endDate)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Source filter
            if (sources.isNotEmpty) ...[
              Text(
                context.l10n.filterBySource,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(context.l10n.allSources),
                    selected: _selectedSource == null,
                    onSelected: (_) => setState(() => _selectedSource = null),
                  ),
                  ...sources.map(
                    (source) => ChoiceChip(
                      label: Text(source),
                      selected: _selectedSource == source,
                      onSelected: (_) =>
                          setState(() => _selectedSource = source),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(dateRangeFilterProvider.notifier).state = null;
                      ref.read(sourceFilterProvider.notifier).state = null;
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.clearFilters),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: DesignTokens.primaryGradient,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply date range
                        if (_startDate != null && _endDate != null) {
                          ref.read(dateRangeFilterProvider.notifier).state =
                              DateTimeRange(start: _startDate!, end: _endDate!);
                        } else {
                          ref.read(dateRangeFilterProvider.notifier).state =
                              null;
                        }
                        // Apply source
                        ref.read(sourceFilterProvider.notifier).state =
                            _selectedSource;
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(context.l10n.apply),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Metrics Sheet ──────────────────────────────────────────

class _MetricsSheet extends ConsumerWidget {
  final ScrollController scrollController;
  const _MetricsSheet({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(metricsProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: metricsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: DesignTokens.primary),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (metrics) => ListView(
          controller: scrollController,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryContainer.withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: DesignTokens.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.l10n.metrics,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // KPI cards row
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: context.l10n.totalClients,
                    value: '${metrics.totalActive}',
                    icon: Icons.people_rounded,
                    color: DesignTokens.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: context.l10n.conversionRate,
                    value:
                        '${(metrics.conversionRate * 100).toStringAsFixed(1)}%',
                    icon: Icons.trending_up_rounded,
                    color: DesignTokens.statusClosedWon,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: context.l10n.newThisWeek,
                    value: '${metrics.newThisWeek}',
                    icon: Icons.calendar_today_rounded,
                    color: DesignTokens.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    label: context.l10n.newThisMonth,
                    value: '${metrics.newThisMonth}',
                    icon: Icons.date_range_rounded,
                    color: DesignTokens.statusInterested,
                  ),
                ),
              ],
            ),
            if (metrics.overdueTasks > 0) ...[
              const SizedBox(height: 12),
              _MetricCard(
                label: context.l10n.overdueTasks,
                value: '${metrics.overdueTasks}',
                icon: Icons.warning_rounded,
                color: DesignTokens.errorBright,
              ),
            ],

            const SizedBox(height: 24),

            // By status breakdown
            Text(
              context.l10n.byStatus,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...ClientStatus.values.map((status) {
              final count = metrics.byStatus[status] ?? 0;
              final total = metrics.totalActive;
              final pct = total > 0 ? count / total : 0.0;
              final color = DesignTokens.statusColor(status.value);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          status.localizedLabel(context),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$count',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: color.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: DesignTokens.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
