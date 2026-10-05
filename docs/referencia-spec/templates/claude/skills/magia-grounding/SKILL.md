---
name: magia-grounding
description: Exige que toda respuesta generativa de {{PROJECT_NAME}} esté anclada a fuentes corporativas citadas. Úsala al crear o modificar cualquier código que llame a un modelo de lenguaje en rutas de cliente o de decisión ({{LLM_PATHS}}).
magia:
  version: 1.0.0
  template: magia-grounding@1.0.0
  rules: [R1, R4]
  plane: [dev, runtime]
---
# Grounding obligatorio

## Cuándo usar
- Al crear o editar código en {{LLM_PATHS}} que genere texto mostrado a usuarios o usado en decisiones.
- Al agregar una nueva fuente de datos para recuperación (RAG).
- Al modificar prompts de sistema del producto.

## Procedimiento
1. Identifica la fuente autorizada para la pregunta (ver "Fuentes" en `MAGIA.md`). Si no existe, detente y repórtalo; no uses conocimiento libre del modelo.
2. Recupera con `magia.grounding.retrieve(query)`; nunca construyas contexto concatenando datos sin pasar por la guarda.
3. Instruye al modelo a citar `sourceId` por cada afirmación.
4. Valida con `magia.grounding.require(draft, sources)`. Si lanza `MagiaRuleError('R1')`, devuelve el fallback configurado (R4).
5. Agrega o actualiza casos en `evals/golden-set.jsonl` con criterio `grounded`, incluyendo al menos un caso `unknown`.
6. Ejecuta `magia eval --suite grounding` antes de terminar.

## Contratos
```ts
retrieve(query: string, opts?: { topK?: number; sources?: string[] }): Promise<Source[]>
require(answer: Draft, sources: Source[]): GroundedAnswer   // throws MagiaRuleError('R1')
```

## Criterios de éxito
- `grounded` = 100% en `magia eval`.
- Ninguna llamada a LLM en {{LLM_PATHS}} sin `grounding.require` (verificado por `magia check`).

## Modo de falla
- Sin fuentes suficientes → fallback "No tengo información verificada para responder eso. Te comunico con un asesor." + evento `guard.fallback`.
- Nunca "responder igual" sin fuente.

## Ejemplos del proyecto
{{PROJECT_EXAMPLE — el agente instalador escribe aquí un ejemplo usando un archivo real del repo, p. ej. el handler de búsqueda de repuestos}}
