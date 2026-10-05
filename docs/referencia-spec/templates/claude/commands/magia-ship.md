---
description: Pipeline autónomo MAGIA de intención a PR con Paquete de Evidencia
argument-hint: <intención en una o dos frases>
---
Intención del usuario: $ARGUMENTS

Ejecuta el pipeline autónomo MAGIA (SPEC §27) para {{PROJECT_NAME}} (riesgo {{RISK}}, autonomía {{AUTONOMY}}).

1. Crea el run: `npx magia run "$ARGUMENTS" --until pr` o, si ya existe un run abierto, reanúdalo con `--resume`.
2. Invoca `magia-architect`: consulta el Registro, produce brief, spec, golden set, arquitectura y ADRs.
3. Consulta la tabla de decisiones humanas (SPEC §3.1) para riesgo {{RISK}}. Si la spec o el plan requieren aprobación, presenta un resumen de una pantalla con tu recomendación y DETENTE hasta recibirla. Si no, continúa.
4. Invoca `magia-builder` para descomponer el plan en tareas y lanzar `magia-worker` en paralelo.
5. Integra y ejecuta `magia-fixer` hasta que `npm test`, `npx magia check` y `npx magia eval` estén en verde (máx. 5 iteraciones).
6. Ejecuta `magia-reviewer`, `magia-security` y, si el riesgo es alto o la autonomía NM-3+, `magia-red-teamer`. Resuelve bloqueantes.
7. Invoca `magia-documenter` para generar docs y el Paquete de Evidencia.
8. Abre el PR en la rama `magia/<id>` con el Paquete de Evidencia como descripción.

Escala solo por excepción (SPEC §27.1), agrupando tus preguntas en un único mensaje con opciones y recomendación. Actualiza `docs/magia/runs/<id>/progress.md` después de cada paso.
