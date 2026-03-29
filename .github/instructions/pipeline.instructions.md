---
description: "Use when working on the pipeline, kanban board, client status columns, PageView, client cards, status changes, or the main pipeline screen."
applyTo: "**/pipeline/**"
---
# Feature: Pipeline (Kanban Board)

## Current State (v1 - MVP)
- Horizontal PageView kanban with 6 status columns
- Mobile-first: swipe between columns, no drag-and-drop
- Client creation via bottom sheet (FAB)
- Status change via bottom sheet (long press on card)
- Search via DraggableScrollableSheet

## Architecture
```
presentation/screens/pipeline/pipeline_screen.dart    # Main screen with PageView + ChoiceChip tabs
presentation/widgets/pipeline/pipeline_column.dart     # Column header (status label + count) + ListView of cards
presentation/widgets/pipeline/client_card.dart         # Card with avatar, name, phone, WhatsApp button
presentation/providers/client_provider.dart            # clientsProvider, pipelineProvider, search providers
```

## Key Patterns
- `pipelineProvider` = `Provider<AsyncValue<Map<ClientStatus, List<Client>>>>` grouping clients by status
- `PageController(viewportFraction: 0.85)` — shows adjacent columns as peek
- `ChoiceChip` row synced with PageView via `_onPageChanged` / `_onChipSelected`
- Client creation: bottom sheet with name (required) + phone (optional)
- Status change: `showModalBottomSheet` listing all statuses, calls `updateClientStatus` (optimistic)
- WhatsApp: `url_launcher` opens `https://wa.me/{phone}` (removes non-digits)
- Navigation: tap card → `context.push('/client/${client.id}')`

## Pipeline Stages
| Enum Value    | Spanish Label | Color (from theme) |
|---------------|---------------|-------------------|
| new           | Nuevo         | auto              |
| contacted     | Contactado    | auto              |
| interested    | Interesado    | auto              |
| negotiating   | Negociando    | auto              |
| closed_won    | Ganado        | auto              |
| closed_lost   | Perdido       | auto              |

## Optimistic Updates
`updateClientStatus` in `ClientsNotifier`:
1. Immediately update local state via `state.whenData()`
2. Call Supabase `updateClient(id, status: status)`
3. On failure: `refresh()` to revert + `rethrow`
