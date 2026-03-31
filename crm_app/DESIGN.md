```markdown
# Design System Specification: High-End CRM Mobile Experience

## 1. Overview & Creative North Star: "The Obsidian Architect"
This design system moves away from the generic, boxy nature of standard CRMs to embrace a "High-End Editorial" aesthetic. Our North Star is **The Obsidian Architect**: a visual philosophy that treats data not as rows in a database, but as prioritized layers of information carved out of deep, architectural space. 

By leveraging Material Design 3 (MD3) logic through a custom, high-contrast lens, we create an experience that feels authoritative yet fluid. We break the "template" look by using intentional white space, asymmetrical headers, and a sophisticated layering of surfaces that eliminates the need for heavy structural lines.

---

## 2. Colors & Tonal Depth
The palette is rooted in deep Slates and vibrant Greens, optimized for high-performance dark mode environments.

### Surface Hierarchy & Nesting
To achieve a premium feel, we strictly follow the **"No-Line" Rule**. Separation must be achieved through tonal shifts between surfaces, not solid 1px borders.
- **Base Layer:** `surface` (#0b1326) – The foundation.
- **Sectioning:** `surface_container_low` (#131b2e) – Used for large background sections.
- **Primary Cards:** `surface_container` (#171f33) – The default for interactive data blocks.
- **Floating/Active Elements:** `surface_container_high` (#222a3d) – Used to pull high-priority content toward the user.

### The Glass & Gradient Rule
To provide "visual soul," primary CTAs and Hero sections should utilize a subtle linear gradient:
- **Direction:** 135° (Top-left to Bottom-right)
- **Values:** `primary_container` (#25d366) to `primary` (#4ff07f).
- **Glassmorphism:** For floating Navigation Bars or Modals, use `surface_container_highest` (#2d3449) at 80% opacity with a **20px Backdrop Blur**.

### Status Palette (Semantic Meaning)
- **Nuevo:** `primary` (#4ff07f)
- **Contactado:** `secondary_fixed` (#8ff4e3)
- **Interesado:** `tertiary_fixed_dim` (#ffb59b)
- **Negociando:** `on_tertiary_container` (#78351b)
- **Ganado:** `on_primary_container` (#005523)
- **Perdido:** `error` (#ffb4ab)

---

## 3. Typography: The Editorial Scale
We utilize a clean, sans-serif approach (Inter/Roboto) to ensure legibility while using scale to imply importance.

| Level | Token | Size | Tracking | Weight | Usage |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Display** | `display-md` | 2.75rem | -2% | Bold | High-impact sales numbers |
| **Headline** | `headline-sm` | 1.5rem | -1% | Semi-Bold | Screen titles/Major sections |
| **Title** | `title-md` | 1.125rem | 0 | Medium | Lead names, Card headers |
| **Body** | `body-md` | 0.875rem | 0 | Regular | Descriptions, activity logs |
| **Label** | `label-md` | 0.75rem | +2% | Bold | Status chips, Metadata |

**Editorial Note:** Use `on_surface` (White) for titles and `on_surface_variant` (60% Opacity) for body text to create a natural hierarchy without changing font sizes.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are prohibited. Depth is conveyed through **Tonal Stacking**.

- **The Layering Principle:** Place a `surface_container_high` card on a `surface` background to create a "lifted" effect.
- **The Ghost Border:** For accessibility on cards, use a 1px border using `outline_variant` (#3c4a3d) at **12% opacity**. This provides a whisper of a boundary that feels integrated, not forced.
- **Ambient Glow:** Instead of shadows, high-priority "Win" states can use a very soft, diffused glow: `primary` (#4ff07f) at 5% opacity with a 32px blur radius.

---

## 5. Components

### Buttons
- **Primary:** Gradient fill (`primary_container` to `primary`). 12px (`md`) radius. Text color: `on_primary`.
- **Secondary:** Outline-only. 1px `outline` (#869584) at 20% opacity. 12px radius.
- **Tertiary/Ghost:** No container. Use `primary` color for text.

### The Sales Lead Card
- **Structure:** No dividers. Use 1.75rem (`8`) vertical spacing to separate the Lead Name from the Last Contact date.
- **Background:** `surface_container`.
- **Border:** 1px Ghost Border (12% opacity).
- **Radius:** 1rem (`lg`) for a more modern, friendly feel.

### Status Chips
- **Shape:** Full Pill (`full`).
- **Style:** Subtle Background. Use the Status Color at 15% opacity with the text in 100% opacity of that same color. 
- **Example:** "Nuevo" Lead = Background: #25D366 (15% alpha), Text: #25D366.

### Data Inputs
- **Surface:** `surface_container_lowest`.
- **Active State:** Border shifts to `primary` (#4ff07f) at 40% opacity. 
- **Feedback:** Error states use `error` (#ffb4ab) text with no background change to avoid visual clutter.

---

## 6. Do’s and Don’ts

### Do
- **DO** use the 4px (`0.5`) grid religiously. All margins should be multiples of 4.
- **DO** use asymmetrical layouts for dashboards (e.g., a large display-sm number paired with a tiny label-md description).
- **DO** use `surface_bright` for active hover states on mobile touch-down.

### Don’t
- **DON’T** use pure #000000. It kills the depth of the Slate palette.
- **DON’T** use divider lines to separate list items. Use 1.3rem (`6`) of vertical whitespace instead.
- **DON’T** use "Standard" MD3 blue. Stick to the WhatsApp Green and Dark Green accents to maintain the brand's CRM identity.
- **DON’T** use 100% opaque borders. It creates "visual noise" that distracts from the data.

---

## 7. Signature Interaction: The "Fluid Transition"
When moving from a Lead List to a Lead Detail, use a **Shared Element Transition**. The `surface_container` card should appear to "grow" into the header of the next screen, maintaining the 12px radius throughout the animation to reinforce the physical architectural metaphor of the system.