---
description: Escribe docs/magia/spec.md con criterios de éxito verificables y, si hay IA en el producto, el golden set inicial
argument-hint: <iniciativa o ruta del brief>
---
Iniciativa: $ARGUMENTS

Parte de `docs/magia/brief.md`. Escribe `docs/magia/spec.md` con: comportamiento esperado, **criterios de aceptación ejecutables** (cada uno con la prueba que lo demostrará, escrita antes que el código), umbrales de calidad (mínimos de la skill `magia-evals` si hay IA), restricciones (Reglas Core aplicables, datos que no se pueden usar) y fuera de alcance.

Si `aiInProduct` es true, genera casos en `evals/golden-set.jsonl` (formato `templates/evals/golden-set.example.jsonl`) con la proporción de `unknown` y `adversarial` que exige el riesgo, usando datos **sintéticos o anonimizados**. En riesgo alto, la persona debe aprobar la spec antes de planear. Marca como `[por definir]` todo dato de la empresa que no tengas.
