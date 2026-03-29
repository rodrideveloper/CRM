import '../entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotesByClient(String clientId);
  Future<Note> createNote({required String clientId, required String content});
  Future<Note> updateNote(String id, {required String content});
  Future<void> softDeleteNote(String id);
}
