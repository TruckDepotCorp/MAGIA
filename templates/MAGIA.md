<!--
Plantilla de MAGIA.md (contexto de gobernanza del repo). La genera/actualiza
la skill magia-context (la invoca /magia-instalar). Se importa desde
CLAUDE.md con `@MAGIA.md`. Máximo 300 líneas. Completar SOLO con datos
reales; lo desconocido queda como `[por definir: ...]`. Borrar este comentario.
-->
# MAGIA — {{PROJECT_NAME}}

Fuente: magia-framework `{{MAGIA_VERSION}}` · Riesgo **{{RISK}}** · Autonomía **{{AUTONOMY}}** · Perfil `estandar` · Enforcement `{{ENFORCEMENT}}`
Owner humano: {{OWNER}}

## Propósito y dominio
{{una a tres líneas: qué hace el sistema y para quién}}

## Comandos (reales, verificados)
| Acción | Comando |
|---|---|
| Build | `{{BUILD_CMD}}` |
| Pruebas | `{{TEST_CMD}}` |
| Lint | `{{LINT_CMD}}` |
| Evals (si hay IA en el producto) | `{{EVAL_CMD}}` |
| Check MAGIA | `bash .magia/core/scripts/check.sh` |

## Estructura relevante
{{rutas reales y para qué sirven, solo las que importan para trabajar con IA}}

## Rutas críticas (revisión humana línea por línea)
{{rutas: pagos, auth, integraciones externas, datos restringidos…}}

## Datos sensibles
Clasificación y rutas en `.magia/local/data-map.md`; rutas que el agente no
puede leer en `.magia/local/restringido.txt`.
{{resumen: qué clases de datos hay y dónde viven}}

## Uso de IA en este repo
- Como asistente de desarrollo: {{herramientas y modelos de la lista aprobada}}
- IA dentro del producto (`aiInProduct`): {{no / sí — patrón y ruta de prompts}}
- Fuentes autorizadas para respuestas (R1): {{o "no aplica"}}

## Reglas y Skills activas
- Reglas Core R1–R9 y Constitución: `.magia/core/` (inmutables).
- Rules por ruta: `.claude/rules/` — {{lista}}
- Skills: `.claude/skills/` — {{lista}}
- Agentes: `.claude/agents/magia-*` · Comandos: `/magia-*`

## Protocolo de trabajo
1. Tarea no trivial (más de un archivo, cambia un contrato, toca ruta crítica o >30 min): **modo plan**, plan en `docs/magia/plans/`.
2. Tras 2 correcciones fallidas sobre el mismo enfoque: rebobinar y replantear.
3. Antes de dar algo por terminado: skill `magia-verify`.
4. Antes de desplegar: `/magia-gate` y skill `checklist-pre-deploy`.

## Excepciones sugeridas para el comité
{{ninguna / lista}}

## Pendiente
{{lo que no se pudo confirmar al instalar}}
