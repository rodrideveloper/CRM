import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/client.dart';
import 'client_provider.dart';
import 'task_provider.dart';

class PipelineMetrics {
  final int totalActive;
  final Map<ClientStatus, int> byStatus;
  final double conversionRate;
  final int newThisWeek;
  final int newThisMonth;
  final int overdueTasks;

  const PipelineMetrics({
    required this.totalActive,
    required this.byStatus,
    required this.conversionRate,
    required this.newThisWeek,
    required this.newThisMonth,
    required this.overdueTasks,
  });
}

final metricsProvider = Provider<AsyncValue<PipelineMetrics>>((ref) {
  final clientsAsync = ref.watch(clientsProvider);
  final tasksAsync = ref.watch(pendingTasksProvider);

  return clientsAsync.whenData((clients) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthStart = DateTime(now.year, now.month, 1);

    final byStatus = <ClientStatus, int>{};
    for (final status in ClientStatus.values) {
      byStatus[status] = clients.where((c) => c.status == status).length;
    }

    final totalActive = clients.length;
    final closedWon = byStatus[ClientStatus.closedWon] ?? 0;
    final closedLost = byStatus[ClientStatus.closedLost] ?? 0;
    final totalClosed = closedWon + closedLost;
    final conversionRate = totalClosed > 0 ? closedWon / totalClosed : 0.0;

    final newThisWeek = clients
        .where((c) => c.createdAt.isAfter(weekAgo))
        .length;
    final newThisMonth = clients
        .where((c) => c.createdAt.isAfter(monthStart))
        .length;

    final overdueTasks =
        tasksAsync.whenOrNull(
          data: (tasks) {
            return tasks.where((t) {
              return t.dueDate != null &&
                  t.dueDate!.isBefore(now) &&
                  !t.completed;
            }).length;
          },
        ) ??
        0;

    return PipelineMetrics(
      totalActive: totalActive,
      byStatus: byStatus,
      conversionRate: conversionRate,
      newThisWeek: newThisWeek,
      newThisMonth: newThisMonth,
      overdueTasks: overdueTasks,
    );
  });
});
