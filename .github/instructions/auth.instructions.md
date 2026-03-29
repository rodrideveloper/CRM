---
description: "Use when working on authentication, login, register, sign out, auth guards, auth state, or Supabase Auth. Covers auth flow, providers, and screens."
applyTo: "**/auth/**,**/auth_provider.dart"
---
# Feature: Authentication

## Current State (v1 - MVP)
- Email/password auth via Supabase Auth
- Confirm email **disabled** in Supabase dashboard for dev
- Two screens: `LoginScreen`, `RegisterScreen` (both `ConsumerStatefulWidget`)

## Architecture
```
domain/repositories/auth_repository.dart       # Abstract: signIn, signUp, signOut, currentUser, authStateChanges
data/repositories/auth_repository_impl.dart    # Supabase implementation
presentation/providers/auth_provider.dart      # authStateProvider (Stream), authNotifierProvider (AsyncNotifier)
presentation/screens/auth/login_screen.dart    # Email + password form
presentation/screens/auth/register_screen.dart # Email + password form + navigate to login
```

## Key Patterns
- `authStateProvider` = `StreamProvider<User?>` watching `onAuthStateChange`
- `authNotifierProvider` = `AsyncNotifier<void>` with `signIn()`, `signUp()`, `signOut()`
- `GoRouter.redirect` checks `authStateProvider` — unauthenticated → /login, authenticated → /pipeline
- Forms use `GlobalKey<FormState>` with validation
- Error shown via `SnackBar` on `state.hasError`

## Supabase Auth Config
- Provider: Email (no OAuth yet)
- Confirm email: **disabled**
- Session persisted automatically by `supabase_flutter`

## Navigation
- `/login` → `/register` (TextButton link)
- `/register` → `/login` (TextButton link)
- Post-auth redirect → `/pipeline` (automatic via GoRouter)
