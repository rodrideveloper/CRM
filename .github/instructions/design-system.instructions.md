---
applyTo: "**/*.dart"
---

# TRATAR — Design System

> Guía de colores, tipografía, espaciado y componentes para todo el sistema (crm_app + crm_web).

## Identidad Visual

- **Marca**: TRATAR
- **Concepto**: CRM profesional con ADN WhatsApp. Colores amigables, modernos, que transmitan confianza y velocidad.
- **Tono**: Oscuro (dark-first), con acentos verdes WhatsApp y fondos azul profundo (slate).

---

## Paleta de Colores

### Colores Primarios

| Token | Hex | Uso |
|-------|-----|-----|
| `primary` | `#25D366` | Botones principales, CTA, iconos activos, badges |
| `primaryDark` | `#128C7E` | Gradientes, hover states, bordes activos |
| `primaryLight` | `#25D366` al 10% opacidad | Badges, backgrounds sutiles, chips |

### Fondos (Dark Theme)

| Token | Hex | Uso |
|-------|-----|-----|
| `bgDeep` | `#0B1121` | Fondo de secciones alternas (web), fondo más oscuro |
| `bgBase` | `#0F172A` | Scaffold principal, fondo base (Slate 900) |
| `bgElevated` | `#1E293B` | Cards, inputs, bottom sheets, superficies elevadas (Slate 800) |
| `bgSubtle` | `#1A2332` | Gradientes sutiles, hover en cards |

### Fondos (Light Theme — solo crm_app)

| Token | Hex | Uso |
|-------|-----|-----|
| `bgBase` | `#FFFFFF` | Scaffold principal |
| `bgElevated` | `#F8FAFC` | Cards, superficies (Slate 50) |
| `bgSubtle` | `#F1F5F9` | Inputs, chips, separadores (Slate 100) |

### Texto

| Token | Dark | Light | Uso |
|-------|------|-------|-----|
| `textPrimary` | `#FFFFFF` | `#0F172A` | Títulos, contenido principal |
| `textSecondary` | `#FFFFFF` al 60% | `#64748B` | Subtítulos, descripciones (Slate 500) |
| `textTertiary` | `#FFFFFF` al 40% | `#94A3B8` | Hints, timestamps (Slate 400) |

### Semánticos

| Token | Hex | Uso |
|-------|-----|-----|
| `success` | `#25D366` | Operaciones exitosas (= primary) |
| `error` | `#E53935` | Errores, tareas vencidas, eliminación |
| `warning` | `#FB923C` | Alertas, follow-up próximo (Orange 400) |
| `info` | `#38BDF8` | Información, tips (Sky 400) |

### Estados del Pipeline

| Status | Color | Hex |
|--------|-------|-----|
| `new` | Verde claro | `#25D366` |
| `contacted` | Azul cielo | `#38BDF8` |
| `interested` | Violeta | `#A78BFA` |
| `negotiating` | Naranja | `#FB923C` |
| `closed_won` | Verde esmeralda | `#10B981` |
| `closed_lost` | Rojo suave | `#F87171` |

---

## Gradientes

| Nombre | Uso | Colores |
|--------|-----|---------|
| `primaryGradient` | CTAs, botones hero, highlights | `#25D366` → `#128C7E` |
| `bgGradient` | Fondos de secciones | `#0F172A` → `#1A2332` |
| `heroGradient` | Sección hero (web) | `#0F172A` → `#1A2332` (topLeft→bottomRight) |

---

## Tipografía

| Plataforma | Fuente | Fallback |
|------------|--------|----------|
| **Web** (crm_web) | Inter (Google Fonts) | system-ui, sans-serif |
| **Mobile** (crm_app) | System default (Roboto/SF Pro) | — |

### Escala tipográfica

| Nombre | Tamaño Web | Tamaño Mobile | Peso | Uso |
|--------|------------|---------------|------|-----|
| `displayLarge` | 56px | 32px | ExtraBold (800) | Headlines hero |
| `headlineMedium` | 32px | 24px | Bold (700) | Títulos de sección |
| `titleLarge` | 22px | 22px | SemiBold (600) | Títulos de pantalla, AppBar |
| `titleMedium` | 16px | 16px | SemiBold (600) | Subtítulos, nombres de columna |
| `bodyLarge` | 19px | 16px | Regular (400) | Texto principal, descripciones |
| `bodyMedium` | 14px | 14px | Regular (400) | Contenido de cards, notas |
| `labelMedium` | 13px | 12px | Medium (500) | Badges, chips, timestamps |

---

## Espaciado

Múltiplos de **4px** (4-point grid):

| Token | Valor | Uso |
|-------|-------|-----|
| `xs` | 4px | Separación mínima entre iconos y texto |
| `sm` | 8px | Padding interno de chips, gap entre elementos inline |
| `md` | 16px | Padding de cards, margin entre secciones internas |
| `lg` | 24px | Separación entre secciones, padding de pantalla (mobile) |
| `xl` | 32px | Separación grande entre bloques |
| `xxl` | 48-80px | Padding de secciones (web), hero |

---

## Border Radius

| Componente | Radius |
|------------|--------|
| Botones | 12px |
| Cards | 12px (mobile) / 16px (web) |
| Inputs | 12px |
| Chips / Badges | 20px (pill) |
| Bottom sheets | 16px (top) |
| Avatares | 50% (circular) |

---

## Sombras y Elevación

| Contexto | Estilo |
|----------|--------|
| **Dark theme** | No usar sombras. Usar bordes sutiles (`Colors.white10`, `Colors.white12`) para separar superficies. |
| **Light theme** | Elevation 1-2 para cards. Sin sombras agresivas. |
| **Hover (web)** | Scale 1.02-1.05 + borde verde sutil (`primary` al 30%) |

---

## Componentes

### Botones

| Tipo | Estilo | Uso |
|------|--------|-----|
| **Primary** | Fondo `#25D366`, texto blanco, height 48px (mobile) / 56px (web) | CTAs principales |
| **Outlined** | Borde `white24`, texto blanco | Acciones secundarias |
| **Text** | Sin fondo, texto `primary` | Links, acciones terciarias |

### Cards

- Dark: Fondo `bgElevated` (#1E293B), borde `Colors.white10`, radius 12-16px
- Light: Fondo blanco, elevation 1, radius 12px
- Padding interno: `md` (16px)

### Inputs

- Filled style, fondo `bgElevated`
- Border radius 12px
- Focus: borde `primary`, width 2
- Padding: horizontal 16-20px, vertical 14-18px

### SnackBars

- Floating behavior
- Border radius 8px
- Acción en color `primary`

---

## Reglas de Implementación

1. **NUNCA hardcodear colores** en widgets. Usar `Theme.of(context).colorScheme` o constantes del theme.
2. **Dark-first**: Diseñar primero para dark mode. Light es secundario (solo crm_app).
3. **WhatsApp green (#25D366) es el color anchor** — todo el color scheme de Material 3 se genera a partir de este con `colorSchemeSeed`.
4. **Fondos azul-slate** en dark (#0F172A familia) — NO usar negro puro (#000000).
5. **Gradientes verdes** (primary → primaryDark) para CTAs destacados y secciones hero.
6. **Bordes sutiles** (`white10`, `white12`) en dark theme en lugar de sombras.
7. **Consistencia cross-platform**: Los colores semánticos son los mismos en crm_app y crm_web.
8. **Pipeline colors**: Cada status tiene su color asignado. Usar siempre los mismos en cards, badges y filtros.
