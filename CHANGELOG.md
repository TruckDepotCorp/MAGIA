# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).
Este proyecto usa versionado semántico (ver `docs/03-gobernanza-repositorio.md`).

## [Unreleased] - Sprint 2 + Sprint 3 + Sprint 4 en curso

### Agregado
- `docs/07-arquitectura-referencia.md`: estándar de MAGIA para integrar IA
  dentro de productos propios. Catálogo de 5 patrones; prioriza Copiloto
  embebido, Agente con herramientas/MCP y RAG. Define el estándar de
  MCP/conectores internos (owner, permisos, confirmación humana en
  escritura irreversible, clasificación de riesgo previa), y las
  convenciones de versionado de prompts y logging/observabilidad con
  enmascarado de PII. Incluye diagramas de referencia por patrón.
- `docs/08-estandares-desarrollo.md`: guía de prompting (Producto/Proceso/
  Desempeño del 4D adaptado a generación de código, revisión de PRs,
  generación de tests), estándar de testing/evals, y referencia al
  pipeline CI/CD.
- `docs/09-catalogo-capacidades.md`: matriz tarea → modelo/herramienta →
  patrón → riesgo típico → costo relativo, usando los 4 proveedores
  aprobados.
- Carpeta `templates/` nueva: `ficha-caso-de-uso.md`, `pr-template-ia.md`,
  `ci-pipeline-referencia.yml` (GitHub Actions, coherente con el CI/CD
  real de la empresa).
- `skills/elegir-patron-ia/SKILL.md` actualizada para apuntar a los
  documentos reales (ya no dice "pendiente de completar en el Sprint 3").
- **Adelanto informal de la tarea 5 del Sprint 4:** MAGIA v0.2.0 instalado
  en HIPERSAP (`C:\NET_PROJECTS\HIPERSAP`, repo real) — `CLAUDE.md` fusionado
  con su gobernanza (sin tocar el contenido técnico existente), skill
  `elegir-patron-ia` y ficha de diligencia copiadas, plantilla de PR
  agregada como opcional. Mergeado a `master` de HIPERSAP (rama
  `chore/adopt-magia-governance`, merge `--no-ff`), sin push (a pedido del
  usuario). No instalado en esa primera pasada: Rules ni hooks — ver instalación
  real más abajo. Pipeline CI todavía sin instalar (HIPERSAP no tiene
  GitHub Actions configurado hoy).
- `claude-md/base.md` consolidado a v0.2.0 (tarea 1 del Sprint 4):
  referencias obsoletas corregidas (apuntaba a `docs/00` para la matriz de
  riesgo, ahora apunta a `docs/05`), nota de "fusionar, no reemplazar" si
  el repo ya tiene un `CLAUDE.md` técnico propio.
- `rules/example-external-integration.md`: segundo ejemplo de Rule
  path-scoped (tarea 2 del Sprint 4), para el tipo de área crítica real
  identificada en el Sprint 1 (integración con sistemas externos, ej. SAP
  B1 en HIPERSAP).
- `skills/ficha-caso-de-uso/SKILL.md` y `skills/checklist-pre-deploy/SKILL.md`
  (tarea 3 del Sprint 4) — creadas a mano; `skill-creator` no está
  disponible en este entorno.
- `templates/settings-hooks-referencia.json` + `templates/hooks/*.sh`
  (tarea 4 del Sprint 4) — hooks básicos en **modo advertencia**, no
  bloqueo duro, a propósito (ver riesgos técnicos de
  `docs/01-plan-tecnico-fase1.md`).
- **Rules y hooks reales instalados en HIPERSAP** (no genéricos):
  explorando el código real se encontraron las rutas de la integración SAP
  B1 (`Core/SAPServices/`, `Core/SAPInterfaces/`, `Core/SAPModels/`,
  `SBOController`) y una segunda área crítica no anticipada en el Sprint 1
  — PII de empleados vía BioTime/Humand (`Core/RHModels/`). Instaladas 2
  Rules y hooks en `.claude/settings.json` (no `settings.local.json`, que
  es personal/gitignored), probados manualmente a nivel de script.
- `rules/example-pii-terceros-rrhh.md`: tercer patrón genérico de Rule,
  generalizado a partir del hallazgo real en HIPERSAP — PII de empleados
  vía proveedor SaaS externo de RRHH, distinto de PII de clientes
  (`example-external-integration.md`) o features de IA en el producto
  (`example-ai-features.md`).
- `docs/10-resumen-ejecutivo-gerencia.md`: resumen no técnico para
  Gerencia — qué problema resuelve MAGIA, qué se descubrió y qué cambió al
  instalarlo en un proyecto real (generalizado, sin nombrar el proyecto),
  y el potencial de escalarlo a toda la empresa. Reescrito con tono más
  contundente (tabla sin-MAGIA/con-MAGIA, marco de "riesgo invisible",
  ventaja competitiva) a pedido explícito — sin agregar métricas
  inventadas, solo reforzando el hallazgo real ya documentado.

### Pendiente
- Spike técnico con métricas reales de latencia/costo (Sprint 2) —
  requiere un caso de uso de producto real; ningún proyecto lo tiene
  todavía.
- Elegir/construir el framework de evals concreto y generar el primer
  golden dataset real (Sprint 3).
- Ejecutar `templates/ci-pipeline-referencia.yml` contra un repo real.
- Validar los hooks dentro de una sesión real de Claude Code (solo se
  probaron los scripts de forma manual/aislada).
- Onboarding del equipo piloto y primer ciclo de uso real (3-5 días) —
  no se puede simular, requiere tiempo real de adopción.

## [0.2.0] - Cierre Sprint 1 (Diagnóstico y Gobernanza) - 2026-08-04

### Agregado
- Comité de gobernanza constituido con nombres reales: José Alonso, Pablo
  Breganza, Josué Gamarro. Modelo de decisión: consenso del comité.
- Asignación de rol técnico por persona en `docs/01-plan-tecnico-fase1.md`
  (roles solapados — equipo reducido).
- Owner nombrado para `skills/elegir-patron-ia/SKILL.md` y
  `rules/example-ai-features.md` (José Alonso).
- Responsable de la compuerta final de Diligencia asignado en
  `docs/00-plan-metodologico-4D.md` §4 (comité, por consenso).
- `CLAUDE.md` en la raíz del repo (guía para Claude Code en este propio
  repositorio, distinta de la plantilla `claude-md/base.md`).
- Repo inicializado en git, primer commit (`chore: esqueleto inicial de
  MAGIA v0.1.0`).
- Proveedor/modelo de IA aprobado definido: Anthropic (Claude Code), único
  para desarrollo. Regla global agregada a `claude-md/base.md`.
- Registrado que ChatGPT y Grok están en evaluación/prueba (sin aprobación
  de producción); detalle completo queda pendiente para el inventario de
  casos de uso.
- `docs/04-diagnostico-inventario-ia.md`: inventario técnico de casos de uso
  de IA (Sprint 1). Registra Claude Code (este repo) y Cursor probado en
  WMS e HIPERSAP con Composer 2.5 fast, Grok 4.5 high fast, Opus 5, Sonnet 5
  y GPT-5.6. Incluye hallazgo abierto: ambos repos ya tocaron PII con
  proveedores no aprobados, pendiente de clasificación de riesgo por el
  comité.
- Regla global de `claude-md/base.md` ampliada: la lista de aprobados aplica
  al modelo invocado por debajo, no solo al nombre de la herramienta
  (relevante para herramientas multi-modelo como Cursor).
- **Decisión del comité:** Anthropic, xAI (Grok), OpenAI (GPT) y el modelo
  propio de Cursor ("Composer") quedan aprobados, dado que Cursor es la
  herramienta formal de IA de la empresa desde hace ~1 año, previa a Claude
  Code. Confirmado que las menciones sueltas de ChatGPT/Grok eran el mismo
  uso vía Cursor en WMS/HIPERSAP — se retiraron del inventario como filas
  duplicadas. Se deja explícito que la aprobación de proveedor **no**
  clasifica el nivel de riesgo del caso de uso — eso sigue pendiente.

- `docs/05-matriz-riesgo.md`: matriz de niveles de riesgo con rúbrica
  técnica de 4 criterios (PII, autonomía, exposición externa,
  reversibilidad). Ejemplos reales clasificados y confirmados por el
  comité: WMS = Medio, HIPERSAP = Alto.
- `docs/06-stack-tecnico.md`: levantamiento de stack técnico. GitHub
  (multi-repo), GitHub Actions, Azure como cloud aprobado, WMS e HIPERSAP
  en .NET/C#.

### Sprint 1 — cerrado 2026-08-04

Cerrado con un pendiente que corre en paralelo y **no bloquea** el inicio
del Sprint 2 (ver `docs/02-valor-y-adopcion.md`, corre en paralelo a los
sprints técnicos, no es un pilar más):

- Criterio de priorización de casos de uso por impacto de negocio (capa de
  valor).

### Deuda técnica registrada (seguimiento, no bloquea Sprint 2)
- Completar el inventario si aparece otro repo/feature de IA no reportado.
- Crear la ficha de diligencia (Sprint 3) y aplicarla retroactivamente a
  WMS e HIPERSAP por estar en Medio/Alto.

## [0.1.0] - Esqueleto inicial

### Agregado
- Estructura inicial del repo `magia-framework`.
- `docs/00-plan-metodologico-4D.md`: plan metodológico 4D para construir MAGIA.
- `docs/01-plan-tecnico-fase1.md`: plan técnico detallado de la Fase 1 (semanas 1-8).
- `docs/02-valor-y-adopcion.md`: capa de valor y adopción de negocio.
- `docs/03-gobernanza-repositorio.md`: estrategia de versionado y distribución.
- `claude-md/base.md`: plantilla de `CLAUDE.md` v0.1 para repos de producto.
- `rules/example-ai-features.md`: Rule de ejemplo, alcance `src/ai-features/**`.
- `skills/elegir-patron-ia/SKILL.md`: primera Skill canónica de MAGIA.

### Pendiente (bloquea cierre del Sprint 1)
- Completar los `[por definir]` de gobernanza: comité, dueños, proveedores
  aprobados, matriz de riesgo con ejemplos reales.
- Auditoría técnica real de casos de uso existentes.
