import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/client.dart';
import 'repository_providers.dart';

enum ClientSortOrder { recent, name, oldest }

final clientSortOrderProvider = StateProvider<ClientSortOrder>(
  (ref) => ClientSortOrder.recent,
);

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

// Groups clients by status for pipeline view
final pipelineProvider = Provider<AsyncValue<Map<ClientStatus, List<Client>>>>((
  ref,
) {
  final sortOrder = ref.watch(clientSortOrderProvider);
  return ref.watch(clientsProvider).whenData((clients) {
    final map = <ClientStatus, List<Client>>{};
    for (final status in ClientStatus.values) {
      final filtered = clients.where((c) => c.status == status).toList();
      switch (sortOrder) {
        case ClientSortOrder.recent:
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        case ClientSortOrder.oldest:
          filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        case ClientSortOrder.name:
          filtered.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
      }
      map[status] = filtered;
    }
    return map;
  });
});

// Search
final clientSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredClientsProvider = FutureProvider<List<Client>>((ref) async {
  final query = ref.watch(clientSearchQueryProvider);
  if (query.isEmpty) return [];
  return ref.read(clientRepositoryProvider).searchClients(query);
});
