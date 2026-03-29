---
description: "Use when working on client detail, client info editing, notes, note list, adding notes, or the client detail screen with tabs."
applyTo: "**/client_detail/**,**/widgets/client/**"
---
# Feature: Client Detail

## Current State (v1 - MVP)
- Full-screen route `/client/:id` (outside ShellRoute, no bottom nav)
- `DefaultTabController` with 3 tabs: Info / Notas / Tareas
- Each tab is a separate widget

## Architecture
```
presentation/screens/client_detail/client_detail_screen.dart  # FutureProvider.family, TabBar
presentation/widgets/client/client_info_tab.dart               # Editable form (toggle edit mode)
presentation/widgets/client/note_list_tab.dart                 # Notes list + add note bottom sheet
presentation/widgets/client/task_list_tab.dart                 # Tasks list + add task bottom sheet
presentation/providers/note_provider.dart                      # FamilyAsyncNotifier keyed by clientId
presentation/providers/task_provider.dart                      # FamilyAsyncNotifier keyed by clientId
```

## Key Patterns
- Client loaded via `FutureProvider.family<Client, String>` fetching by ID
- **Info tab**: Read-only by default, edit icon toggles to form mode, save updates via `clientRepositoryProvider`
- **Notes tab**: `Dismissible` swipe-to-delete (soft delete), FAB opens bottom sheet for new note
- **Tasks tab**: Checkbox to toggle `completed`, `Dismissible` delete, FAB opens bottom sheet with title + date picker
- Notes/Tasks providers are `FamilyAsyncNotifier` — keyed by `clientId` for independent state per client

## Note Provider
- `notesProvider(clientId)` — loads notes for one client
- Methods: `addNote(content)`, `deleteNote(noteId)` (soft delete)

## Task Provider
- `clientTasksProvider(clientId)` — loads tasks for one client
- Methods: `addTask(title, dueDate?)`, `toggleTask(taskId, completed)`, `deleteTask(taskId)`
- Also: `pendingTasksProvider` (global) — all pending tasks across clients, used in Tasks screen
