# CRM WhatsApp Sales — Plan de Implementación por Sprints

> **Última actualización:** 29 de marzo de 2026  
> **Estado actual:** Sprint 2 completado + Landing page + Design system + Marketing funnel  
> **Objetivo:** Salir a producción con algo básico, confiable, usable y que sume valor.

---

## Índice

1. [Sprint 1 — MVP Base (COMPLETADO)](#sprint-1--mvp-base-completado)
2. [Sprint 2 — Producción Mínima Viable (COMPLETADO)](#sprint-2--producción-mínima-viable-completado)
3. [Sprint 3 — Experiencia de Usuario](#sprint-3--experiencia-de-usuario)
4. [Sprint 4 — Búsqueda, Filtros y Métricas](#sprint-4--búsqueda-filtros-y-métricas)
5. [Sprint 5 — Notificaciones y Recordatorios](#sprint-5--notificaciones-y-recordatorios)
6. [Sprint 6 — Revenue y Monetización](#sprint-6--revenue-y-monetización)
7. [Sprint 7 — Captación de Leads (Formulario Público)](#sprint-7--captación-de-leads-formulario-público)
8. [Backlog Futuro](#backlog-futuro)
9. [Estrategia de Migraciones DB](#estrategia-de-migraciones-db)
10. [Inventario Actual del Código](#inventario-actual-del-código)

---

## Sprint 1 — MVP Base (COMPLETADO) ✅

### Resumen
Base funcional completa: auth, pipeline kanban, detalle de cliente, notas, tareas, perfil.

### Lo que se entregó

| # | Feature | Estado |
|---|---------|--------|
| 1.1 | Auth email/password (login + registro) | ✅ |
| 1.2 | Pipeline kanban horizontal (PageView, 6 columnas) | ✅ |
| 1.3 | Crear cliente (nombre + teléfono) | ✅ |
| 1.4 | Cambiar estado del cliente (long-press → bottom sheet) | ✅ |
| 1.5 | Detalle de cliente (3 tabs: Info / Notas / Tareas) | ✅ |
| 1.6 | CRUD de notas por cliente | ✅ |
| 1.7 | CRUD de tareas por cliente (con fecha opcional) | ✅ |
| 1.8 | Pantalla global de tareas pendientes | ✅ |
| 1.9 | Deep link WhatsApp (wa.me/{phone}) | ✅ |
| 1.10 | Soft delete en todas las entidades | ✅ |
| 1.11 | RLS multi-tenant (cada usuario ve solo sus datos) | ✅ |
| 1.12 | Optimistic updates en cambio de estado | ✅ |
| 1.13 | Perfil con logout | ✅ |
| 1.14 | Material 3 + WhatsApp green (#25D366) | ✅ |

### Arquitectura entregada
```
crm_app/lib/
├── core/
│   ├── constants/supabase_constants.dart    # --dart-define vars
│   ├── router/app_router.dart               # GoRouter + auth redirect
│   └── theme/app_theme.dart                 # Material 3 theme
├── domain/
│   ├── entities/                            # Client, Note, Task (immutable)
│   └── repositories/                        # Interfaces abstractas
├── data/
│   ├── models/                              # DTOs (fromJson/toInsertJson)
│   └── repositories/                        # Implementaciones Supabase
└── presentation/
    ├── providers/                           # Riverpod (AsyncNotifier)
    ├── screens/                             # 7 pantallas
    └── widgets/                             # pipeline/ + client/
```

### DB Schema actual (001_initial_schema.sql)
```sql
-- Enum
client_status: new | contacted | interested | negotiating | closed_won | closed_lost

-- Tables
clients:  id, user_id, name, phone, status, created_at, updated_at, deleted_at
notes:    id, client_id, content, created_at, updated_at, deleted_at
tasks:    id, client_id, title, due_date, completed, created_at, updated_at, deleted_at
```

---

## Sprint 2 — Producción Mínima Viable (COMPLETADO) ✅

> **Prioridad:** BLOQUEANTE para producción  
> **Objetivo:** Completar los campos mínimos de cliente, robustez, y polish visual.

### 2.1 — Campos adicionales en Cliente

**¿Por qué?** Un CRM sin email ni empresa no es útil para ventas reales.

#### 2.1.1 Migración DB: `002_add_client_fields.sql`
```sql
ALTER TABLE clients ADD COLUMN email   TEXT;
ALTER TABLE clients ADD COLUMN company TEXT;
ALTER TABLE clients ADD COLUMN source  TEXT;  -- 'whatsapp', 'referido', 'web', 'otro'
```

**Archivos a modificar:**

| # | Archivo | Cambio |
|---|---------|--------|
| A | `supabase/migrations/002_add_client_fields.sql` | CREAR — migración SQL |
| B | `domain/entities/client.dart` | Agregar campos: `email`, `company`, `source` |
| C | `data/models/client_model.dart` | Actualizar `fromJson`, `toInsertJson`, `toUpdateJson` |
| D | `domain/repositories/client_repository.dart` | Agregar params opcionales a `createClient` y `updateClient` |
| E | `data/repositories/client_repository_impl.dart` | Pasar nuevos campos en insert/update |
| F | `presentation/providers/client_provider.dart` | Actualizar `createClient()` con nuevos params |
| G | `presentation/screens/pipeline/pipeline_screen.dart` | Agregar campos al bottom sheet de creación |
| H | `presentation/widgets/client/client_info_tab.dart` | Mostrar/editar email, empresa, origen |
| I | `presentation/widgets/pipeline/client_card.dart` | Mostrar empresa debajo del nombre |

**Detalle de cambios por archivo:**

**B. `domain/entities/client.dart`**
```dart
// AGREGAR a la clase Client:
final String? email;
final String? company;
final String? source;

// ACTUALIZAR copyWith con estos 3 campos
```

**C. `data/models/client_model.dart`**
```dart
// fromJson — agregar:
email: json['email'],
company: json['company'],
source: json['source'],

// toInsertJson — agregar params opcionales:
if (email != null) 'email': email,
if (company != null) 'company': company,
if (source != null) 'source': source,

// toUpdateJson — agregar params opcionales:
if (email != null) 'email': email,
if (company != null) 'company': company,
if (source != null) 'source': source,
```

**D. `domain/repositories/client_repository.dart`**
```dart
// createClient — agregar:
Future<Client> createClient({
  required String name,
  String? phone,
  String? email,     // NUEVO
  String? company,   // NUEVO
  String? source,    // NUEVO
});

// updateClient — agregar:
Future<Client> updateClient(
  String id, {
  String? name,
  String? phone,
  String? email,     // NUEVO
  String? company,   // NUEVO
  String? source,    // NUEVO
  ClientStatus? status,
});
```

---

### 2.2 — Formateo de teléfono argentino

**¿Por qué?** Los deep links de WhatsApp necesitan formato internacional (+54 9 XXX).

**Archivos a crear/modificar:**

| # | Archivo | Cambio |
|---|---------|--------|
| A | `core/utils/phone_utils.dart` | CREAR — función `formatArgPhone(String)` |
| B | `presentation/widgets/pipeline/client_card.dart` | Usar `formatArgPhone` para el link wa.me |
| C | `presentation/screens/client_detail/client_detail_screen.dart` | Usar `formatArgPhone` para el botón WA |
| D | `presentation/widgets/client/client_info_tab.dart` | Hint text con formato esperado |

**Lógica de `formatArgPhone`:**
```dart
/// Normaliza teléfono argentino para wa.me
/// Input: "1155667788", "011 5566-7788", "+5491155667788"
/// Output: "5491155667788"
String formatArgPhone(String raw) {
  String digits = raw.replaceAll(RegExp(r'[^\d]'), '');
  if (digits.startsWith('0')) digits = digits.substring(1);
  if (!digits.startsWith('54')) digits = '549$digits';
  else if (digits.startsWith('54') && !digits.startsWith('549')) {
    digits = '549${digits.substring(2)}';
  }
  return digits;
}
```

---

### 2.3 — Paginación en Pipeline

**¿Por qué?** Sin paginación, con 100+ clientes la app va a ser lenta.

**Archivos a modificar:**

| # | Archivo | Cambio |
|---|---------|--------|
| A | `domain/repositories/client_repository.dart` | Agregar `offset` y `limit` a `getClients()` |
| B | `data/repositories/client_repository_impl.dart` | Usar `.range(from, to)` de Supabase |
| C | `presentation/providers/client_provider.dart` | Agregar lógica de paginación al `ClientsNotifier` |
| D | `presentation/widgets/pipeline/pipeline_column.dart` | `ScrollController` + listener para cargar más |

**Detalle:**
```dart
// Repository interface:
Future<List<Client>> getClients({int offset = 0, int limit = 50});

// Implementation:
final response = await _client
    .from('clients')
    .select()
    .eq('user_id', _userId)
    .order('created_at', ascending: false)
    .range(offset, offset + limit - 1);

// Provider: mantener un offset por status y hacer append en lugar de replace
```

---

### 2.4 — Fix client_name en tareas pendientes

**¿Por qué?** `getPendingTasks()` hace join con clients pero `TaskModel.fromJson` no parsea el `clients.name`.

**Archivos a modificar:**

| # | Archivo | Cambio |
|---|---------|--------|
| A | `domain/entities/task.dart` | Agregar `String? clientName` |
| B | `data/models/task_model.dart` | Parsear `json['clients']['name']` en fromJson |
| C | `presentation/screens/tasks/tasks_screen.dart` | Mostrar `task.clientName` en el ListTile |

**Detalle del fix en `task_model.dart`:**
```dart
factory TaskModel.fromJson(Map<String, dynamic> json) {
  return TaskModel(
    // ... campos existentes ...
    clientName: json['clients'] is Map
        ? json['clients']['name'] as String?
        : null,
  );
}
```

---

### 2.5 — Snackbar de Undo para eliminaciones

**¿Por qué?** Un swipe accidental no debería borrar datos sin posibilidad de recuperar.

**Archivos a modificar:**

| # | Archivo | Cambio |
|---|---------|--------|
| A | `domain/repositories/client_repository.dart` | Agregar `restoreClient(String id)` |
| B | `domain/repositories/note_repository.dart` | Agregar `restoreNote(String id)` |
| C | `domain/repositories/task_repository.dart` | Agregar `restoreTask(String id)` |
| D | Implementaciones correspondientes | `UPDATE SET deleted_at = NULL WHERE id = $id` |
| E | `presentation/widgets/client/note_list_tab.dart` | SnackBar con acción "Deshacer" |
| F | `presentation/widgets/client/task_list_tab.dart` | SnackBar con acción "Deshacer" |

**Patrón de implementación:**
```dart
// En el Dismissible onDismissed:
await notifier.deleteNote(noteId);
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Nota eliminada'),
    action: SnackBarAction(
      label: 'Deshacer',
      onPressed: () => notifier.restoreNote(noteId),
    ),
    duration: Duration(seconds: 5),
  ),
);
```

**Migración SQL necesaria para restore (no se necesita migración nueva — el UPDATE a deleted_at=NULL ya funciona con RLS existente):**

> ⚠️ **Nota:** Las políticas de SELECT filtran `deleted_at IS NULL`, así que un item soft-deleted no se puede volver a leer. Para restore, necesitamos una policy UPDATE que no filtre por deleted_at, o usar una función RPC:

```sql
-- 002b: agregar policy de update que permita restaurar
-- (o mejor, crear una función RPC)
CREATE OR REPLACE FUNCTION restore_note(note_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE notes SET deleted_at = NULL
  WHERE id = note_id
    AND EXISTS (
      SELECT 1 FROM clients
      WHERE clients.id = notes.client_id
        AND clients.user_id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

### 2.6 — Dark Mode

**¿Por qué?** La mayoría de usuarios usan dark mode. Es básico para una buena primera impresión.

**Archivos a modificar:**

| # | Archivo | Cambio |
|---|---------|--------|
| A | `core/theme/app_theme.dart` | Agregar `AppTheme.dark` con `brightness: Brightness.dark` |
| B | `main.dart` | Agregar `darkTheme: AppTheme.dark` al MaterialApp |
| C | `presentation/providers/theme_provider.dart` | CREAR — StateProvider para toggle manual (opcional) |
| D | `presentation/screens/profile/profile_screen.dart` | Switch para dark/light (opcional) |

**Implementación mínima (sigue al sistema):**
```dart
// En app_theme.dart:
static ThemeData get dark => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: _primaryColor,
  // ... mismos overrides adaptados a dark
);

// En main.dart:
MaterialApp.router(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,          // AGREGAR
  themeMode: ThemeMode.system,        // AGREGAR
  routerConfig: appRouter,
);
```

---

### Checklist Sprint 2

| # | Tarea | Prioridad | Complejidad | Estado |
|---|-------|-----------|-------------|--------|
| 2.1 | Campos adicionales en Cliente (email, company, source) | ALTA | Media | ✅ |
| 2.2 | Formateo de teléfono argentino | ALTA | Baja | ✅ |
| 2.3 | Paginación en pipeline | MEDIA | Media | ✅ |
| 2.4 | Fix client_name en tareas pendientes | ALTA | Baja | ✅ |
| 2.5 | Snackbar de Undo para eliminaciones | MEDIA | Media | ✅ |
| 2.6 | Dark mode | MEDIA | Baja | ✅ |

---

## Sprint 3 — Experiencia de Usuario

> **Objetivo:** Pulir la app para que se sienta profesional y rápida.

### 3.1 — Editar notas existentes

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/widgets/client/note_list_tab.dart` | Tap en nota → bottom sheet con contenido pre-cargado |
| B | `presentation/providers/note_provider.dart` | Agregar método `updateNote(id, content)` |

---

### 3.2 — Editar tareas existentes

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/widgets/client/task_list_tab.dart` | Tap en tarea → bottom sheet con datos pre-cargados |
| B | `presentation/providers/task_provider.dart` | Agregar método `updateTask(id, {title, dueDate})` |

---

### 3.3 — Confirmación antes de eliminar cliente

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/widgets/client/client_info_tab.dart` | AlertDialog de confirmación antes de softDelete |
| B | `presentation/screens/pipeline/pipeline_screen.dart` | Opción "Eliminar" en el bottom sheet de acciones |

---

### 3.4 — Pull-to-refresh en pipeline

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/widgets/pipeline/pipeline_column.dart` | Envolver ListView en `RefreshIndicator` |
| B | `presentation/providers/client_provider.dart` | Método `refreshByStatus(status)` |

---

### 3.5 — Contador de clientes por columna

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/widgets/pipeline/pipeline_column.dart` | Badge con count en el header |

---

### 3.6 — Orden de clientes en columna

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/widgets/pipeline/pipeline_column.dart` | DropdownButton: Recientes / Nombre / Antigüedad |
| B | `presentation/providers/client_provider.dart` | StateProvider para sort order por columna |

---

### 3.7 — Animaciones de transición

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/widgets/pipeline/client_card.dart` | `AnimatedList` para entrada/salida de cards |
| B | `core/router/app_router.dart` | `CustomTransitionPage` para client detail |

---

### 3.8 — Internacionalización (i18n): Español, Inglés, Portugués

**¿Por qué?** La app debe estar preparada para mercados fuera de Argentina (Brasil, USA/latam anglófono). Flutter tiene soporte nativo de i18n con ARB files.

**Idiomas soportados:**
- 🇦🇷 Español (es) — idioma por defecto
- 🇺🇸 Inglés (en)
- 🇧🇷 Portugués (pt)

**Dependencia:** `flutter_localizations` (ya incluido en Flutter SDK) + generación con `intl`

**Archivos a crear/modificar:**

| # | Archivo | Cambio |
|---|---------|--------|
| A | `pubspec.yaml` | Agregar `flutter_localizations`, habilitar `generate: true` |
| B | `l10n.yaml` | CREAR — configuración de generación ARB |
| C | `lib/l10n/app_es.arb` | CREAR — strings en español (idioma base) |
| D | `lib/l10n/app_en.arb` | CREAR — strings en inglés |
| E | `lib/l10n/app_pt.arb` | CREAR — strings en portugués |
| F | `main.dart` | Agregar `localizationsDelegates` y `supportedLocales` |
| G | `presentation/screens/profile/profile_screen.dart` | Selector de idioma (dropdown o radio) |
| H | `presentation/providers/locale_provider.dart` | CREAR — StateProvider<Locale> para idioma manual |
| I | **TODAS las pantallas y widgets** | Reemplazar strings hardcodeados por `AppLocalizations.of(context).xxx` |

**Configuración `l10n.yaml`:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
nullable-getter: false
```

**Ejemplo de ARB (app_es.arb):**
```json
{
  "@@locale": "es",
  "appTitle": "CRM WhatsApp",
  "pipeline": "Pipeline",
  "tasks": "Tareas",
  "profile": "Perfil",
  "newClient": "Nuevo cliente",
  "name": "Nombre",
  "phone": "Teléfono",
  "email": "Email",
  "company": "Empresa",
  "save": "Guardar",
  "cancel": "Cancelar",
  "delete": "Eliminar",
  "undo": "Deshacer",
  "notes": "Notas",
  "info": "Info",
  "login": "Iniciar sesión",
  "register": "Registrarse",
  "logout": "Cerrar sesión",
  "allCaughtUp": "¡Todo al día!",
  "noNotes": "Sin notas",
  "noTasks": "Sin tareas",
  "clientDeleted": "Cliente eliminado",
  "noteDeleted": "Nota eliminada",
  "taskDeleted": "Tarea eliminada",
  "statusNew": "Nuevo",
  "statusContacted": "Contactado",
  "statusInterested": "Interesado",
  "statusNegotiating": "Negociando",
  "statusClosedWon": "Ganado",
  "statusClosedLost": "Perdido",
  "language": "Idioma",
  "overdueTasks": "{count} tareas vencidas",
  "@overdueTasks": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

**Ejemplo `app_en.arb`:**
```json
{
  "@@locale": "en",
  "appTitle": "CRM WhatsApp",
  "pipeline": "Pipeline",
  "tasks": "Tasks",
  "profile": "Profile",
  "newClient": "New client",
  "name": "Name",
  "phone": "Phone",
  "email": "Email",
  "company": "Company",
  "save": "Save",
  "cancel": "Cancel",
  "delete": "Delete",
  "undo": "Undo",
  "notes": "Notes",
  "info": "Info",
  "login": "Log in",
  "register": "Sign up",
  "logout": "Log out",
  "allCaughtUp": "All caught up!",
  "noNotes": "No notes",
  "noTasks": "No tasks",
  "clientDeleted": "Client deleted",
  "noteDeleted": "Note deleted",
  "taskDeleted": "Task deleted",
  "statusNew": "New",
  "statusContacted": "Contacted",
  "statusInterested": "Interested",
  "statusNegotiating": "Negotiating",
  "statusClosedWon": "Won",
  "statusClosedLost": "Lost",
  "language": "Language",
  "overdueTasks": "{count} overdue tasks",
  "@overdueTasks": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

**Ejemplo `app_pt.arb`:**
```json
{
  "@@locale": "pt",
  "appTitle": "CRM WhatsApp",
  "pipeline": "Pipeline",
  "tasks": "Tarefas",
  "profile": "Perfil",
  "newClient": "Novo cliente",
  "name": "Nome",
  "phone": "Telefone",
  "email": "Email",
  "company": "Empresa",
  "save": "Salvar",
  "cancel": "Cancelar",
  "delete": "Excluir",
  "undo": "Desfazer",
  "notes": "Notas",
  "info": "Info",
  "login": "Entrar",
  "register": "Cadastrar",
  "logout": "Sair",
  "allCaughtUp": "Tudo em dia!",
  "noNotes": "Sem notas",
  "noTasks": "Sem tarefas",
  "clientDeleted": "Cliente excluído",
  "noteDeleted": "Nota excluída",
  "taskDeleted": "Tarefa excluída",
  "statusNew": "Novo",
  "statusContacted": "Contatado",
  "statusInterested": "Interessado",
  "statusNegotiating": "Negociando",
  "statusClosedWon": "Ganho",
  "statusClosedLost": "Perdido",
  "language": "Idioma",
  "overdueTasks": "{count} tarefas atrasadas",
  "@overdueTasks": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

**Cambios en `main.dart`:**
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp.router(
  // ... theme, router ...
  locale: ref.watch(localeProvider),  // manual override
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);
```

**Patrón de uso en widgets:**
```dart
// Antes:
Text('Nuevo cliente')

// Después:
Text(AppLocalizations.of(context).newClient)

// Shortcut recomendado (extension):
extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
// Uso: Text(context.l10n.newClient)
```

**Selector de idioma en ProfileScreen:**
```dart
DropdownButton<Locale>(
  value: ref.watch(localeProvider),
  items: [
    DropdownMenuItem(value: Locale('es'), child: Text('Español')),
    DropdownMenuItem(value: Locale('en'), child: Text('English')),
    DropdownMenuItem(value: Locale('pt'), child: Text('Português')),
  ],
  onChanged: (locale) => ref.read(localeProvider.notifier).state = locale!,
)
```

**Archivos con strings hardcodeados a reemplazar (todos):**
1. `presentation/screens/auth/login_screen.dart`
2. `presentation/screens/auth/register_screen.dart`
3. `presentation/screens/pipeline/pipeline_screen.dart`
4. `presentation/screens/tasks/tasks_screen.dart`
5. `presentation/screens/profile/profile_screen.dart`
6. `presentation/screens/client_detail/client_detail_screen.dart`
7. `presentation/screens/shell_screen.dart`
8. `presentation/widgets/pipeline/pipeline_column.dart`
9. `presentation/widgets/pipeline/client_card.dart`
10. `presentation/widgets/client/client_info_tab.dart`
11. `presentation/widgets/client/note_list_tab.dart`
12. `presentation/widgets/client/task_list_tab.dart`
13. `domain/entities/client.dart` — labels del enum `ClientStatus`

---

### Checklist Sprint 3

| # | Tarea | Prioridad | Complejidad | Estado |
|---|-------|-----------|-------------|--------|
| 3.1 | Editar notas existentes | ALTA | Baja | ⬜ |
| 3.2 | Editar tareas existentes | ALTA | Baja | ⬜ |
| 3.3 | Confirmación antes de eliminar cliente | ALTA | Baja | ⬜ |
| 3.4 | Pull-to-refresh en pipeline | MEDIA | Baja | ⬜ |
| 3.5 | Contador de clientes por columna | BAJA | Baja | ⬜ |
| 3.6 | Orden de clientes en columna | BAJA | Media | ⬜ |
| 3.7 | Animaciones de transición | BAJA | Media | ⬜ |
| 3.8 | Internacionalización (es/en/pt) | ALTA | Media | ⬜ |

---

## Sprint 4 — Búsqueda, Filtros y Métricas

> **Objetivo:** Que el usuario encuentre y entienda sus datos rápidamente.

### 4.1 — Búsqueda global de clientes

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/screens/pipeline/pipeline_screen.dart` | SearchBar en AppBar con delegate |
| B | `presentation/providers/client_provider.dart` | Usar `filteredClientsProvider` existente + debounce |
| C | `presentation/screens/pipeline/search_results_screen.dart` | CREAR — pantalla de resultados |

---

### 4.2 — Filtro por fecha de creación

| # | Archivo | Cambio |
|---|---------|--------|
| A | `domain/repositories/client_repository.dart` | Agregar `getClients({DateTime? from, DateTime? to})` |
| B | `data/repositories/client_repository_impl.dart` | `.gte('created_at', from).lte('created_at', to)` |
| C | `presentation/screens/pipeline/pipeline_screen.dart` | IconButton filtro → DateRangePicker |

---

### 4.3 — Dashboard de métricas básicas

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/screens/pipeline/pipeline_screen.dart` | Expandable header con stats |
| B | `presentation/providers/metrics_provider.dart` | CREAR — Provider derivado con conteos |

**Métricas a mostrar:**
- Total de clientes activos
- Clientes por estado (mini barras)
- Tasa de conversión (closed_won / total)
- Clientes nuevos esta semana/mes
- Tareas vencidas

---

### 4.4 — Filtro por origen (source)

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/screens/pipeline/pipeline_screen.dart` | Chip filters por source |
| B | `presentation/providers/client_provider.dart` | StateProvider para source filter |

---

### Checklist Sprint 4

| # | Tarea | Prioridad | Complejidad | Estado |
|---|-------|-----------|-------------|--------|
| 4.1 | Búsqueda global de clientes | ALTA | Media | ⬜ |
| 4.2 | Filtro por fecha de creación | MEDIA | Media | ⬜ |
| 4.3 | Dashboard de métricas básicas | MEDIA | Media | ⬜ |
| 4.4 | Filtro por origen | BAJA | Baja | ⬜ |

---

## Sprint 5 — Notificaciones y Recordatorios

> **Objetivo:** Que el usuario no pierda seguimientos importantes.

### 5.1 — Notificaciones locales para tareas

**Dependencia nueva:** `flutter_local_notifications`

| # | Archivo | Cambio |
|---|---------|--------|
| A | `pubspec.yaml` | Agregar `flutter_local_notifications: ^19.0.0` |
| B | `core/services/notification_service.dart` | CREAR — singleton para inicializar y programar |
| C | `presentation/providers/task_provider.dart` | Programar notificación al crear tarea con due_date |
| D | `main.dart` | Inicializar notification service |
| E | Android: `AndroidManifest.xml` | Permisos de notificación |
| F | iOS: Runner configs | Background modes, notification permissions |

---

### 5.2 — Badge de tareas vencidas

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/screens/shell_screen.dart` | Badge en el ícono de Tareas con count de overdue |
| B | `presentation/providers/task_provider.dart` | Provider `overdueCountProvider` |

---

### 5.3 — Recordatorio de seguimiento automático

**Migración DB:** `005_add_follow_up.sql`
```sql
ALTER TABLE clients ADD COLUMN next_follow_up TIMESTAMPTZ;
```

| # | Archivo | Cambio |
|---|---------|--------|
| A | `domain/entities/client.dart` | Agregar `DateTime? nextFollowUp` |
| B | `data/models/client_model.dart` | Parsear/serializar campo |
| C | `presentation/widgets/pipeline/client_card.dart` | Indicador visual si follow-up vencido |
| D | `presentation/widgets/client/client_info_tab.dart` | DatePicker para próximo seguimiento |

---

### Checklist Sprint 5

| # | Tarea | Prioridad | Complejidad | Estado |
|---|-------|-----------|-------------|--------|
| 5.1 | Notificaciones locales para tareas | ALTA | Alta | ⬜ |
| 5.2 | Badge de tareas vencidas | MEDIA | Baja | ⬜ |
| 5.3 | Recordatorio de seguimiento | MEDIA | Media | ⬜ |

---

## Sprint 6 — Revenue y Monetización

> **Objetivo:** Trackear el valor de las ventas y preparar para monetización.

### 6.1 — Monto de venta en cliente

**Migración DB:** `006_add_deal_value.sql`
```sql
ALTER TABLE clients ADD COLUMN deal_value NUMERIC(12,2);
ALTER TABLE clients ADD COLUMN currency   TEXT DEFAULT 'ARS';
```

| # | Archivo | Cambio |
|---|---------|--------|
| A | `domain/entities/client.dart` | Agregar `double? dealValue`, `String? currency` |
| B | `data/models/client_model.dart` | Parsear/serializar |
| C | `presentation/widgets/client/client_info_tab.dart` | Campo de monto con formato moneda |
| D | `presentation/widgets/pipeline/client_card.dart` | Mostrar monto en la card |
| E | `presentation/providers/metrics_provider.dart` | Revenue total por estado |

---

### 6.2 — Resumen de revenue por período

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/screens/metrics/metrics_screen.dart` | CREAR — pantalla dedicada a métricas |
| B | `core/router/app_router.dart` | Agregar ruta /metrics |
| C | `presentation/screens/shell_screen.dart` | Cuarto tab o acceso desde pipeline |

---

### 6.3 — Exportar clientes a CSV

| # | Archivo | Cambio |
|---|---------|--------|
| A | `core/services/export_service.dart` | CREAR — generar CSV de clientes |
| B | `presentation/screens/profile/profile_screen.dart` | Botón "Exportar datos" |

**Dependencia:** `share_plus` para compartir el archivo.

---

### Checklist Sprint 6

| # | Tarea | Prioridad | Complejidad | Estado |
|---|-------|-----------|-------------|--------|
| 6.1 | Monto de venta en cliente | ALTA | Media | ⬜ |
| 6.2 | Resumen de revenue por período | MEDIA | Alta | ⬜ |
| 6.3 | Exportar clientes a CSV | BAJA | Media | ⬜ |

---

## Sprint 7 — Captación de Leads (Formulario Público)

> **Objetivo:** Que cada usuario tenga un formulario público para captar leads que caigan directo a su pipeline.  
> **Propuesta de valor:** "Compartí un link y los leads aparecen en tu pipeline"

### Concepto

Cada usuario de VentasApp tiene un **link único** (ej: `ventasapp.com/f/abc123`). Cuando alguien llena el formulario, se crea un cliente con `status: new` en el pipeline del dueño del formulario.

Esto convierte a VentasApp de un CRM pasivo a una herramienta de **captación activa** de clientes.

### 7.1 — Token de formulario por usuario ✅

**Migración DB:** `004_user_profiles_and_submit_lead.sql` (ya ejecutada)

Se creó la tabla `user_profiles` con `form_token` UUID único por usuario, trigger `handle_new_user()` para auto-crear perfil en signup, y backfill de usuarios existentes. RLS configurado para que cada usuario solo vea su propio perfil.

| # | Archivo | Cambio | Estado |
|---|---------|--------|--------|
| A | `supabase/migrations/004_user_profiles_and_submit_lead.sql` | Tabla user_profiles + trigger + RPC | ✅ |
| B | `domain/entities/user_profile.dart` | CREAR — entidad UserProfile | ⬜ |
| C | `data/models/user_profile_model.dart` | CREAR — DTO con fromJson | ⬜ |

---

### 7.2 — RPC para crear cliente desde formulario ✅

**Decisión:** Se descartó Edge Function en favor de una función RPC `submit_lead` con `SECURITY DEFINER`. Es más simple (puro SQL, sin deploy de TypeScript) y hace lo mismo: el visitante anónimo puede crear un `client` con el `user_id` del dueño del formulario.

La función valida el `form_token`, verifica que el formulario esté habilitado, y crea el cliente con `status: 'new'` y `source: 'formulario'`.

La landing (`crm_web`) ya llama a esta RPC desde `lead_capture_section.dart` con el `form_token` configurado via `--dart-define=FORM_TOKEN`.

| # | Archivo | Cambio | Estado |
|---|---------|--------|--------|
| A | `supabase/migrations/004_user_profiles_and_submit_lead.sql` | RPC submit_lead (SECURITY DEFINER) | ✅ |
| B | `crm_web/lib/sections/lead_capture_section.dart` | Llama a `rpc('submit_lead')` | ✅ |
| C | `crm_web/lib/pages/public_form_page.dart` | CREAR — formulario público standalone | ⬜ |
| D | `crm_web/lib/core/router/app_router.dart` | Agregar ruta `/f/:token` | ⬜ |

---

### 7.3 — Pantalla "Mi formulario" en la app

En la pantalla de Perfil, sección para ver y compartir el link del formulario.

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/screens/profile/profile_screen.dart` | Sección "Mi formulario" con link + botón copiar/compartir |
| B | `presentation/providers/user_profile_provider.dart` | CREAR — provider para leer form_token |
| C | `data/repositories/user_profile_repository.dart` | CREAR — consultar user_profiles |

**UI:**
```
┌─────────────────────────────────┐
│ 📋 Mi formulario de captación   │
│                                 │
│ ventasapp.com/f/abc-123-def     │
│                                 │
│ [📋 Copiar link]  [📤 Compartir]│
│                                 │
│ ☑ Formulario activo             │
└─────────────────────────────────┘
```

---

### 7.4 — Indicador de leads nuevos

Badge en el pipeline que muestre cuántos clientes nuevos llegaron desde el formulario.

| # | Archivo | Cambio |
|---|---------|--------|
| A | `presentation/screens/shell_screen.dart` | Badge en tab Pipeline con count |
| B | `presentation/providers/client_provider.dart` | Provider `newLeadsCountProvider` |

---

### Checklist Sprint 7

| # | Tarea | Prioridad | Complejidad | Estado |
|---|-------|-----------|-------------|--------|
| 7.1 | Token de formulario por usuario (user_profiles) | ALTA | Media | ✅ |
| 7.2 | RPC submit_lead + landing conectada | ALTA | Media | ✅ |
| 7.3 | Pantalla "Mi formulario" en Perfil | ALTA | Baja | ⬜ |
| 7.4 | Indicador de leads nuevos en pipeline | MEDIA | Baja | ⬜ |

---

## Backlog Futuro

Features a considerar después de Sprint 6, priorizadas por impacto:

### Tier A — Alto impacto
| Feature | Descripción | Complejidad |
|---------|-------------|-------------|
| Múltiples pipelines | Un pipeline por producto/servicio | Alta |
| Etiquetas/tags en clientes | Categorización flexible | Media |
| Historial de cambios de estado | Timeline visual de movimientos | Media |
| Templates de mensajes WA | Mensajes pre-armados para cada etapa | Baja |
| Import de contactos | Desde agenda del teléfono | Media |

### Tier B — Medio impacto
| Feature | Descripción | Complejidad |
|---------|-------------|-------------|
| Campos personalizados | El usuario define sus propios campos | Alta |
| Adjuntar archivos/fotos | Supabase Storage | Media |
| Duplicados detection | Alertar si ya existe un cliente similar | Media |
| Actividad/timeline en detalle | Feed cronológico de todo lo que pasó | Alta |
| Roles y permisos (equipo) | Múltiples usuarios en una cuenta | Muy Alta |

### Tier C — Nice to have
| Feature | Descripción | Complejidad |
|---------|-------------|-------------|
| Onboarding tutorial | Primera vez en la app | Media |
| Widgets de home screen | Tareas del día en widget nativo | Alta |
| Modo offline | Cache local con sincronización | Muy Alta |
| Integración Google Calendar | Sync de tareas | Alta |

---

## Estrategia de Migraciones DB

### Reglas
1. **Nunca** modificar una migración ya ejecutada
2. Las migraciones nuevas van en archivos numerados secuenciales
3. Solo usar `ALTER TABLE ADD COLUMN` con default NULL para cambios no-breaking
4. Todo cambio en enum requiere `ALTER TYPE ... ADD VALUE`
5. Las funciones RPC van en la misma migración que las necesita

### Plan de migraciones

| Migración | Sprint | Contenido |
|-----------|--------|-----------|
| `001_initial_schema.sql` | 1 | ✅ Schema base (clients, notes, tasks, RLS, triggers) |
| `002_add_client_fields.sql` | 2 | ✅ email, company, source + funciones RPC restore |
| `003_leads_table.sql` | Marketing | ✅ Tabla leads para captura landing (legacy, reemplazada por RPC) |
| `004_user_profiles_and_submit_lead.sql` | 7 | ✅ user_profiles + form_token + trigger + RPC submit_lead |
| `005_add_follow_up.sql` | 5 | next_follow_up en clients |
| `006_add_deal_value.sql` | 6 | deal_value, currency en clients |

### Template de migración
```sql
-- ============================================================
-- CRM MVP - Migration NNN: <descripción>
-- Sprint: X | Fecha: YYYY-MM-DD
-- ============================================================

-- Ejecutar en Supabase SQL Editor
-- https://supabase.com/dashboard/project/xxssynpydlfhjwkcipca/sql

BEGIN;

-- ... cambios aquí ...

COMMIT;
```

---

## Inventario Actual del Código

### Entidades (domain/entities/)

**Client**
```
id: String, userId: String, name: String, phone: String?,
status: ClientStatus, createdAt: DateTime, updatedAt: DateTime
```

**Note**
```
id: String, clientId: String, content: String,
createdAt: DateTime, updatedAt: DateTime
```

**Task**
```
id: String, clientId: String, title: String,
dueDate: DateTime?, completed: bool,
createdAt: DateTime, updatedAt: DateTime
```

### ClientStatus Enum
```
new → "Nuevo"
contacted → "Contactado"
interested → "Interesado"
negotiating → "Negociando"
closed_won → "Ganado"
closed_lost → "Perdido"
```

### Repository Interfaces

**ClientRepository**
```dart
getClients() → Future<List<Client>>
getClientsByStatus(ClientStatus) → Future<List<Client>>
searchClients(String query) → Future<List<Client>>
getClient(String id) → Future<Client>
createClient({name, phone?}) → Future<Client>
updateClient(id, {name?, phone?, status?}) → Future<Client>
softDeleteClient(id) → Future<void>
```

**NoteRepository**
```dart
getNotesByClient(clientId) → Future<List<Note>>
createNote({clientId, content}) → Future<Note>
updateNote(id, {content}) → Future<Note>
softDeleteNote(id) → Future<void>
```

**TaskRepository**
```dart
getTasksByClient(clientId) → Future<List<Task>>
getPendingTasks() → Future<List<Task>>
createTask({clientId, title, dueDate?}) → Future<Task>
updateTask(id, {title?, dueDate?, completed?}) → Future<Task>
toggleComplete(id) → Future<Task>
softDeleteTask(id) → Future<void>
```

### Providers

| Provider | Tipo | Scope |
|----------|------|-------|
| `clientsProvider` | `AsyncNotifier<List<Client>>` | Global |
| `pipelineProvider` | `Provider<AsyncValue<Map<...>>>` | Derivado |
| `clientSearchQueryProvider` | `StateProvider<String>` | Global |
| `filteredClientsProvider` | `FutureProvider<List<Client>>` | Derivado |
| `notesProvider` | `FamilyAsyncNotifier<List<Note>, String>` | Por cliente |
| `clientTasksProvider` | `FamilyAsyncNotifier<List<Task>, String>` | Por cliente |
| `pendingTasksProvider` | `FutureProvider<List<Task>>` | Global |
| `authNotifierProvider` | `AsyncNotifier<void>` | Global |
| `authStateProvider` | `StreamProvider<User?>` | Global |

### Dependencias (pubspec.yaml)
```yaml
supabase_flutter: ^2.8.0
flutter_riverpod: ^2.6.0
riverpod_annotation: ^2.6.0
go_router: ^14.8.0
intl: ^0.19.0
url_launcher: ^6.3.0
```

### Rutas (GoRouter)
```
/login              → LoginScreen
/register           → RegisterScreen
/pipeline           → PipelineScreen          (tab 0)
/tasks              → TasksScreen             (tab 1)
/profile            → ProfileScreen           (tab 2)
/client/:id         → ClientDetailScreen      (full screen)
```

---

## Checklist General de Progreso

| Sprint | Features | Estado |
|--------|----------|--------|
| Sprint 1 | MVP Base (14 features) | ✅ Completado |
| Sprint 2 | Producción Mínima (6 features) | ✅ Completado |
| Landing | Landing page + design system + marketing funnel | ✅ Completado |
| Sprint 3 | UX Polish + i18n (8 features) | ⬜ Pendiente |
| Sprint 4 | Búsqueda y Métricas (4 features) | ⬜ Pendiente |
| Sprint 5 | Notificaciones (3 features) | ⬜ Pendiente |
| Sprint 6 | Revenue (3 features) | ⬜ Pendiente |
| Sprint 7 | Captación de Leads (4 features) | 🔄 En progreso (2/4) |

**Total features planeadas:** 42  
**Completadas:** 22  
**Pendientes:** 20
