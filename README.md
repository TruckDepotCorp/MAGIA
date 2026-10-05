# magia-framework

**M**arco de **A**rquitectura y **G**obernanza de **I**nteligencia **A**rtificial.

Fuente de verdad del marco de gobernanza y arquitectura de IA para
desarrollo de software de la empresa. Este repo versiona los documentos,
el `CLAUDE.md` base y las Skills/Rules que los equipos de producto adoptan
en sus propios repos.

## Empezar aquí

1. **`CONTEXTO-PARA-CLAUDE-CODE.md`** — si vas a seguir este proyecto con
   Claude Code, empieza por ese archivo. Resume todo lo trabajado hasta
   ahora y qué falta.
2. **`docs/00-plan-metodologico-4D.md`** — cómo se está construyendo MAGIA
   (metodología de colaboración con IA, roles, checklist de calidad).
3. **`docs/01-plan-tecnico-fase1.md`** — plan técnico detallado de las
   8 semanas de construcción (4 sprints de 2 semanas).
4. **`docs/02-valor-y-adopcion.md`** — la capa de negocio/adopción que
   corre en paralelo al framework técnico.
5. **`docs/03-gobernanza-repositorio.md`** — cómo se versiona y distribuye
   este repo a los repos de producto.
6. **`docs/04-diagnostico-inventario-ia.md`** — inventario real de casos de
   uso de IA (Sprint 1).
7. **`docs/05-matriz-riesgo.md`** — matriz de niveles de riesgo (Sprint 1),
   con WMS e HIPERSAP como primeros ejemplos reales clasificados.
8. **`docs/06-stack-tecnico.md`** — levantamiento de stack técnico
   (Sprint 1): GitHub, multi-repo, GitHub Actions, Azure, .NET/C#.
9. **`docs/07-arquitectura-referencia.md`** — estándar de MAGIA para
   integrar IA en productos propios (Sprint 2): patrones priorizados,
   estándar de MCP, versionado de prompts, logging/PII.
10. **`docs/08-estandares-desarrollo.md`** — guía de prompting, estándar
    de testing/evals y pipeline CI/CD de referencia (Sprint 3).
11. **`docs/09-catalogo-capacidades.md`** — matriz tarea → modelo/
    herramienta → riesgo → costo relativo (Sprint 3).
12. **`docs/10-resumen-ejecutivo-gerencia.md`** — resumen para Gerencia:
    qué impacto y potencial tiene MAGIA, sin detalle técnico ni nombres de
    proyecto.
13. **`docs/11-instalacion-y-perfiles.md`** — cómo se instala MAGIA en un
    repo (`/magia-instalar`), capas Core/Local/Generada, qué se instala
    según riesgo y autonomía, y decisiones de adaptación del handoff.
14. **`docs/12-marcos-anthropic-aplicados.md`** — marcos de Anthropic
    convertidos en requisitos y dónde vive cada uno.
15. **`docs/13-roadmap-motor-de-valor.md`** — lo definido en el handoff que
    aún no se instala (pipeline autónomo, Registro, Flow, Forge, runtime).

## Estructura

```
magia-framework/
├── README.md
├── CONTEXTO-PARA-CLAUDE-CODE.md
├── CHANGELOG.md
├── VERSION
├── docs/                 (incluye referencia-spec/: handoff como diseño objetivo)
├── claude-md/base.md
├── core/                 Constitución, Reglas R1–R9, hooks, scripts (se instala inmutable)
├── rules/                Rules por ruta de ejemplo
├── skills/               elegir-patron-ia, ficha-caso-de-uso, checklist-pre-deploy, magia-*
├── agents/               magia-planner, -reviewer, -security, -fixer, -documenter, -evaluator
├── commands/             /magia-instalar, -brief, -spec, -plan, -review, -eval, -gate
└── templates/
```

## Estado actual

Versión `0.2.0` (v0.3.0 en [Unreleased]: kit instalable + Core R1–R9, ver `CHANGELOG.md`) — Sprint 1 cerrado el 2026-08-04, con un pendiente en la
capa de valor (paralela, no bloqueante — ver
`docs/02-valor-y-adopcion.md`). Sprints 2, 3 y 4 avanzados en paralelo:
estándar de arquitectura, estándares de desarrollo, catálogo de
capacidades, 3 Skills, 3 Rules de ejemplo, y hooks básicos de referencia
(modo advertencia). **HIPERSAP** es el primer repo piloto (informal) —
`CLAUDE.md` fusionado, Skill, y **2 Rules + hooks con rutas reales**
instaladas (integración SAP B1, PII de empleados vía BioTime/Humand). Pendiente real (no
simulable): spike técnico, golden dataset de evals, onboarding del equipo
piloto, y primer ciclo de uso real. Ver `CHANGELOG.md` para el detalle
completo.

## Cómo adoptar MAGIA en un repo de producto

**Camino rápido (recomendado):** clonar este repo y, desde Claude Code en el
repo de producto, pedir: *"Lee `<ruta>/commands/magia-instalar.md` y
ejecútalo con `<ruta>`"*. El agente instalador escanea el repo, clasifica
el riesgo con la rúbrica de `docs/05`, hace una ronda de preguntas y genera
en una rama (sin push): `CLAUDE.md` fusionado + `MAGIA.md`,
`magia.config.json`, Core inmutable en `.magia/core/` con `magia.lock`,
Skills/agentes/comandos adaptados al código real, Rules con rutas reales,
hooks y permisos en `.claude/settings.json`, y el workflow `magia-gate`.
Detalle y límites: `docs/11-instalacion-y-perfiles.md`.

**Camino manual:** copiar `claude-md/base.md` → `CLAUDE.md` (fusionar, no
reemplazar), `core/` → `.magia/core/` (y `bash .magia/core/scripts/check.sh lock`),
las Skills/agentes/comandos que apliquen → `.claude/`, las Rules con su
`paths:` adaptado, y `templates/settings-hooks-referencia.json` fusionado
en `.claude/settings.json`. Agregar a `.gitattributes`: `*.sh text eol=lf`.

En ambos casos: registrar la versión de `magia-framework` usada
(`magia.config.json`), proteger la rama principal exigiendo el check
`magia-gate`, y revisar que los hooks funcionen en una sesión real antes de
subir a `bloqueo`.
