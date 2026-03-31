import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../providers/task_provider.dart';
import '../../providers/repository_providers.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(pendingTasksProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.tasksTitle.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: () => ref.invalidate(pendingTasksProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: DesignTokens.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
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
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(pendingTasksProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.celebration_rounded,
                    size: 56,
                    color: DesignTokens.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.allCaughtUp,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.noPendingTasks,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: DesignTokens.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          final overdue = tasks.where((t) => t.isOverdue).toList();
          final today = tasks.where((t) {
            if (t.isOverdue) return false;
            if (t.dueDate == null) return false;
            final now = DateTime.now();
            return t.dueDate!.year == now.year &&
                t.dueDate!.month == now.month &&
                t.dueDate!.day == now.day;
          }).toList();
          final upcoming = tasks.where((t) {
            if (t.isOverdue) return false;
            if (t.dueDate == null) return true;
            final now = DateTime.now();
            return !(t.dueDate!.year == now.year &&
                t.dueDate!.month == now.month &&
                t.dueDate!.day == now.day);
          }).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(pendingTasksProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary cards
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        count: tasks.length,
                        label: 'PENDIENTES',
                        color: DesignTokens.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        count: overdue.length,
                        label: 'VENCIDAS',
                        color: DesignTokens.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Overdue section
                if (overdue.isNotEmpty) ...[
                  _SectionHeader(
                    label: 'VENCIDAS',
                    color: DesignTokens.error,
                    count: overdue.length,
                  ),
                  const SizedBox(height: 8),
                  ...overdue.map(
                    (task) => _TaskCard(
                      task: task,
                      isOverdue: true,
                      ref: ref,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // Today section
                if (today.isNotEmpty) ...[
                  _SectionHeader(
                    label: 'HOY',
                    color: DesignTokens.primary,
                    count: today.length,
                  ),
                  const SizedBox(height: 8),
                  ...today.map(
                    (task) => _TaskCard(
                      task: task,
                      isOverdue: false,
                      ref: ref,
                      context: context,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // Upcoming section
                if (upcoming.isNotEmpty) ...[
                  _SectionHeader(
                    label: 'PRÓXIMAS',
                    color: DesignTokens.onSurfaceVariant,
                    count: upcoming.length,
                  ),
                  const SizedBox(height: 8),
                  ...upcoming.map(
                    (task) => _TaskCard(
                      task: task,
                      isOverdue: false,
                      ref: ref,
                      context: context,
                    ),
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _SummaryCard({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            '$count',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: DesignTokens.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  final int count;

  const _SectionHeader({
    required this.label,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '($count)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: DesignTokens.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final dynamic task;
  final bool isOverdue;
  final WidgetRef ref;
  final BuildContext context;

  const _TaskCard({
    required this.task,
    required this.isOverdue,
    required this.ref,
    required this.context,
  });

  @override
  Widget build(BuildContext outerContext) {
    final theme = Theme.of(outerContext);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isOverdue
            ? DesignTokens.error.withValues(alpha: 0.08)
            : DesignTokens.surfaceContainerLow,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: isOverdue
              ? DesignTokens.error.withValues(alpha: 0.3)
              : DesignTokens.outlineVariant.withValues(alpha: 0.12),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: GestureDetector(
          onTap: () async {
            await ref.read(taskRepositoryProvider).toggleComplete(task.id);
            ref.invalidate(pendingTasksProvider);
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isOverdue
                    ? DesignTokens.error
                    : DesignTokens.primaryContainer,
                width: 2,
              ),
            ),
            child: const SizedBox.shrink(),
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.clientName != null)
              Text(
                task.clientName!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: DesignTokens.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (task.dueDate != null)
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 13,
                    color: isOverdue
                        ? DesignTokens.error
                        : DesignTokens.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.dueDate(
                      '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                    ),
                    style: TextStyle(
                      color: isOverdue
                          ? DesignTokens.error
                          : DesignTokens.onSurfaceVariant,
                      fontWeight: isOverdue ? FontWeight.w700 : null,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: isOverdue
            ? const Icon(
                Icons.warning_rounded,
                color: DesignTokens.error,
                size: 18,
              )
            : null,
        onTap: () => outerContext.push('/client/${task.clientId}'),
      ),
    );
  }
}
