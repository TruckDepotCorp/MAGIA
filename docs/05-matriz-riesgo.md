# Matriz de niveles de riesgo (Sprint 1)

Entregable de la tarea 3 del Sprint 1 (`docs/01-plan-tecnico-fase1.md`):
"Matriz de niveles de riesgo (técnica, no solo conceptual)". Define 3
niveles con criterios concretos y los aplica a ejemplos reales de la
auditoría (`docs/04-diagnostico-inventario-ia.md`) — no es un marco
genérico de la industria.

## Criterios técnicos evaluados

Por cada caso de uso de IA, se evalúan estas 4 preguntas:

1. **¿Toca PII?** (datos personales, financieros o de clientes)
2. **¿Decide o actúa autónomamente sobre datos de un cliente sin revisión
   humana?** (vs. asistencia de desarrollo revisada antes de desplegar)
3. **¿Está expuesto a usuarios/terceros externos**, no solo a empleados
   internos?
4. **¿Es reversible un error?** (control de versiones, rollback, revisión
   humana antes de impactar producción)

## Regla de clasificación

| Nivel | Cuándo aplica |
|---|---|
| **Bajo** | No toca PII, sin autonomía, uso interno, reversible. |
| **Medio** | Toca PII, pero sin autonomía, uso interno, y reversible — el riesgo está mitigado por revisión humana y ausencia de exposición externa. |
| **Alto** | Toca PII **y** además hay al menos uno de: autonomía sin revisión humana, exposición a terceros externos, o error no reversible. |

Cualquier caso Medio o Alto debe pasar por la ficha de diligencia
(`skills/ficha-caso-de-uso`) antes de implementarse, según la regla global
de `claude-md/base.md`. **Nota:** esa Skill todavía no existe — está
planeada como entregable del Sprint 3 (`docs/01-plan-tecnico-fase1.md`).
No se crea ahora para no adelantar contenido de un sprint posterior
mientras el Sprint 1 sigue abierto; queda como deuda pendiente a resolver
retroactivamente para los casos ya clasificados aquí en cuanto la Skill
exista.

## Ejemplos reales (Sprint 1 — auditoría en `docs/04-diagnostico-inventario-ia.md`)

| Caso de uso | ¿PII? | ¿Autonomía sin revisión? | ¿Exposición externa? | ¿Reversible? | Nivel |
|---|---|---|---|---|---|
| **WMS** (Cursor: Anthropic, xAI, OpenAI, Composer) | Sí | No — asistencia de desarrollo, revisión humana antes de deploy | No — uso interno | Sí | **Medio** |
| **HIPERSAP** (Cursor: Anthropic, xAI, OpenAI, Composer) | Sí | No — asistencia de desarrollo, revisión humana antes de deploy | **Sí** — integración con SAP B1 llega a terceros externos (proveedores, auditoría) | Sí | **Alto** |

**Racional de HIPERSAP en Alto vs. WMS en Medio:** ambos comparten los
mismos mitigantes (revisión humana, reversibilidad), pero la exposición de
HIPERSAP a terceros externos vía SAP B1 agrega riesgo reputacional y de
cumplimiento que WMS no tiene al ser puramente interno. Clasificación
confirmada por el comité de gobernanza (José Alonso, Pablo Breganza, Josué
Gamarro), 2026-08-04.

## Pendiente

- Aplicar esta misma rúbrica a cualquier otro caso de uso que se agregue al
  inventario (`docs/04-diagnostico-inventario-ia.md`).
- Crear la ficha de diligencia (`skills/ficha-caso-de-uso`) en el Sprint 3 y
  aplicarla retroactivamente a WMS e HIPERSAP por estar en Medio/Alto.
- Revisar si la rúbrica de 4 criterios cubre casos futuros con matices no
  contemplados aquí (ej. multi-tenant, datos de terceros no personales).

## Nivel de autonomía (NM-1 … NM-4) — agregado en v0.3.0

El criterio 2 de la rúbrica ("decide o actúa autónomamente sin revisión
humana") se gradúa en cuatro niveles, tomados del handoff
(`referencia-spec/SPEC.md` §16.2). Se registran en `magia.config.json`
(`autonomy`) y determinan qué salvaguardas adicionales se instalan
(`docs/11-instalacion-y-perfiles.md` §3). **No cambian la clasificación
Bajo/Medio/Alto de arriba**; la complementan.

| Nivel | Qué hace la IA | Salvaguardas adicionales | Aprobación |
|---|---|---|---|
| **NM-1 Asistente** | Sugiere; la persona ejecuta | Base (Core, `magia-verify`, `magia-data-shield`) | Responsable del repo |
| **NM-2 Copiloto** | Ejecuta acciones reversibles | + `magia-grounding` si hay IA en el producto; `permissions.deny` y hooks activos | Responsable del repo |
| **NM-3 Agente supervisado** | Flujos multi-paso con herramientas | + `magia-red-team`, confirmación humana en acciones irreversibles | Comité (consenso) |
| **NM-4 Agente autónomo** | Sin aprobación por acción | + monitoreo en tiempo real y kill-switch `[por definir]` | Comité + excepción firmada; auditoría mensual |

Los repos hoy clasificados (WMS = Medio, HIPERSAP = Alto) usan IA como
asistente de desarrollo con revisión humana: **NM-1**. `[por definir:
confirmar con el comité al instalar el kit en cada uno.]`
