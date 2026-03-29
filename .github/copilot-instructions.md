# CRM WhatsApp Sales - Project Context

## Overview
CRM MVP for small businesses in Argentina. Manage clients through a WhatsApp sales pipeline, register notes, and create follow-up tasks. The UI language is **Spanish (Argentina)**.

## Stack
- **Frontend**: Flutter 3.35.6 (via FVM), Dart 3.9.2
- **Backend**: Supabase (PostgreSQL + Auth + RLS)
- **State management**: Riverpod 2.6 (AsyncNotifier pattern)
- **Navigation**: go_router 14.8 with auth guards
- **Architecture**: Clean Architecture (domain → data → presentation)

## Project Structure
```
crm/
├── supabase/migrations/001_initial_schema.sql   # DB schema, triggers, RLS
└── crm_app/                                      # Flutter project root
    └── lib/
        ├── core/
        │   ├── constants/supabase_constants.dart  # --dart-define vars
        │   ├── router/app_router.dart             # GoRouter + auth redirect
        │   └── theme/app_theme.dart               # Material 3, WhatsApp green #25D366
        ├── domain/
        │   ├── entities/                          # Client, Note, Task (immutable, copyWith)
        │   └── repositories/                      # Abstract interfaces
        ├── data/
        │   ├── models/                            # DTOs with fromJson/toJson
        │   └── repositories/                      # Supabase implementations
        └── presentation/
            ├── providers/                         # Riverpod providers
            ├── screens/                           # auth/, pipeline/, client_detail/, tasks/, profile/
            └── widgets/                           # pipeline/, client/
```

## Database
- **Enum**: `client_status` → new, contacted, interested, negotiating, closed_won, closed_lost
- **Tables**: clients, notes, tasks (all with UUID PKs, soft delete via `deleted_at`)
- **RLS**: Multi-tenant isolation — users only see their own data
- **Trigger**: Auto-update `updated_at` on row change

## Key Design Decisions
- **Mobile-first**: PageView horizontal kanban (viewportFraction: 0.85), no drag-and-drop
- **Navigation**: BottomNavigationBar with 3 tabs (Pipeline / Tareas / Perfil)
- **WhatsApp integration**: Deep link via `wa.me/{phone}` on client cards and detail
- **Soft delete**: All entities use `deleted_at` timestamp, never hard delete
- **Optimistic updates**: Client status changes update UI immediately, revert on failure
- **Auth flow**: GoRouter redirect — unauthenticated → /login, authenticated → /pipeline

## Conventions
- Entities are immutable with `copyWith`
- Models (DTOs) have `fromJson` factory + `toInsertJson`/`toUpdateJson` static methods
- Providers: one file per domain concept, `AsyncNotifier` for mutations, `Provider` for derived state
- Spanish labels everywhere in UI. Enum labels in `ClientStatus.label`
- Bottom sheets for creation forms and status changes (not full-screen dialogs)

## Run Commands
```bash
cd crm_app

# Run on device
flutter run -d <device_id> \
  --dart-define=SUPABASE_URL=https://xxssynpydlfhjwkcipca.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<key>

# Analyze
dart analyze lib/
```

## Supabase
- **Project ref**: xxssynpydlfhjwkcipca
- **URL**: https://xxssynpydlfhjwkcipca.supabase.co
- **Auth**: Email/password, confirm email disabled for dev
