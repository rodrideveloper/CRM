import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note.dart';
import 'repository_providers.dart';

final notesProvider =
    AsyncNotifierProvider.family<NotesNotifier, List<Note>, String>(
      NotesNotifier.new,
    );

class NotesNotifier extends FamilyAsyncNotifier<List<Note>, String> {
  @override
  Future<List<Note>> build(String arg) async {
    return ref.read(noteRepositoryProvider).getNotesByClient(arg);
  }

  Future<void> addNote(String content) async {
    await ref
        .read(noteRepositoryProvider)
        .createNote(clientId: arg, content: content);
    ref.invalidateSelf();
  }

  Future<void> updateNote(String noteId, String content) async {
    await ref.read(noteRepositoryProvider).updateNote(noteId, content: content);
    ref.invalidateSelf();
  }

  Future<void> deleteNote(String noteId) async {
    await ref.read(noteRepositoryProvider).softDeleteNote(noteId);
    ref.invalidateSelf();
  }

  Future<void> restoreNote(String noteId) async {
    await ref.read(noteRepositoryProvider).restoreNote(noteId);
    ref.invalidateSelf();
  }
}
