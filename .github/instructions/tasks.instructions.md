---
description: "Use when working on the tasks screen, pending tasks, overdue tasks, task completion, or global task management."
applyTo: "**/tasks/**,**/task_provider.dart"
---
# Feature: Tasks Screen

## Current State (v1 - MVP)
- Global pending tasks view (tab 2 in BottomNavigationBar)
- Shows all incomplete tasks across all clients
- Overdue indicator (red color) for past-due tasks
- Pull-to-refresh

## Architecture
```
presentation/screens/tasks/tasks_screen.dart      # RefreshIndicator + ListView of pending tasks
presentation/providers/task_provider.dart          # pendingTasksProvider (global), clientTasksProvider (per-client)
domain/entities/task.dart                          # Task entity with isOverdue getter
data/repositories/task_repository_impl.dart        # getPendingTasks joins with clients table
```

## Key Patterns
- `pendingTasksProvider` = `FutureProvider<List<Task>>` calling `getPendingTasks()`
- `getPendingTasks()` in repo: queries tasks where `completed = false AND deleted_at IS NULL`, joins clients to filter by `auth.uid()`
- `Task.isOverdue` = `!completed && dueDate != null && dueDate.isBefore(now)`
- Overdue shown with `_CrmColors.overdue` from theme extension
- Tap task → navigates to client detail
- Checkbox toggles completion inline
- `RefreshIndicator` calls `ref.refresh(pendingTasksProvider)`

## RLS Note
Tasks RLS uses EXISTS subquery on clients table to verify ownership. The `getPendingTasks` query in the repo also does an inner join with clients for the client name display.
