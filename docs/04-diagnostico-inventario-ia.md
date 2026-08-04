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
| 2 | **WMS** — sistema Core de Operaciones Internas | Cursor (cuenta Pro empresarial) | Anthropic (aprobado) | Opus 5, Sonnet 5 | Datos operativos del core de operaciones | **Sí** | `[por definir: si hay .cursor/rules o system prompts versionados en el repo]` | Prueba / uso activo |
| 3 | **WMS** — sistema Core de Operaciones Internas | Cursor (cuenta Pro empresarial) | xAI (en evaluación) | Grok 4.5 high fast | Datos operativos del core de operaciones | **Sí** | `[por definir]` | Prueba / uso activo |
| 4 | **WMS** — sistema Core de Operaciones Internas | Cursor (cuenta Pro empresarial) | OpenAI (en evaluación) | GPT-5.6 `[confirmar variante exacta — mencionada como "GPT-5.6 sol."]` | Datos operativos del core de operaciones | **Sí** | `[por definir]` | Prueba / uso activo |
| 5 | **WMS** — sistema Core de Operaciones Internas | Cursor (cuenta Pro empresarial) | Cursor (modelo propio, en evaluación) | Composer 2.5 fast | Datos operativos del core de operaciones | **Sí** | `[por definir]` | Prueba / uso activo |
| 6 | **HIPERSAP** — plataforma interna de procesos administrativos, integra con SAP B1 | Cursor (cuenta Pro empresarial) | Anthropic (aprobado) | Opus 5, Sonnet 5 | Datos administrativos/financieros (integración SAP B1) | **Sí** | `[por definir]` | Prueba / uso activo |
| 7 | **HIPERSAP** — plataforma interna de procesos administrativos, integra con SAP B1 | Cursor (cuenta Pro empresarial) | xAI (en evaluación) | Grok 4.5 high fast | Datos administrativos/financieros (integración SAP B1) | **Sí** | `[por definir]` | Prueba / uso activo |
| 8 | **HIPERSAP** — plataforma interna de procesos administrativos, integra con SAP B1 | Cursor (cuenta Pro empresarial) | OpenAI (en evaluación) | GPT-5.6 `[confirmar variante]` | Datos administrativos/financieros (integración SAP B1) | **Sí** | `[por definir]` | Prueba / uso activo |
| 9 | **HIPERSAP** — plataforma interna de procesos administrativos, integra con SAP B1 | Cursor (cuenta Pro empresarial) | Cursor (modelo propio, en evaluación) | Composer 2.5 fast | Datos administrativos/financieros (integración SAP B1) | **Sí** | `[por definir]` | Prueba / uso activo |
| 10 | ChatGPT (mencionado de forma general, Sprint 1) | `[por definir: ¿es el mismo GPT-5.6 vía Cursor de las filas 4/8, o un uso separado fuera de Cursor?]` | OpenAI | `[por definir]` | `[por definir]` | `[por definir]` | `[por definir]` | En evaluación |
| 11 | Grok (mencionado de forma general, Sprint 1) | `[por definir: ¿es el mismo Grok 4.5 vía Cursor de las filas 3/7, o un uso separado fuera de Cursor?]` | xAI | `[por definir]` | `[por definir]` | `[por definir]` | `[por definir]` | En evaluación |

## Hallazgo de la auditoría (para decisión del comité)

**WMS e HIPERSAP — dos sistemas core (operaciones internas y la integración
administrativa con SAP B1) — ya se usaron con Cursor configurado para
invocar proveedores no aprobados (xAI/Grok, OpenAI/GPT-5.6, y el modelo
propio "Composer" de Cursor) sobre datos que incluyen PII, antes de que
existiera una clasificación de riesgo formal o una ficha de diligencia.**

Esto es exactamente el tipo de hallazgo que la auditoría del Sprint 1 debe
sacar a la luz — no se está señalando como una falta, sino registrando como
insumo real para la matriz de riesgo (pendiente #5) y para decidir si Cursor
se formaliza como herramienta aprobada.

Definir el nivel de riesgo es una decisión humana del comité, no de Claude
Code (ver `docs/00-plan-metodologico-4D.md` §1, tabla de reparto de tareas:
"Definir niveles de riesgo por caso de uso | Humano"). Este documento deja
el nivel como **preliminar, sin clasificar**, a la espera de esa decisión.

## Pendiente

- El comité clasifica formalmente el nivel de riesgo de WMS e HIPERSAP
  (bajo/medio/alto) con este caso como ejemplo real.
- Decidir si Cursor se agrega como **herramienta aprobada** y bajo qué
  condición (ej. solo si se configura con modelos ya aprobados de Anthropic;
  o se amplía la lista de proveedores aprobados para incluir xAI/OpenAI en
  este contexto).
- Confirmar si las filas 10 y 11 (ChatGPT, Grok mencionados de forma
  general) son el mismo uso vía Cursor en WMS/HIPERSAP o casos separados.
- Registrar dónde viven los prompts/config en los repos de WMS e HIPERSAP
  (`.cursor/rules`, system prompts, u otro).
- Completar el inventario con cualquier otro repo/feature de la empresa que
  use IA y no esté listado aquí todavía.
