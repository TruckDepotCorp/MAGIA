---
description: Ejecuta los evals del producto y resume resultados, regresiones y fallas por propiedad
---
Invoca el agente `magia-evaluator` (independiente del generador) y aplica la skill `magia-evals`. Ejecuta `commands.eval` de `MAGIA.md` (si dice `[por definir]`, repórtalo como pendiente y no simules resultados). Compara con la ejecución anterior y con los umbrales del riesgo del repo. Resume: casos totales por tipo, puntajes por criterio, regresiones, y las fallas etiquetadas con `failureProperty` junto a la corrección sugerida. Si hay fallas, ofrece invocar `magia-fixer`; nunca relajes umbrales ni casos.
