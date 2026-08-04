---
name: ficha-caso-de-uso
description: "Usar esta skill para generar y completar la ficha de diligencia de un caso de uso de IA nuevo, antes de empezar a construirlo. Aplica la rúbrica de riesgo de MAGIA y deja explícito si requiere aprobación del comité de gobernanza. Disparar con frases como 'completa la ficha de caso de uso', 'genera la ficha de diligencia para X', o después de que 'elegir-patron-ia' recomendó un patrón y el caso resultó riesgo medio/alto."
owner: "José Alonso"
version: "0.1.0"
---

# Ficha de caso de uso de IA

## Cuándo usar

Antes de implementar cualquier caso de uso de IA nuevo (dev tooling o
feature de producto) que la skill `elegir-patron-ia` o la rúbrica de
`magia-framework/docs/05-matriz-riesgo.md` clasifiquen en riesgo **Medio**
o **Alto**. También al recibir la instrucción directa de completar la
ficha para un caso específico.

## Proceso

1. Reunir los datos de identificación: nombre del caso de uso, repo/feature,
   owner humano nombrado, fecha.
2. Confirmar proveedor/modelo (debe estar en la lista de aprobados del
   `CLAUDE.md` del repo) y el patrón de integración (prompting directo,
   RAG, agente con herramientas/MCP, copiloto embebido, orquestador
   multi-paso — ver `magia-framework/docs/07-arquitectura-referencia.md`).
3. Aplicar la rúbrica de 4 criterios de
   `magia-framework/docs/05-matriz-riesgo.md` (¿PII?, ¿autonomía sin
   revisión?, ¿exposición externa?, ¿reversible?) y calcular el nivel de
   riesgo resultante — no preguntarle al usuario el nivel directamente,
   derivarlo de las respuestas a los 4 criterios.
4. Generar el documento completo usando la plantilla
   `magia-framework/templates/ficha-caso-de-uso.md` (o la copia local en
   `.claude/magia/ficha-caso-de-uso.md` si el repo ya la tiene), con todos
   los campos llenos — usar `[por definir: ...]` donde falte un dato real,
   nunca inventarlo.
5. Si el resultado es Medio o Alto: dejar explícito en el documento que
   **falta la aprobación del comité de gobernanza** antes de implementar —
   no marcar la ficha como aprobada.
6. Guardar el documento en el repo (ej. `.claude/magia/casos/<nombre-del-caso>.md`)
   para que quede versionado junto al código.

## Qué NO hacer

- No aprobar un caso Medio/Alto por cuenta propia — la aprobación es
  siempre humana (comité de gobernanza), nunca de la skill.
- No inventar datos de la empresa (owner, fecha de aprobación, condiciones)
  que no se hayan confirmado.
- No saltarse la rúbrica de riesgo aunque el usuario diga que "obviamente
  es bajo".

## Salida esperada

La ficha completa (o el archivo guardado), el nivel de riesgo derivado con
su justificación según los 4 criterios, y el siguiente paso: "listo para
implementar" (riesgo Bajo) o "pendiente de aprobación del comité"
(Medio/Alto).
