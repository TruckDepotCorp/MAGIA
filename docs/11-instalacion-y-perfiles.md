# Instalación de MAGIA, capas y perfiles

Cómo un repo de producto pasa de "sin MAGIA" a tener gobernanza ejecutable
en una sola sesión de Claude Code. Incorpora el paquete de handoff
(`docs/referencia-spec/`, ver su `LEEME-ESTADO.md`) adaptado a lo que este
repo ya decidió. Es un **kit** (Markdown, Skills, agentes, comandos y
scripts bash), no un paquete npm: no hay CLI ni runtime SDK todavía
(`docs/13-roadmap-motor-de-valor.md`).

## 1. Instalar (3 pasos)

1. Clonar `magia-framework` en la máquina (una vez) y abrir Claude Code en el
   repo de producto.
2. Pedirle a Claude: *"Lee `<ruta>/commands/magia-instalar.md` y ejecútalo
   con `<ruta>`"* (`<ruta>` = el clon de `magia-framework`). Es el agente
   instalador: escanea el repo, propone riesgo y autonomía con la rúbrica de
   `docs/05-matriz-riesgo.md`, hace **una** ronda de preguntas y genera todo
   en la rama `chore/adopt-magia-<versión>` (sin push).
3. Revisar el informe final, hacer commit y proteger la rama principal
   exigiendo el check `magia-gate` (Regla R5; no se puede automatizar).

Tras la instalación, `/magia-instalar` queda disponible en el repo para
actualizaciones: cada repo decide cuándo re-copiar una versión nueva (no hay
propagación automática, `docs/03-gobernanza-repositorio.md`).

## 2. Qué queda instalado

```
<repo>/
├── CLAUDE.md                  fusionado; importa @MAGIA.md (≤150 líneas recomendado)
├── MAGIA.md                   contexto de gobernanza del repo (≤300 líneas) — GENERADA
├── magia.config.json          riesgo, autonomía, aiInProduct, proveedores, comandos, enforcement
├── magia.lock                 SHA-256 de .magia/core/ (Regla R8)
├── .claude/
│   ├── settings.json          permissions.deny + hooks (fusionado, nunca reemplazado)
│   ├── skills/                Skills requeridas según §3 — GENERADA (ejemplos reales del repo)
│   ├── agents/magia-*.md      planner, reviewer, security, fixer, documenter, evaluator
│   ├── commands/magia-*.md    instalar, brief, spec, plan, review, eval, gate
│   └── rules/                 Rules por ruta con paths reales del repo
├── .magia/
│   ├── core/                  Constitución, R1–R9, proveedores, hooks, scripts — INMUTABLE
│   ├── local/                 restringido.txt, data-map.md, mcp-allowlist.txt, deploy-patterns.txt — del equipo
│   ├── exceptions/            EXC-aaaa-nnn.md firmadas por el comité
│   └── reports/               verify-*.md, gate.json (ignorado por git)
├── evals/                     solo si aiInProduct: golden-set.jsonl, rubrics/
├── docs/magia/                brief.md, spec.md, delegation.md, plans/
└── .github/                   workflows/magia-gate.yml, PULL_REQUEST_TEMPLATE/ia.md
```

**Tres capas (precedencia Core > Local > Generada):**

| Capa | Dónde | Quién la escribe | ¿Editable? |
|---|---|---|---|
| Core | `.magia/core/`, `magia.lock` | Se copia de este repo | No: hooks + `permissions.deny` + `check.sh` lo impiden (R8) |
| Local | `.magia/local/`, `.claude/rules/` | El equipo del repo | Sí, pero solo **agrega** restricciones |
| Generada | `MAGIA.md`, Skills, agentes, comandos | El agente instalador | Solo regenerando; no inventa datos: `[por definir]` |

## 3. Qué se instala según riesgo, autonomía y producto

`check.sh` verifica esta misma tabla. Riesgo según `docs/05-matriz-riesgo.md`;
autonomía NM-1…NM-4 según su sección de autonomía.

| Condición | Skills / artefactos |
|---|---|
| Todo repo | `magia-context`, `magia-verify`, `magia-data-shield`, `magia-diligencia`, `checklist-pre-deploy`; Core completo; los 6 agentes y 7 comandos |
| Riesgo medio o alto | + `ficha-caso-de-uso` |
| `aiInProduct: true` | + `elegir-patron-ia`, `magia-evals`, `evals/` |
| `aiInProduct` y (riesgo ≥ medio o NM ≥ 2) | + `magia-grounding` |
| `aiInProduct` y riesgo alto, **o** NM ≥ 3 | + `magia-red-team` |
| Áreas con PII de terceros / integraciones externas | + Rules por ruta (`rules/example-*`) con paths reales |

Subir de nivel nunca reduce salvaguardas. Bajar el riesgo calculado requiere
una excepción firmada.

## 4. Decisiones de adaptación (handoff → este repo)

| Tema | Handoff | Aquí | Por qué |
|---|---|---|---|
| Instalación | CLI `magia init` (npm) | Kit + `/magia-instalar` | Este repo no tiene código ni build; el agente instalador del handoff se conserva como comando |
| Enforcement | Todas las Rules bloqueantes | Híbrido: duras bloquean; blandas avisan hasta `enforcement: bloqueo` | Sprint 4 decidió advertencia primero para evitar rechazo al marco |
| Proveedores (R3) | Modelos Claude vía API corporativa | Los 4 aprobados por el comité: Anthropic, xAI, OpenAI, Cursor | Decisión del comité 2026-08-04 (`docs/04`) |
| Riesgo | `max(área, datos, cliente)` + presets por área | Rúbrica de 4 criterios de `docs/05`; presets por área `[por definir]` | WMS = Medio y HIPERSAP = Alto ya están confirmados por el comité con esa rúbrica |
| Evals y Reglas R1/R4/R7 | Siempre | Solo `aiInProduct: true` | Los repos reales usan IA como asistente de desarrollo, no en producción; evitar exigir golden sets sin sentido |
| `magia check`/`gate` | CLI | `core/scripts/check.sh` (bash) | Mismo contrato (exit 0/2) sin dependencia de Node; corre en Git Bash y en CI |
| `Stop` bloqueante | Siempre | Solo en modo bloqueo, máx. 2 veces por sesión | `stop_hook_active` no está confirmado en la documentación oficial; guarda anti-bucle propia |
| Distribución | Plugin + marketplace corporativo | Copia versionada (modelo vigente) | El esquema de `marketplace.json` no está confirmado; ver `docs/13` |
| Rules por ruta | Campo `scope` | `paths:` (más `scope` por compatibilidad) | La documentación oficial usa `paths:`; `scope` solo no carga por ruta |
| Umbrales de evals | "Valores iniciales propuestos" | Se mantienen como **propuestos**, pendientes de ratificar | Decisión D7 abierta del handoff |

## 5. Perfiles del handoff y su estado

| Perfil | Documento | Estado en este repo |
|---|---|---|
| `estandar` | SPEC §1–§25 | **Instalable hoy** (este kit) |
| `diario` | `referencia-spec/modules/AI-FLUENCY-OPERATIONS.md` | Plantillas listas: `templates/diario/` (contexto de área, ficha de workflow, política de uso). Adopción por áreas = capa humana de `docs/02-valor-y-adopcion.md` |
| `flow` | `referencia-spec/modules/FLOW.md` | Roadmap (`docs/13`) |
| `forge` | `referencia-spec/modules/FORGE.md` | Roadmap (`docs/13`) |

## 6. Qué está validado y qué no

- **Probado a nivel de script** (repo temporal simulado, 2026-10-05): los
  hooks (bloqueo duro, advertencia, modo bloqueo, rutas Windows), `check.sh`
  (config, lock, Core alterado, proveedor no aprobado, Skill faltante,
  excepción vencida, gate atado al commit, hash estable con CRLF).
- **No probado todavía:** dentro de una sesión real de Claude Code
  end-to-end, el instalador sobre un repo real, el workflow de CI en GitHub,
  ni el onboarding del equipo. Se cierra con el primer ciclo de uso del
  piloto (`docs/01-plan-tecnico-fase1.md`, Sprint 4).
