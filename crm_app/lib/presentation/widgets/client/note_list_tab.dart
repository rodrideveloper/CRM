import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../providers/note_provider.dart';

class NoteListTab extends ConsumerWidget {
  final String clientId;
  const NoteListTab({super.key, required this.clientId});

  void _showNoteDialog(
    BuildContext context,
    WidgetRef ref, {
    String? noteId,
    String? initialContent,
  }) {
    final controller = TextEditingController(text: initialContent ?? '');
    final isEditing = noteId != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryContainer.withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                  child: Icon(
                    isEditing
                        ? Icons.edit_note_rounded
                        : Icons.note_add_rounded,
                    color: DesignTokens.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isEditing ? 'Editar nota' : 'Nueva nota',
                  style: Theme.of(
                    ctx,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: context.l10n.noteHint),
              maxLines: 4,
              textInputAction: TextInputAction.done,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: DesignTokens.primaryGradient,
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;
                  Navigator.pop(ctx);
                  if (isEditing) {
                    ref
                        .read(notesProvider(clientId).notifier)
                        .updateNote(noteId, controller.text.trim());
                  } else {
                    ref
                        .read(notesProvider(clientId).notifier)
                        .addNote(controller.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  isEditing ? context.l10n.saveChanges : context.l10n.saveNote,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider(clientId));
    final theme = Theme.of(context);

    return Scaffold(
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 48,
                    color: DesignTokens.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.noNotes,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.noNotesHint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: DesignTokens.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Dismissible(
                key: ValueKey(note.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: DesignTokens.error,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref
                      .read(notesProvider(clientId).notifier)
                      .deleteNote(note.id);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.noteDeleted),
                        action: SnackBarAction(
                          label: context.l10n.undo,
                          onPressed: () {
                            ref
                                .read(notesProvider(clientId).notifier)
                                .restoreNote(note.id);
                          },
                        ),
                      ),
                    );
                },
                child: GestureDetector(
                  onTap: () => _showNoteDialog(
                    context,
                    ref,
                    noteId: note.id,
                    initialContent: note.content,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: DesignTokens.surfaceContainer,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      border: Border(
                        left: BorderSide(
                          color: DesignTokens.primaryContainer,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.content, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 13,
                              color: DesignTokens.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: DesignTokens.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'addNote',
        onPressed: () => _showNoteDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
