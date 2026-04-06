# TRATAR CRM - Project Context

## Overview
CRM MVP for small businesses in Argentina. Manage clients through a WhatsApp sales pipeline, register notes, and create follow-up tasks. The UI language is **Spanish (Argentina)**. Brand name: **TRATAR** (trat.ar).

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
- **Tables**: clients, notes, tasks, user_profiles (all with UUID PKs, soft delete via `deleted_at` where applicable)
- **RLS**: Multi-tenant isolation — users only see their own data
- **Trigger**: Auto-update `updated_at` on row change; auto-create `user_profiles` on signup; `check_client_limit()` BEFORE INSERT on clients enforces free plan limit
- **RPC**: `submit_lead(form_token, name, phone)` — SECURITY DEFINER, creates clients from public forms; `get_user_limits()` — returns plan info and client count/limit

## Freemium Model
- **Free plan**: Up to 15 active clients, basic pipeline, notes, tasks
- **Pro plan** ($3.999/mes ARS): Unlimited clients, all features, priority support
- **Enforcement**: DB trigger `check_client_limit()` is the real gatekeeper (BEFORE INSERT ON clients). UI pre-checks via `userLimitsProvider` for UX.
- **Paywall**: `paywall_bottom_sheet.dart` — reusable bottom sheet with Free vs Pro comparison, Mercado Pago link
- **Plan storage**: `user_profiles.plan` (TEXT, default 'free') + `plan_expires_at` (TIMESTAMPTZ)
- **Domain**: `UserLimits` class with `canCreateClient`, `remaining`, `isUnlimited`
- **Pipeline counter**: Shows "12/15" (count/limit) in stats header, color-coded (warning near limit, error at limit)
- **Profile**: "Mi Plan" card with usage bar and upgrade button

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
