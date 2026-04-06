# TRATAR — Features Roadmap (derivado del marketing)

> **Última actualización:** 6 de abril de 2026
> **Criterio:** Cada feature se justifica por su impacto en adquisición, retención o conversión.
> **Público de referencia:** Ver [AUDIENCE.md](AUDIENCE.md)

---

## Estado actual del producto

### Lo que ya existe (Sprint 1-3 completados)

| Feature | Estado | Impacto marketing |
|---------|--------|-------------------|
| Pipeline visual (kanban horizontal) | ✅ Producción | Es el core visual para demos y ads |
| Notas por cliente | ✅ Producción | Diferenciador vs "anotar en WhatsApp" |
| Tareas de seguimiento | ✅ Producción | El argumento de "no pierdas ventas" |
| Contacto rápido (deep link WhatsApp) | ✅ Producción | Feature de conveniencia, no identidad |
| Formulario público de leads (trat.ar) | ✅ Producción | Captura desde ads y landing |
| Auth email/password | ✅ Producción | Registro simple |
| Soft delete | ✅ Producción | Seguridad de datos |

### Lo que falta del SPRINT_PLAN.md

| Sprint | Features | Estado |
|--------|----------|--------|
| Sprint 4 | Búsqueda, filtros, métricas | Pendiente |
| Sprint 5 | Notificaciones y recordatorios | Pendiente |
| Sprint 6 | Monetización (pagos) | Pendiente |

---

## Features prioritarias por impacto en marketing

### Prioridad 1: Impacto directo en adquisición y retención

#### 1.1 Notificaciones push de seguimiento
**Sprint:** 5 | **Persona:** Nico, Caro

El argumento central del marketing es "no pierdas ventas por falta de seguimiento". Sin notificaciones, el usuario tiene que acordarse de abrir la app. Con notificaciones, la app le recuerda.

- Push notification: "Tenés una tarea pendiente con [cliente]"
- Push notification: "Hace 5 días que no contactás a [cliente]"
- Configurable: frecuencia, horarios

**Impacto marketing:**
- Hace real la promesa de "no pierdas más ventas"
- Mejora retención (el usuario vuelve a la app)
- Es un argumento de venta fuerte: "la app te avisa cuándo contactar"
- Contenido TikTok: "Tu celular te avisa cuándo escribirle a cada cliente"

---

#### 1.2 Métricas básicas / dashboard
**Sprint:** 4 | **Persona:** Nico, Martín

Datos simples: cuántos clientes nuevos esta semana, cuántos cerrados, tasa de conversión. El vendedor quiere ver que progresa. El dueño de PyME quiere ver qué pasa.

- Total de clientes por estado
- Clientes cerrados este mes vs anterior
- Tasa de conversión del pipeline
- Valor total de deals en pipeline (ya existe `deal_value`)

**Impacto marketing:**
- Screenshots de métricas para ads ("mirá cuánto cerraste este mes")
- Argumento para PyMEs: "visibilidad de tu equipo comercial"
- Contenido TikTok: "¿Sabés cuántas ventas cerraste este mes? ¿No? Ahí está el problema"

---

#### 1.3 Búsqueda y filtros
**Sprint:** 4 | **Persona:** Nico, Caro

Cuando tenés +30 clientes, scrollear el pipeline no alcanza. Búsqueda por nombre/teléfono y filtros por estado/fecha.

**Impacto marketing:**
- Demo en video: "encontrá cualquier cliente en 2 segundos"
- Reduce fricción → mejora retención

---

### Prioridad 2: Impacto en conversión y monetización

#### 2.1 Referral program ("invitá un amigo")
**Fase:** 3 (mes 6+) | **Persona:** Todos

El boca a boca es el canal más barato. Incentivar que usuarios inviten colegas.

- Botón "Compartir TRATAR" en perfil
- Deep link personalizado por usuario
- Reward: feature premium gratis / badge / reconocimiento
- Tracking: cuántos usuarios trajo cada referrer

**Impacto marketing:**
- Reduce CAC (costo de adquisición) a casi cero para referrals
- Social proof orgánico
- Contenido: "X emprendedores ya usan TRATAR, ¿y vos?"

---

#### 2.2 Importar contactos
**Fase:** 2 | **Persona:** Nico, Caro

El onboarding es el momento crítico. Si el usuario tiene que cargar 30 contactos de a uno, abandona. Importar desde contactos del teléfono o desde un CSV baja la fricción.

**Impacto marketing:**
- "En 2 minutos tenés todos tus clientes organizados en el pipeline"
- Mejora la tasa de activación (registro → uso real)

---

#### 2.3 Etiquetas / tags personalizados
**Fase:** 2 | **Persona:** Caro, Nico

"Este es de camperas", "este preguntó por alquiler", "este es VIP". Los estados del pipeline no alcanzan para segmentar.

**Impacto marketing:**
- "Segmentá tus clientes como quieras"
- Permite búsquedas más útiles

---

### Prioridad 3: Features de expansión a nuevos segmentos

#### 3.1 Multi-usuario / equipo (pitch para PyMEs)
**Fase:** 3 | **Persona:** Martín

El dueño quiere ver el pipeline de sus vendedores. Cada vendedor ve sus clientes, el admin ve todos.

**Impacto marketing:**
- Abre el segmento PyME (mayor disposición a pagar)
- Argumento: "sabé qué hace tu equipo comercial"
- Pricing: feature premium

---

#### 3.2 Recordatorios de recontacto para turnos
**Fase:** 3 | **Persona:** Valen

Si se apunta al nicho de profesionales con turnos: "Hace 3 meses que [paciente] no viene. ¿Le escribimos?"

**Impacto marketing:**
- Abre segmento salud/estética
- "Recuperá pacientes que se fueron sin avisar"

---

#### 3.3 Formulario de leads embeddable
**Fase:** 3 | **Persona:** Caro, Nico

Que el usuario pueda generar un formulario y ponerlo en su Instagram/web/link para capturar SUS leads directamente en SU pipeline.

**Impacto marketing:**
- "Cada consulta que te hacen cae directo a tu CRM"
- Cierra el loop: captación → seguimiento → cierre
- Feature premium con alto valor percibido

---

## Matriz de priorización

| Feature | Impacto en retención | Impacto en adquisición | Esfuerzo dev | Prioridad |
|---------|---------------------|----------------------|--------------|-----------|
| Notificaciones push | ★★★★★ | ★★★★☆ | Medio | **P1** |
| Métricas básicas | ★★★★☆ | ★★★★☆ | Medio | **P1** |
| Búsqueda y filtros | ★★★★☆ | ★★☆☆☆ | Bajo | **P1** |
| Importar contactos | ★★★★★ | ★★★☆☆ | Medio | **P2** |
| Etiquetas/tags | ★★★☆☆ | ★★☆☆☆ | Bajo | **P2** |
| Referral program | ★★☆☆☆ | ★★★★★ | Medio | **P2** |
| Multi-usuario | ★★★☆☆ | ★★★★☆ | Alto | **P3** |
| Reminder turnos | ★★★☆☆ | ★★★☆☆ | Medio | **P3** |
| Formulario embeddable | ★★★☆☆ | ★★★★☆ | Alto | **P3** |

---

## Relación feature → contenido de marketing

| Feature | Copy para TikTok/Ads | Cuándo comunicar |
|---------|----------------------|------------------|
| Pipeline visual | "Así se ve un vendedor organizado" | Ya (es el core) |
| Contacto rápido | "Contactá a tus clientes en 1 toque desde la app" | Ya |
| Tareas | "La app te dice cuándo contactar a cada cliente" | Ya |
| Notificaciones | "Tu celu te avisa para que no pierdas ningún follow-up" | Cuando esté listo |
| Métricas | "¿Sabés cuántas ventas cerraste? Tu CRM sí" | Cuando esté listo |
| Importar | "Todos tus contactos organizados en 2 minutos" | Cuando esté listo |
| Referral | "Invitá colegas y gestioná juntos" | Cuando esté listo |
| Multi-usuario | "Sabé qué hace tu equipo comercial" | Cuando esté listo |
