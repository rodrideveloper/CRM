import '../entities/client.dart';

abstract class ClientRepository {
  Future<List<Client>> getClients();
  Future<List<Client>> getClientsByStatus(ClientStatus status);
  Future<List<Client>> searchClients(String query);
  Future<Client> getClient(String id);
  Future<Client> createClient({required String name, String? phone});
  Future<Client> updateClient(
    String id, {
    String? name,
    String? phone,
    ClientStatus? status,
  });
  Future<void> softDeleteClient(String id);
}
