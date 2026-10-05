---
name: magia-evals
description: "Usar al crear o modificar prompts, lógica de IA o configuración de modelo de un producto, o al agregar casos al golden set. Mantiene el golden set, las rúbricas y el control de regresión. Disparar con frases como 'agrega un caso de prueba', 'cambié el prompt', 'corre los evals', 'armar el golden dataset', 'hay una regresión', o cuando el repo tiene aiInProduct=true y se toca una ruta de prompts."
owner: "José Alonso"
version: "0.1.0"
rules: [R1, R4, R7]
assumption: "Un cambio de prompt o de modelo puede degradar la calidad sin que nadie lo note"
reviewBy: "al cambiar de modelo aprobado"
---

# Evals del producto

Aplica solo a repos con `aiInProduct: true` (el software llama a un modelo en
producción). Estándar completo: `docs/08-estandares-desarrollo.md`.
Evals antes que código: el golden set se escribe con la spec, no después.

## Cuándo usar
- Se crea o modifica un prompt (`prompts/**` o la ruta que declare `MAGIA.md`).
- Cambia el modelo, el proveedor o la temperatura.
- Se corrige una falla real: toda falla se convierte en un caso nuevo.

## Procedimiento
1. **Golden set:** `evals/golden-set.jsonl`, una línea JSON por caso
   (formato en `templates/evals/golden-set.example.jsonl`). Mínimos por riesgo
   (propuestos, pendientes de ratificación del comité): 20 casos en bajo, 50
   en medio, 100 en alto; con ≥ 10 % / 20 % / 30 % de casos `unknown` +
   `adversarial`. Basar los casos en datos reales **anonimizados**
   (`magia-data-shield`), nunca en datos crudos de clientes.
2. **Rúbricas:** `evals/rubrics/*.md`, derivadas de la Constitución. Incluir
   criterios contra las huellas del modelo: complacencia (ceder ante una
   corrección incorrecta del usuario), verbosidad, exceso de cautela
   (negarse a algo válido) y confianza mal calibrada.
3. **Calificar** con código determinista primero (formato, esquema, campos,
   regex); modelo-juez con rúbrica solo cuando no alcanza, con un prompt
   aislado del modelo evaluado; una persona calibra al juez periódicamente.
4. **Ejecutar** `commands.eval` de `MAGIA.md` y comparar con la versión
   anterior. Regresión permitida: ≤ 2 pts bajo, ≤ 1 pt medio, 0 alto
   (propuesto). Evaluar el **resultado final**, no el camino exacto.
5. **Etiquetar cada falla** con `failureProperty`: `prediccion`,
   `conocimiento`, `memoria` o `direccionabilidad` (y `collision` si chocan
   dos). Corrección por propiedad:

| Propiedad | Señal | Corrección |
|---|---|---|
| Conocimiento | Datos inventados u obsoletos | `magia-grounding`: fuentes citadas, nunca conocimiento libre |
| Memoria de trabajo | Olvida instrucciones en tareas largas | Recortar contexto, notas, subagentes |
| Direccionabilidad | Ignora formato o restricciones | Plantilla 3P, ejemplos, salida estructurada |
| Predicción | Plausible pero inexacto | Verificación determinista, citas, permitir "no sé" (R4) |

## Contratos
Caso de eval: `id`, `type` (`happy|edge|unknown|adversarial`), `input`,
`context`, `expected`, `mustNot`, `criteria[]`, `tags[]`; opcionales
`kind` (`capacidad|regresion`), `trials`, `metric` (`pass@k|pass^k`) y
`grader` (`codigo|modelo|humano`). Flujos de cliente o riesgo alto usan
`pass^k` (éxito en todos los intentos).

## Criterios de éxito
- Golden set ≥ mínimo de su riesgo y con casos `unknown` y `adversarial`.
- Evals en verde y sin regresión; `check.sh` reporta el conteo.

## Modo de falla
- Eval bajo umbral → no mergear; corregir causa raíz (`magia-fixer`).
- Nunca borrar ni debilitar un caso para que el eval pase.
- Sin golden set real todavía → declararlo como pendiente; no simularlo.

## Ejemplos del repo
`[por definir: el instalador agrega aquí un ejemplo con un prompt y un caso reales del repo destino]`
