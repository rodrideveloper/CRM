---
description: "Use when working on subscription plans, paywall, freemium limits, plan upgrades, Mercado Pago integration, or the Mi Plan section."
applyTo: "**/paywall_bottom_sheet.dart,**/user_profile*,**/subscription*"
---
# Feature: Freemium Subscription Plans

## Plans
| Plan | Price | Client Limit | Features |
|------|-------|-------------|----------|
| Free | $0 | 15 active clients | Pipeline, notes, tasks, WhatsApp, lead form |
| Pro | $3.999/mes ARS | Unlimited | Everything in Free + CSV export, priority support |

## Database (migration 007)
- `user_profiles.plan` — TEXT, default `'free'`
- `user_profiles.plan_expires_at` — TIMESTAMPTZ, nullable
- **Trigger** `check_client_limit()` — BEFORE INSERT ON clients. Counts active (non-deleted) clients for user. If free plan and count ≥ 15, raises exception `LIMIT_REACHED`.
- **RPC** `get_user_limits()` — Returns JSON: `{ plan, plan_expires_at, client_count, client_limit }`. `client_limit` is -1 for pro (unlimited).

## Domain Layer
- `UserProfile` entity: `plan` (String), `planExpiresAt` (DateTime?), `isPro`/`isFree` getters
- `UserLimits` class: `plan`, `planExpiresAt`, `clientCount`, `clientLimit`, computed `canCreateClient`, `remaining`, `isUnlimited`
- `UserLimitsModel.fromJson()` in data layer

## Provider Layer
- `userLimitsProvider = FutureProvider<UserLimits>` — calls `getUserLimits()` RPC
- `ClientsNotifier.createClient()` pre-checks limits, throws `ClientLimitReachedException`
- After create, invalidates `userLimitsProvider` to refresh counter

## UI Components
- **`paywall_bottom_sheet.dart`** — Reusable bottom sheet: Free vs Pro comparison cards, price, Mercado Pago CTA button
  - Called via `showPaywallBottomSheet(context, limits: limits)`
- **Pipeline stats header** — Shows `count/limit` with color coding (warning near limit, error at limit)
- **Pipeline FAB** — Checks `userLimitsProvider` before creating, shows paywall if at limit
- **Profile `_PlanCard`** — Shows current plan, usage bar (free), upgrade button

## Payment
- Payment link: Mercado Pago (configured externally)
- Plan activation: Manual for now (update `user_profiles.plan` in Supabase dashboard)
- Future: webhook to auto-activate on payment confirmation

## Key Decisions
- DB trigger is the **real gatekeeper** — UI pre-check is just for UX
- Soft-deleted clients don't count toward limit
- Free plan limit: 15 (configurable in trigger)
