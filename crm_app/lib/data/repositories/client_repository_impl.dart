import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final SupabaseClient _client;

  ClientRepositoryImpl(this._client);

  String get _userId => _client.auth.currentUser!.id;

  @override
  Future<List<Client>> getClients() async {
    final data = await _client
        .from('clients')
        .select()
        .order('created_at', ascending: false);
    return data.map((json) => ClientModel.fromJson(json)).toList();
  }

  @override
  Future<List<Client>> getClientsByStatus(ClientStatus status) async {
    final data = await _client
        .from('clients')
        .select()
        .eq('status', status.value)
        .order('updated_at', ascending: false);
    return data.map((json) => ClientModel.fromJson(json)).toList();
  }

  @override
  Future<List<Client>> searchClients(String query) async {
    final data = await _client
        .from('clients')
        .select()
        .ilike('name', '%$query%')
        .order('name');
    return data.map((json) => ClientModel.fromJson(json)).toList();
  }

  @override
  Future<Client> getClient(String id) async {
    final data = await _client.from('clients').select().eq('id', id).single();
    return ClientModel.fromJson(data);
  }

  @override
  Future<Client> createClient({required String name, String? phone}) async {
    final data = await _client
        .from('clients')
        .insert(
          ClientModel.toInsertJson(userId: _userId, name: name, phone: phone),
        )
        .select()
        .single();
    return ClientModel.fromJson(data);
  }

  @override
  Future<Client> updateClient(
    String id, {
    String? name,
    String? phone,
    ClientStatus? status,
  }) async {
    final updates = ClientModel.toUpdateJson(
      name: name,
      phone: phone,
      status: status,
    );
    if (updates.isEmpty) return getClient(id);
    final data = await _client
        .from('clients')
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return ClientModel.fromJson(data);
  }

  @override
  Future<void> softDeleteClient(String id) async {
    await _client
        .from('clients')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
