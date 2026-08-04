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

## Estructura

```
magia-framework/
├── README.md
├── CONTEXTO-PARA-CLAUDE-CODE.md
├── CHANGELOG.md
├── VERSION
├── docs/
├── claude-md/base.md
├── rules/
├── skills/
└── templates/
```

## Estado actual

Versión `0.2.0` — Sprint 1 cerrado el 2026-08-04, con un pendiente en la
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

1. Copiar `claude-md/base.md` → `CLAUDE.md` en la raíz del repo. Si el repo
   **ya tiene** un `CLAUDE.md` con documentación técnica propia:
   **fusionar, no reemplazar** (ver el `CLAUDE.md` de HIPERSAP como
   ejemplo real). Completar la sección "Específico de este repo".
2. Copiar las Rules que apliquen de `rules/` → `.claude/rules/` del repo,
   **adaptando el `scope`** a la estructura real (los `scope` de este repo
   son ejemplos genéricos, no rutas literales a copiar sin revisar).
3. Copiar las Skills que apliquen de `skills/` → `.claude/skills/` del repo.
4. Copiar los hooks de `templates/settings-hooks-referencia.json` a
   `.claude/settings.json` si se quiere activar el modo advertencia de
   diligencia — verificar la sintaxis de hooks vigente en la documentación
   oficial de Claude Code antes de confiar en la plantilla.
5. Registrar en el `CLAUDE.md` copiado qué versión de `magia-framework` se
   está usando (tag/release).
