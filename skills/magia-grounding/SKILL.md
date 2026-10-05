---
name: magia-grounding
description: "Usar al crear o modificar código que llama a un modelo de lenguaje y muestra el resultado a usuarios o lo usa en decisiones (RAG, asistentes, copilotos). Exige que toda respuesta esté anclada a fuentes citadas y que exista fallback cuando no hay fuente. Disparar con frases como 'agrega un asistente', 'responde con la base de conocimiento', 'integra el modelo en esta pantalla', 'cita las fuentes', o al tocar prompts de sistema del producto."
owner: "José Alonso"
version: "0.1.0"
rules: [R1, R4, R7]
assumption: "El modelo puede inventar con seguridad datos que no están en sus fuentes"
reviewBy: "al cambiar de modelo aprobado"
---

# Grounding obligatorio

Aplica a repos con `aiInProduct: true` y riesgo ≥ medio o autonomía ≥ NM-2.
Patrón base: `docs/07-arquitectura-referencia.md` (RAG / Copiloto embebido).

## Cuándo usar
- Se crea o edita código que genera texto mostrado a usuarios o usado en
  decisiones.
- Se agrega una fuente de datos para recuperación (RAG).
- Se modifica un prompt de sistema del producto.

## Procedimiento
1. **Fuente autorizada:** identificar dónde vive la verdad para la pregunta
   (`MAGIA.md` § Fuentes). Si no existe, detenerse y reportarlo; no usar
   conocimiento libre del modelo.
2. **Recuperar** solo desde esa fuente; nunca concatenar datos al contexto
   sin pasar por la capa de recuperación del repo.
3. **Citar:** instruir al modelo a citar el identificador de la fuente por
   cada afirmación; usar la función de citas de la API cuando esté disponible.
4. **Validar** que cada cita corresponda a un fragmento recuperado real. Si
   no hay citas válidas → fallback (R4).
5. **Prompt:** prefijo estático primero (rol, reglas, ejemplos), parte
   dinámica al final; documentos y entrada del usuario dentro de etiquetas de
   datos, marcados como no instrucciones. Plantilla:
   `templates/prompt-template.example.md`.
6. **Divulgación (R7):** si el usuario es externo, identificar la respuesta
   como asistida por IA.
7. **Evals:** agregar casos `grounded` y al menos un `unknown` al golden
   set (`magia-evals`) y correrlos antes de terminar.

## Criterios de éxito
- `grounded` = 100 % en los evals de riesgo medio/alto.
- Ninguna llamada al modelo en rutas de cliente sin validación de citas
  (lo revisa `magia-reviewer`).

## Modo de falla
- Sin fuentes suficientes → mensaje de incertidumbre y escalamiento a una
  persona, nunca una respuesta "de todos modos".
- Recuperación mala (la fuente existe pero no se encuentra) → medir
  recall@k por separado de la calidad de generación y corregir la
  recuperación, no el prompt.

## Ejemplos del repo
`[por definir: el instalador agrega aquí un ejemplo con un handler real del repo destino]`
