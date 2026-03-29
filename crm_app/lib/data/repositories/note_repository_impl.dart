import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final SupabaseClient _client;

  NoteRepositoryImpl(this._client);

  @override
  Future<List<Note>> getNotesByClient(String clientId) async {
    final data = await _client
        .from('notes')
        .select()
        .eq('client_id', clientId)
        .order('created_at', ascending: false);
    return data.map((json) => NoteModel.fromJson(json)).toList();
  }

  @override
  Future<Note> createNote({
    required String clientId,
    required String content,
  }) async {
    final data = await _client
        .from('notes')
        .insert(NoteModel.toInsertJson(clientId: clientId, content: content))
        .select()
        .single();
    return NoteModel.fromJson(data);
  }

  @override
  Future<Note> updateNote(String id, {required String content}) async {
    final data = await _client
        .from('notes')
        .update({'content': content})
        .eq('id', id)
        .select()
        .single();
    return NoteModel.fromJson(data);
  }

  @override
  Future<void> softDeleteNote(String id) async {
    await _client
        .from('notes')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }

  @override
  Future<void> restoreNote(String id) async {
    await _client.rpc('restore_note', params: {'p_note_id': id});
  }
}
