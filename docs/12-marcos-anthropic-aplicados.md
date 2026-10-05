# Marcos de Anthropic aplicados a MAGIA

Los 12 marcos y 4 cursos del handoff (`referencia-spec/modules/ANTHROPIC-FRAMEWORKS.md`
y módulos de curso) convertidos en requisitos. Esta tabla dice **dónde vive
cada uno hoy** en el kit y qué queda pendiente. MAGIA usa estos marcos como
referencia pública; no está afiliado a Anthropic.

| Marco | Requisito clave | Dónde está hoy | Pendiente |
|---|---|---|---|
| AF1/AF14 · 4D + 3 modos | Delegación explícita (qué hace la IA, qué decide una persona), Descripción 3P, Diligencia | `templates/plan-de-delegacion.md`, `templates/descripcion-3p.md`, `/magia-brief`, `docs/00` | Validar `mode` por tarea en `check.sh` |
| AF2 · 4 propiedades | Toda falla etiquetada (`failureProperty`), manual de corrección, rúbricas anti-complacencia | Skill `magia-evals`, `templates/rubrics/rubrica-base.md` | Reporte de distribución en un `audit` |
| AF3 · Builders | Pruebas de aceptación antes del código; checklist de código IA; rúbrica de UX | `/magia-spec`, `magia-verify` (checklist), `magia-reviewer`, `templates/rubrics/ux.md` | — |
| AF4 · Individuo → Equipo → Organización | Ruta de formación por rol, plan de 30 días | `templates/adopcion-30-dias.md`; ruta por rol en `referencia-spec/modules/ANTHROPIC-FRAMEWORKS.md` AF4 | Certificar owners antes de aprobar gates; `[por definir: quién imparte]` |
| AF5 · Context engineering | `MAGIA.md` ≤300, `CLAUDE.md` ≤150, procedimientos largos en Skills, compactación dirigida, subagentes con contexto limpio | `check.sh`, Skill `magia-context`, agentes | Presupuesto de contexto medido por run |
| AF6 · Harness de larga duración | `features.json`, `init.sh`, `progress.md`, una funcionalidad por sesión | `magia-fixer` registra en `progress.md`; resto en roadmap | Pipeline autónomo (`docs/13`) |
| AF7 · Las suposiciones caducan | `assumption` y `reviewBy` en cada Skill; ablación con cada modelo | Frontmatter de las Skills nuevas | Ablación (`magia frontier`) |
| AF8 · Diseño de herramientas | Pocas, con namespace, errores accionables, `tool-eval` | Estándar MCP en `docs/07` | Tool-eval |
| AF9 · Evals de agentes | Suites capacidad/regresión, `pass^k` en cliente y riesgo alto, evaluar resultado | Skill `magia-evals`, `magia-red-team`, agente `magia-evaluator` | Ejecutor de evals (no existe framework aún, `docs/08`) |
| AF10 · Sandbox y permisos | Permisos declarativos; NM-2+ con sandbox | `permissions.deny` + hooks; `check.sh` valida el modo de permiso por autonomía (abajo) | Sandbox declarativo `.magia/local/permissions.json` |
| AF11 · Code execution con MCP | Carga diferida (>10 herramientas), datos intermedios fuera del contexto | Mención en estándar MCP | Implementación |
| AF12 · Multiagente | Instrucciones con 3P, resultados por archivo, multiagente solo si paga | `magia-planner` (justifica multiagente); `check.sh` valida `mode` y verificación en `delegation.md` | Orquestador/worker |
| AF13 · Claude Code in Action | Modo plan, verificación, gates sobre resultados reales, rutinas, plugin | `magia-verify`, hook `Stop`, `/magia-plan`; modo plan en `MAGIA.md` | Rutinas programadas, plugin (revisión automática de PRs: `templates/ci-revision-pr.yml`, opcional) |
| AF15 · Claude API | Plantillas versionadas con XML y prefijo estático, citas, caché, `max_tokens` explícito, RAG híbrido | `templates/prompt-template.example.md`, Skill `magia-grounding`, `docs/07` | Cliente corporativo (runtime SDK) |
| AF16 · Small Businesses (MAGIA Diario) | Política de uso de una página, contexto de área, ficha de workflow, matriz de datos de clientes | `templates/diario/`, Skill `magia-data-shield` | Despliegue por áreas (capa humana, `docs/02`) |

## Modo de permiso por autonomía (AF13/AF10)

Valores de `permissions.defaultMode` verificados en la documentación oficial
(2026-10-05): `default`, `acceptEdits`, `plan`, `auto`, `bypassPermissions`.

| Situación | Modo recomendado | Condición |
|---|---|---|
| Exploración y planificación | `plan` | Siempre al inicio de tareas no triviales |
| NM-1 Asistente | `default` | — |
| NM-2 Copiloto | `acceptEdits` | Solo con `permissions.deny` y hooks del Core activos |
| NM-3 Agente supervisado | `acceptEdits` + allowlist de comandos | + confirmación humana en irreversibles |
| `bypassPermissions` | **No usar** en repos de producto | Solo contenedor aislado sin credenciales (roadmap) |

`check.sh` valida este modo: `bypassPermissions`/`dontAsk` es error; `acceptEdits` y `auto` por encima de la autonomía del repo son aviso (error en `enforcement: bloqueo`).
