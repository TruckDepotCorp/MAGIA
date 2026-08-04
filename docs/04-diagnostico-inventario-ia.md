# Diagnóstico técnico — Inventario de casos de uso de IA (Sprint 1)

Entregable de la tarea 1 del Sprint 1 (`docs/01-plan-tecnico-fase1.md`):
"Auditoría técnica de uso actual de IA". Registra, por cada repo/feature que
ya invoca algún modelo/API de IA (aunque sea experimental): proveedor,
modelo, tipo de dato, si hay PII, y dónde vive el prompt/config.

## Distinción importante: herramienta vs. proveedor/modelo

Algunas herramientas (ej. Cursor) son **wrappers multi-modelo**: no son en sí
mismas un proveedor, sino un IDE que puede invocar distintos
proveedores/modelos por debajo según cómo se configuren. La regla de
`claude-md/base.md` ("nunca usar un proveedor/modelo no aprobado") aplica al
**modelo invocado por debajo**, no solo al nombre de la herramienta — usar
Cursor no exime de la lista de aprobados si por debajo está llamando a un
modelo que no está en ella.

## Inventario

| # | Repo / feature | Herramienta | Proveedor | Modelo | Tipo de dato | ¿PII? | Dónde vive el prompt/config | Estado |
|---|---|---|---|---|---|---|---|---|
| 1 | `magia-framework` (este repo) | Claude Code | Anthropic (aprobado) | Sonnet 5 / Opus 5 | Documentación de gobernanza interna, sin datos de clientes | No | N/A — uso interactivo vía CLI, sin prompts versionados en el repo | Producción (uso interno del framework) |
| 2 | **WMS** — sistema Core de Operaciones Internas | Cursor (cuenta Pro empresarial) | Anthropic (aprobado) | Opus 5, Sonnet 5 | Datos operativos del core de operaciones | **Sí** | `[por definir: si hay .cursor/rules o system prompts versionados en el repo]` | En uso (~1 año — Cursor es la herramienta formal de IA de la empresa, previa a Claude Code) |
| 3 | **WMS** — sistema Core de Operaciones Internas | Cursor (cuenta Pro empresarial) | xAI (aprobado 2026-08-04) | Grok 4.5 high fast | Datos operativos del core de operaciones | **Sí** | `[por definir]` | En uso (~1 año) |
| 4 | **WMS** — sistema Core de Operaciones Internas | Cursor (cuenta Pro empresarial) | OpenAI (aprobado 2026-08-04) | GPT-5.6 `[confirmar variante exacta — mencionada como "GPT-5.6 sol."]` | Datos operativos del core de operaciones | **Sí** | `[por definir]` | En uso (~1 año) |
| 5 | **WMS** — sistema Core de Operaciones Internas | Cursor (cuenta Pro empresarial) | Cursor, modelo propio (aprobado 2026-08-04) | Composer 2.5 fast | Datos operativos del core de operaciones | **Sí** | `[por definir]` | En uso (~1 año) |
| 6 | **HIPERSAP** — plataforma interna de procesos administrativos, integra con SAP B1 | Cursor (cuenta Pro empresarial) | Anthropic (aprobado) | Opus 5, Sonnet 5 | Datos administrativos/financieros (integración SAP B1) | **Sí** | `[por definir]` | En uso (~1 año) |
| 7 | **HIPERSAP** — plataforma interna de procesos administrativos, integra con SAP B1 | Cursor (cuenta Pro empresarial) | xAI (aprobado 2026-08-04) | Grok 4.5 high fast | Datos administrativos/financieros (integración SAP B1) | **Sí** | `[por definir]` | En uso (~1 año) |
| 8 | **HIPERSAP** — plataforma interna de procesos administrativos, integra con SAP B1 | Cursor (cuenta Pro empresarial) | OpenAI (aprobado 2026-08-04) | GPT-5.6 `[confirmar variante]` | Datos administrativos/financieros (integración SAP B1) | **Sí** | `[por definir]` | En uso (~1 año) |
| 9 | **HIPERSAP** — plataforma interna de procesos administrativos, integra con SAP B1 | Cursor (cuenta Pro empresarial) | Cursor, modelo propio (aprobado 2026-08-04) | Composer 2.5 fast | Datos administrativos/financieros (integración SAP B1) | **Sí** | `[por definir]` | En uso (~1 año) |

**Nota (2026-08-04):** las menciones sueltas de "ChatGPT" y "Grok" que
aparecían como filas separadas en una versión anterior de este documento se
confirmaron como el mismo uso de las filas 3/4/7/8 (vía Cursor, en
WMS/HIPERSAP) — no son casos de uso distintos, se retiraron para no
duplicar el inventario.

## Hallazgo de la auditoría — actualizado 2026-08-04

**WMS e HIPERSAP — dos sistemas core (operaciones internas y la integración
administrativa con SAP B1) — vienen usando Cursor desde hace ~1 año como la
herramienta formal de IA de la empresa, previa a adoptar Claude Code. Ese
uso ya tocaba PII con Grok 4.5, GPT-5.6 y el modelo propio "Composer" de
Cursor, antes de que existiera una clasificación de riesgo formal.**

**Decisión del comité (2026-08-04):** los cuatro proveedores usados vía
Cursor — Anthropic, xAI, OpenAI, y el modelo propio de Cursor — quedan
**aprobados**, dado el historial real de ~1 año de uso (ver actualización en
`claude-md/base.md`).

Esto resuelve la parte de "proveedor no aprobado" del hallazgo original.
**Sigue sin resolver, y es una decisión distinta:** que un proveedor esté
aprobado no clasifica el nivel de riesgo del caso de uso en sí. WMS e
HIPERSAP tocan PII en sistemas core y todavía no tienen un nivel de riesgo
(bajo/medio/alto) asignado formalmente. Definir ese nivel es una decisión
humana del comité, no de Claude Code (ver `docs/00-plan-metodologico-4D.md`
§1, tabla de reparto de tareas: "Definir niveles de riesgo por caso de uso |
Humano").

## Pendiente

- Clasificar formalmente el **nivel de riesgo** (bajo/medio/alto) de WMS e
  HIPERSAP como casos de uso — distinto de la aprobación de proveedor, ya
  resuelta.
- Registrar dónde viven los prompts/config en los repos de WMS e HIPERSAP
  (`.cursor/rules`, system prompts, u otro).
- Completar el inventario con cualquier otro repo/feature de la empresa que
  use IA y no esté listado aquí todavía.
