---
name: elegir-patron-ia
description: "Usar esta skill cuando el equipo necesite decidir qué patrón de integración de IA aplicar a un caso de uso nuevo (prompting directo, RAG, agente con herramientas/MCP, copiloto embebido, orquestador multi-paso). Aplica la matriz de decisión del catálogo de capacidades de MAGIA. Disparar con frases como 'qué patrón de IA uso para X', 'cómo integro IA en esta feature', o al iniciar la ficha de un caso de uso nuevo."
owner: "[por definir]"
version: "0.1.0"
---

# Elegir patrón de integración de IA

## Cuándo usar

Al iniciar cualquier caso de uso nuevo que involucre IA, antes de escribir
código — para decidir el patrón correcto según la matriz de MAGIA
(`magia-framework/docs/01-plan-tecnico-fase1.md`, Sprint 2 y 3).

## Proceso

1. Preguntar (si no está claro): ¿qué tipo de tarea es? (clasificación
   simple, generación de código, análisis largo sobre documentos propios,
   acción autónoma multi-paso, chat conversacional con contexto de sesión).
2. Cruzar contra la matriz de decisión del catálogo de capacidades
   (`magia-framework/docs/` — pendiente de completar en el Sprint 3 con
   datos reales de la empresa).
3. Verificar el nivel de riesgo del caso de uso (ver matriz de riesgo,
   `docs/00-plan-metodologico-4D.md`). Si es medio/alto, exigir que se
   complete la ficha de caso de uso (`skills/ficha-caso-de-uso`, pendiente
   de crear) antes de continuar.
4. Proponer el patrón recomendado con una justificación breve (no solo el
   nombre del patrón) y las alternativas descartadas y por qué.
5. Si el caso de uso no encaja claramente en ningún patrón del catálogo,
   escalar al arquitecto de IA en vez de improvisar uno nuevo.

## Qué NO hacer

- No recomendar un patrón "de moda" sin que haya un caso de uso real detrás.
- No saltarse el paso de nivel de riesgo aunque el equipo tenga prisa.
- No inventar un patrón nuevo sin registrarlo en el catálogo de capacidades.

## Salida esperada

Un resumen corto: patrón recomendado, nivel de riesgo, y siguiente paso
(ficha de caso de uso, o construir directo si el riesgo es bajo).
