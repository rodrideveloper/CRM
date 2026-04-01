import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../domain/entities/client.dart';
import '../../providers/metrics_provider.dart';

class MetricsScreen extends ConsumerWidget {
  const MetricsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final metricsAsync = ref.watch(metricsProvider);
    final currencyFmt = NumberFormat('#,##0.00', 'es_AR');
    final compactFmt = NumberFormat.compact(locale: 'es');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.metricsTitle.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: metricsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(context.l10n.somethingWentWrong)),
        data: (metrics) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Revenue hero card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: DesignTokens.primaryGradient,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.totalRevenue.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: DesignTokens.onPrimary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$ ${currencyFmt.format(metrics.totalRevenue)}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: DesignTokens.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniStat(
                            label: context.l10n.revenueThisMonth,
                            value: '\$ ${compactFmt.format(metrics.revenueThisMonth)}',
                            color: DesignTokens.onPrimary,
                          ),
                        ),
                        Expanded(
                          child: _MiniStat(
                            label: context.l10n.revenueWon,
                            value: '\$ ${compactFmt.format(metrics.revenueByStatus[ClientStatus.closedWon] ?? 0)}',
                            color: DesignTokens.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Stats grid
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.people_rounded,
                      label: context.l10n.totalClients,
                      value: '${metrics.totalActive}',
                      color: DesignTokens.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.trending_up_rounded,
                      label: context.l10n.conversionRate,
                      value: '${(metrics.conversionRate * 100).toStringAsFixed(1)}%',
                      color: DesignTokens.statusClosedWon,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.fiber_new_rounded,
                      label: context.l10n.newThisWeek,
                      value: '${metrics.newThisWeek}',
                      color: DesignTokens.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.calendar_month_rounded,
                      label: context.l10n.newThisMonth,
                      value: '${metrics.newThisMonth}',
                      color: DesignTokens.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Revenue by status
              Text(
                context.l10n.revenueByStatus.toUpperCase(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              ...ClientStatus.values.map((status) {
                final revenue = metrics.revenueByStatus[status] ?? 0;
                final count = metrics.byStatus[status] ?? 0;
                if (count == 0 && revenue == 0) return const SizedBox.shrink();
                final maxRevenue = metrics.totalRevenue > 0
                    ? metrics.totalRevenue
                    : 1.0;
                final fraction = revenue / maxRevenue;
                final statusColor = DesignTokens.statusColor(status.value);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: DesignTokens.surfaceContainer,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
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
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  status.localizedLabel(context),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '($count)',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: DesignTokens.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$ ${currencyFmt.format(revenue)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                          child: LinearProgressIndicator(
                            value: fraction,
                            backgroundColor: statusColor.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation(statusColor),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              if (metrics.overdueTasks > 0) ...[
                _StatCard(
                  icon: Icons.warning_amber_rounded,
                  label: context.l10n.overdueTasks,
                  value: '${metrics.overdueTasks}',
                  color: DesignTokens.errorBright,
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: DesignTokens.outlineVariant.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
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

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: color.withValues(alpha: 0.7),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
