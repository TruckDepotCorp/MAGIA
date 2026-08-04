# Catálogo de capacidades (Sprint 3)

Entregable del Sprint 3 (`docs/01-plan-tecnico-fase1.md`): matriz de
decisión "tarea → modelo/herramienta recomendada → nivel de riesgo
asociado → costo relativo", usando los proveedores aprobados
(`claude-md/base.md`) y los patrones de `docs/07-arquitectura-referencia.md`.

> **Costo relativo** es una comparación cualitativa (bajo/medio/alto), no
> una tarifa negociada real — `[por definir: costos de referencia exactos,
> depende del volumen y del plan contratado con cada proveedor]`.

## Matriz de decisión

| Tipo de tarea | Modelo/herramienta recomendada | Patrón | Riesgo típico | Costo relativo |
|---|---|---|---|---|
| Asistencia de desarrollo (generación/revisión de código) | Claude Code o Cursor con Anthropic (Sonnet 5 / Opus 5) | Copiloto embebido | Bajo si el repo no toca PII; **Medio** si toca PII y es interno (ej. WMS); **Alto** si además hay exposición externa (ej. HIPERSAP) — ver `docs/05-matriz-riesgo.md` | Medio (suscripción + uso) |
| Revisión de PRs asistida | Claude Code (Anthropic) | Copiloto embebido | Bajo-Medio (mismo criterio que la fila anterior, según el repo) | Bajo (incluido en el uso de desarrollo) |
| Consulta sobre documentación/políticas internas | Anthropic (aprobado); RAG requiere infraestructura adicional (vector store) | RAG | Medio si la base de conocimiento incluye PII o datos internos sensibles | Medio (costo de infraestructura de retrieval + llamadas al modelo) |
| Acción sobre un sistema propio (ej. consultar/escribir en SAP B1) | Anthropic vía agente con herramientas/MCP | Agente con herramientas (MCP) | **Alto** por defecto si hay escritura o exposición externa — requiere ficha de diligencia (`templates/ficha-caso-de-uso.md`) | Medio-Alto (más llamadas por tarea, orquestación) |
| Clasificación o extracción simple, sin datos sensibles | Cualquiera de los aprobados (Anthropic, xAI, OpenAI, Cursor/Composer) | Prompting directo | Bajo | Bajo |
| Pipeline repetible de varios pasos (ej. documento → validación → carga a SAP) | Anthropic, orquestado de forma determinista (no agente autónomo) | Orquestador multi-paso | Depende del paso más riesgoso del pipeline — clasificar cada paso, no el pipeline completo | Medio (varias llamadas encadenadas) |

## Nota sobre proveedores en evaluación vs. aprobados

Los cuatro proveedores de `claude-md/base.md` (Anthropic, xAI, OpenAI,
Cursor/Composer) están aprobados por el historial real de uso vía Cursor
(ver `docs/04-diagnostico-inventario-ia.md`). Para **nuevas** capacidades
(features de producto, no solo asistencia de desarrollo), la recomendación
por defecto de esta matriz es **Anthropic** salvo que haya una razón
técnica concreta para otro — es el proveedor con el que ya existe
gobernanza más madura en este framework (Claude Code como estándar de
`CLAUDE.md`).

## Pendiente

- Costos de referencia reales (no solo relativos) — depende de volumen y
  plan contratado con cada proveedor.
- Ampliar la matriz con nuevos tipos de tarea a medida que aparezcan casos
  de uso reales de producto (ver `docs/07-arquitectura-referencia.md`,
  spike pendiente).
