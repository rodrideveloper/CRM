import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/client.dart';
import 'repository_providers.dart';

enum ClientSortOrder { recent, name, oldest }

final clientSortOrderProvider = StateProvider<ClientSortOrder>(
  (ref) => ClientSortOrder.recent,
);

// ── Filters ────────────────────────────────────────────────
final dateRangeFilterProvider = StateProvider<DateTimeRange?>((ref) => null);
final sourceFilterProvider = StateProvider<String?>((ref) => null);

final clientsProvider = AsyncNotifierProvider<ClientsNotifier, List<Client>>(
  ClientsNotifier.new,
);

class ClientsNotifier extends AsyncNotifier<List<Client>> {
  @override
  Future<List<Client>> build() async {
    return ref.read(clientRepositoryProvider).getClients();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(clientRepositoryProvider).getClients(),
    );
  }

  Future<void> createClient({
    required String name,
    String? phone,
    String? email,
    String? company,
    String? source,
  }) async {
    await ref
        .read(clientRepositoryProvider)
        .createClient(
          name: name,
          phone: phone,
          email: email,
          company: company,
          source: source,
        );
    await refresh();
  }

  Future<void> updateClientStatus(String id, ClientStatus status) async {
    // Optimistic update
    state = state.whenData((clients) {
      return clients
          .map((c) => c.id == id ? c.copyWith(status: status) : c)
          .toList();
    });
    try {
      await ref.read(clientRepositoryProvider).updateClient(id, status: status);
    } catch (e) {
      // Revert on failure
      await refresh();
      rethrow;
    }
  }

  Future<void> softDeleteClient(String id) async {
    await ref.read(clientRepositoryProvider).softDeleteClient(id);
    await refresh();
  }

  Future<void> restoreClient(String id) async {
    await ref.read(clientRepositoryProvider).restoreClient(id);
    await refresh();
  }
}

// Groups clients by status for pipeline view (with filters applied)
final pipelineProvider = Provider<AsyncValue<Map<ClientStatus, List<Client>>>>((
  ref,
) {
  final sortOrder = ref.watch(clientSortOrderProvider);
  final dateRange = ref.watch(dateRangeFilterProvider);
  final sourceFilter = ref.watch(sourceFilterProvider);

  return ref.watch(clientsProvider).whenData((clients) {
    // Apply filters
    var filtered = clients;

    if (dateRange != null) {
      filtered = filtered.where((c) {
        return !c.createdAt.isBefore(dateRange.start) &&
            c.createdAt.isBefore(dateRange.end.add(const Duration(days: 1)));
      }).toList();
    }

    if (sourceFilter != null && sourceFilter.isNotEmpty) {
      filtered = filtered.where((c) {
        return c.source?.toLowerCase() == sourceFilter.toLowerCase();
      }).toList();
    }

    final map = <ClientStatus, List<Client>>{};
    for (final status in ClientStatus.values) {
      final byStatus = filtered.where((c) => c.status == status).toList();
      switch (sortOrder) {
        case ClientSortOrder.recent:
          byStatus.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        case ClientSortOrder.oldest:
          byStatus.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        case ClientSortOrder.name:
          byStatus.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
      }
      map[status] = byStatus;
    }
    return map;
  });
});

// All unique sources from clients (for filter chips)
final availableSourcesProvider = Provider<List<String>>((ref) {
  final clients = ref.watch(clientsProvider);
  return clients.whenOrNull(
        data: (list) {
          final sources = list
              .map((c) => c.source)
              .where((s) => s != null && s.isNotEmpty)
              .cast<String>()
              .toSet()
              .toList();
          sources.sort();
          return sources;
        },
      ) ??
      [];
});

// Whether any filter is active
final hasActiveFiltersProvider = Provider<bool>((ref) {
  return ref.watch(dateRangeFilterProvider) != null ||
      ref.watch(sourceFilterProvider) != null;
});

// Search
final clientSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredClientsProvider = FutureProvider<List<Client>>((ref) async {
  final query = ref.watch(clientSearchQueryProvider);
  if (query.isEmpty) return [];
  return ref.read(clientRepositoryProvider).searchClients(query);
});

// Count of new leads from the public form
final newLeadsCountProvider = Provider<int>((ref) {
  final clients = ref.watch(clientsProvider);
  return clients.whenOrNull(
        data: (list) => list
            .where(
              (c) =>
                  c.source?.toLowerCase() == 'formulario' &&
                  c.status == ClientStatus.newClient,
            )
            .length,
      ) ??
      0;
});
