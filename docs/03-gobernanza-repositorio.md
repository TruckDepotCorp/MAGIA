# Gobernanza del repositorio `magia-framework`

## Decisión de arquitectura

Este repositorio en GitHub **es la fuente de verdad** de MAGIA — documentos,
`CLAUDE.md` base, Rules y Skills. No hay una app aparte que reemplace esto;
si en el futuro se construye un dashboard (Fase 2+), ese dashboard **lee**
de este repo vía la API de GitHub, nunca al revés.

## Estructura

```
magia-framework/
├── README.md
├── CONTEXTO-PARA-CLAUDE-CODE.md   ← briefing de continuidad del proyecto
├── CHANGELOG.md
├── VERSION
├── docs/                          ← pilares, planes, políticas (markdown)
├── claude-md/base.md              ← plantilla de CLAUDE.md para cada repo de producto
├── rules/                         ← Rules de ejemplo/base por dominio
└── skills/                        ← Skills canónicas de MAGIA
```

Cada repo de producto que adopte MAGIA copia (no enlaza en vivo)
`claude-md/base.md` → su propio `CLAUDE.md`, y las Skills/Rules que le
apliquen → su propio `.claude/`. La copia **fija una versión** de
`magia-framework` (vía el tag de release usado al copiar), igual que se
fija la versión de una dependencia de software.

```
repo-producto-A/.claude/   ← copiado desde magia-framework v1.2.0
repo-producto-B/.claude/   ← puede seguir en v1.0.0 hasta que decida actualizar
```

## Versionado semántico

- **MAJOR** (`2.0.0`): cambio que rompe compatibilidad con `CLAUDE.md`/Rules
  ya desplegadas (ej. se elimina una regla que otros repos asumen activa).
- **MINOR** (`1.1.0`): nueva Skill, nueva Rule, nueva sección de un pilar.
- **PATCH** (`1.0.1`): corrección de redacción, ajuste menor sin cambio de
  comportamiento.

## Proceso de cambio

1. Todo cambio a `docs/`, `claude-md/`, `rules/` o `skills/` va por Pull
   Request — nunca commit directo a `main`.
2. El comité de gobernanza (ver `docs/00-plan-metodologico-4D.md`, sección
   de roles) revisa y aprueba.
3. Al mergear, se actualiza `CHANGELOG.md` y `VERSION`, y se crea un
   release/tag en GitHub.
4. Los repos de producto deciden cuándo actualizar su copia — nunca se
   propaga automáticamente.

## Backlog de señales a evaluar

Usar **Issues** de este repo con la etiqueta `señal-actualizacion` para
registrar cualquier novedad externa que pueda requerir un ajuste de MAGIA
(nuevo modelo, nueva capacidad de Claude Code, cambio regulatorio). Cadencia
de revisión: máximo cada 2 semanas, en la reunión del comité de gobernanza.

## Dueños por artefacto

Cada Skill y cada Rule debe tener un responsable humano nombrado (no solo
"el comité" en general), registrado en el encabezado del propio archivo
(`Owner:` en el front-matter o al inicio del documento).

| Artefacto | Owner |
|---|---|
| `skills/elegir-patron-ia/SKILL.md` | José Alonso |
| `rules/example-ai-features.md` | José Alonso |

Comité de gobernanza (aprobación de cambios por consenso): José Alonso, Pablo
Breganza, Josué Gamarro — ver `docs/01-plan-tecnico-fase1.md`, sección de
roles técnicos.
