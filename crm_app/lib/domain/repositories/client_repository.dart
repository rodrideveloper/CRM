import '../entities/client.dart';

abstract class ClientRepository {
  Future<List<Client>> getClients({int offset = 0, int limit = 50});
  Future<List<Client>> getClientsByStatus(ClientStatus status);
  Future<List<Client>> searchClients(String query);
  Future<Client> getClient(String id);
  Future<Client> createClient({
    required String name,
    String? phone,
    String? email,
    String? company,
    String? source,
  });
  Future<Client> updateClient(
    String id, {
    String? name,
    String? phone,
    String? email,
    String? company,
    String? source,
    ClientStatus? status,
    DateTime? nextFollowUp,
    bool clearFollowUp = false,
  });
  Future<void> softDeleteClient(String id);
  Future<void> restoreClient(String id);
}
