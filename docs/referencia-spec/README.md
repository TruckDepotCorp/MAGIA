# MAGIA — Paquete de handoff para Claude Code

**Marco de Arquitectura y Gobernanza de Inteligencia Artificial** · Truck Depot Corporation · v1.0 · Confidencial

## Qué es este paquete
La especificación ejecutable para construir MAGIA: un paquete instalable (`@truckdepot/magia`) que, al instalarse en cualquier repositorio de la corporación, genera con IA las Skills, Rules, subagentes y contexto del proyecto, y hace cumplir el estándar corporativo de calidad, seguridad y gobierno de IA mediante hooks, CI y un SDK de runtime.

## Dos motores
- **Motor de Valor** (SPEC §26–32): la IA especifica, construye, prueba, documenta y mejora; el humano decide qué y aprueba con evidencia.
- **Motor de Gobierno** (SPEC §7–22): Rules, evals, hooks y gates que hacen seguro delegar.

## Tres perfiles
`diario` (todo colaborador) · `flow` (áreas administrativas) · `estandar` · `forge` (software a gran escala, prioridad). Mismas Rules Core en todos; cambia la ceremonia y la profundidad.

## Contenido
| Archivo | Uso |
|---|---|
| `SPEC.md` | Especificación técnica normativa. **Fuente de verdad.** |
| `modules/FORGE.md` | Módulo de ingeniería de software a gran escala (prioridad) |
| `modules/AI-FLUENCY-OPERATIONS.md` | Curso AI Fluency for Small Businesses aplicado: nivel MAGIA Diario para todo colaborador |
| `templates/diario/` | Contexto de Área, Ficha de Workflow y Política de Uso de IA |
| `modules/CLAUDE-API.md` | Curso Building with the Claude API aplicado: estándar de construcción de productos IA y diseño del runtime |
| `templates/runtime/prompt-template.example.md` | Plantilla de prompt versionada con XML y caché |
| `modules/AI-FLUENCY.md` | Curso AI Fluency aplicado: 4 adverbios, 3 modos, 4D en profundidad |
| `templates/plan-de-delegacion.md` | Plan de Delegación (problema, plataforma, tareas) |
| `templates/declaracion-diligencia.md` | Declaración de Diligencia por entregable |
| `modules/CLAUDE-CODE-IN-ACTION.md` | Curso Claude Code in Action aplicado: protocolo de sesión, superficies de instrucción, rutinas, verificación y plugins |
| `templates/claude/skills/magia-verify/SKILL.md` | Skill de verificación con evidencia |
| `templates/plugin/` | Estructura de plugins MAGIA y marketplace corporativo |
| `modules/ANTHROPIC-FRAMEWORKS.md` | 12 marcos de Anthropic convertidos en requisitos (AF1–AF12) |
| `templates/descripcion-magia.md` | Plantilla de Descripción (4D) |
| `templates/adopcion-30-dias.md` | Plan de adopción de 30 días por área |
| `modules/FLOW.md` | Módulo para áreas administrativas sin grandes desarrollos |
| `templates/forge/forge-planner.md` | Subagente planificador en olas (Forge) |
| `templates/flow/ficha-de-proceso.md` | Intake de procesos administrativos (Flow) |
| `templates/installer-prompt.md` | Prompt del agente instalador (sección 8 del SPEC) |
| `templates/CONSTITUCION.md` | Constitución MAGIA (Core, inmutable) |
| `templates/magia.config.schema.json` | JSON Schema de configuración |
| `templates/claude/settings.json` | Hooks y permisos de Claude Code |
| `templates/claude/skills/magia-grounding/SKILL.md` | Ejemplo de Skill con formato obligatorio |
| `templates/claude/agents/magia-reviewer.md` | Subagente revisor (Motor de Gobierno) |
| `templates/claude/agents/magia-architect.md` | Subagente arquitecto (Motor de Valor) |
| `templates/claude/agents/magia-fixer.md` | Subagente de bucle autocorrectivo |
| `templates/claude/commands/magia-ship.md` | Pipeline autónomo de intención a PR |
| `templates/ci/magia-gate.yml` | Workflow de CI |
| `templates/evals/golden-set.example.jsonl` | Formato de casos de evaluación |

El documento ejecutivo para Directorio y gerencias es `MAGIA - Marco de Gobernanza IA v2.dc.html` (fuera de esta carpeta).

## Cómo empezar en Claude Code
```text
1. Crea el repo truckdepot/magia y copia esta carpeta en docs/spec/.
2. En Claude Code:
   "Lee docs/spec/README.md y docs/spec/SPEC.md completos.
    Confirma conmigo las decisiones abiertas de la sección 25.
    Luego planifica el hito M0 (sección 23), muéstrame el plan y espera aprobación."
3. Repite por hito (M0 → M6). No avances sin cumplir los criterios de aceptación.
```

## Reglas para el agente que implemente
- La SPEC es normativa. Si algo es ambiguo, pregunta; no inventes.
- Las plantillas de `templates/` se copian a `packages/core/` tal cual (salvo `{{variables}}`).
- TDD: tests primero en cada hito.
- Prioridad: **calidad → seguridad → desempeño → IA avanzada**. Nunca sacrifiques una anterior por una posterior.
- Toda copy de usuario en español, directa, sin emoji.
