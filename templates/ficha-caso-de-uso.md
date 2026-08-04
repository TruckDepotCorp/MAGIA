# Ficha de caso de uso de IA

> Plantilla técnica del Sprint 3 (`docs/01-plan-tecnico-fase1.md`). Se
> completa por cada caso de uso nuevo de IA (dev tooling o feature de
> producto) antes de implementarlo, si su clasificación de riesgo resulta
> Medio o Alto (`docs/05-matriz-riesgo.md`). La skill que automatiza y
> valida esta ficha (`skills/ficha-caso-de-uso`) es un entregable del
> Sprint 4 — por ahora se completa a mano con esta plantilla.

## Identificación

- **Nombre del caso de uso:**
- **Repo / feature:**
- **Owner (responsable humano nombrado):**
- **Fecha:**

## Proveedor y patrón

- **Proveedor/modelo usado** (debe estar en la lista de aprobados de
  `claude-md/base.md`):
- **Patrón de integración** (ver `docs/07-arquitectura-referencia.md`):
  Prompting directo / RAG / Agente con herramientas (MCP) / Copiloto
  embebido / Orquestador multi-paso

## Clasificación de riesgo (rúbrica de `docs/05-matriz-riesgo.md`)

- **¿Toca PII?** Sí / No
- **¿Decide o actúa autónomamente sobre datos de un cliente sin revisión
  humana?** Sí / No
- **¿Está expuesto a usuarios/terceros externos?** Sí / No
- **¿Es reversible un error?** Sí / No
- **Nivel de riesgo resultante:** Bajo / Medio / Alto

## Aprobación

- **¿Requiere aprobación del comité de gobernanza?** (obligatorio si Medio
  o Alto — ver `docs/01-plan-tecnico-fase1.md`, roles)
- **Aprobado por:**
- **Fecha de aprobación:**
- **Condiciones o restricciones impuestas** (si aplica):

## Diligencia

- **Dónde vive el prompt/config:** (debe estar versionado como código, ver
  `docs/07-arquitectura-referencia.md` §4)
- **Qué se registra en logs y qué se enmascara por PII:**
- **Golden dataset de evals asociado** (obligatorio si el caso modifica un
  prompt existente, ver `rules/example-ai-features.md`):
- **Nota de transparencia** (si aplica, para documentos que verán terceros):
  "Preparado con asistencia de IA. Revisado y aprobado por: `<responsable>`."

## Estado

- **Estado actual:** Propuesto / En evaluación / Aprobado / En producción /
  Descontinuado
- **Próxima revisión programada:**
