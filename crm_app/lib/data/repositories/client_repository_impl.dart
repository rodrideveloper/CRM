import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final SupabaseClient _client;

  ClientRepositoryImpl(this._client);

  String get _userId => _client.auth.currentUser!.id;

  @override
  Future<List<Client>> getClients({int offset = 0, int limit = 50}) async {
    final data = await _client
        .from('clients')
        .select()
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
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
        .or(
          'name.ilike.%$query%,phone.ilike.%$query%,email.ilike.%$query%,company.ilike.%$query%',
        )
        .order('name');
    return data.map((json) => ClientModel.fromJson(json)).toList();
  }

  @override
  Future<Client> getClient(String id) async {
    final data = await _client.from('clients').select().eq('id', id).single();
    return ClientModel.fromJson(data);
  }

  @override
  Future<Client> createClient({
    required String name,
    String? phone,
    String? email,
    String? company,
    String? source,
  }) async {
    final data = await _client
        .from('clients')
        .insert(
          ClientModel.toInsertJson(
            userId: _userId,
            name: name,
            phone: phone,
            email: email,
            company: company,
            source: source,
          ),
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
    String? email,
    String? company,
    String? source,
    ClientStatus? status,
    DateTime? nextFollowUp,
    bool clearFollowUp = false,
  }) async {
    final updates = ClientModel.toUpdateJson(
      name: name,
      phone: phone,
      email: email,
      company: company,
      source: source,
      status: status,
      nextFollowUp: nextFollowUp,
      clearFollowUp: clearFollowUp,
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

  @override
  Future<void> restoreClient(String id) async {
    await _client.rpc('restore_client', params: {'p_client_id': id});
  }
}
