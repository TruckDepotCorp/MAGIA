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
  y el potencial de escalarlo a toda la empresa. Reescrito dos veces a
  pedido explícito: primero con tono más contundente (tabla
  sin-MAGIA/con-MAGIA, marco de "riesgo invisible"), luego con nuevo
  título y 3 secciones nuevas — Desempeño (gobernar acelera, no frena),
  Calidad de producto (la gobernanza también sube el piso de calidad), y
  Nivel de gobernanza (posiciona a la empresa en el camino de madurez de
  las organizaciones líderes en IA). Sin métricas inventadas — se
  refuerza el mismo hallazgo real ya documentado.

### Agregado (2026-10-05) — integración del paquete de handoff (propuesto como v0.3.0)

Decisiones del usuario: instalación por **kit + instalador Claude Code**
(sin CLI), enforcement **híbrido** por severidad, y alcance **núcleo ahora,
resto como roadmap**. El VERSION sigue en `0.2.0`: el corte de release a
0.3.0 (MINOR: nuevas Skills y Reglas) lo decide el comité al aprobar el PR.

- `core/`: `CONSTITUCION.md`, `REGLAS-CORE.md` (R1–R9 con severidad dura/
  blanda y mecanismo de cumplimiento real hoy vs. objetivo),
  `proveedores-aprobados.txt` (los 4 aprobados del 2026-08-04),
  `magia.config.schema.json`, `scripts/check.sh` (`check` | `lock` | `gate`,
  equivalente sin CLI de `magia check`/`gate`) y `hooks/` (movidos desde
  `templates/hooks/`): `guard-read`, `guard-write`, `scan-secrets`,
  `guard-bash`, `session-start`, `stop-gate`, más los dos hooks de v0.2.0
  actualizados.
- Skills: `magia-context`, `magia-verify`, `magia-evals`,
  `magia-data-shield`, `magia-grounding`, `magia-red-team`,
  `magia-diligencia`. Owner provisional José Alonso, pendiente de confirmar.
- `agents/` (nuevo): `magia-planner`, `magia-reviewer`, `magia-security`,
  `magia-fixer`. `commands/` (nuevo): `/magia-instalar` (agente instalador),
  `/magia-brief`, `/magia-spec`, `/magia-plan`, `/magia-review`,
  `/magia-eval`, `/magia-gate`.
- `templates/`: `MAGIA.md`, `magia.config.example.json`,
  `declaracion-diligencia.md`, `plan-de-delegacion.md`, `descripcion-3p.md`,
  `prompt-template.example.md`, `adopcion-30-dias.md`, `diario/` (contexto de
  área, ficha de workflow, política de uso de IA), `evals/` (golden set de
  ejemplo), `rubrics/rubrica-base.md`.
- `docs/11-instalacion-y-perfiles.md`, `docs/12-marcos-anthropic-aplicados.md`,
  `docs/13-roadmap-motor-de-valor.md`, y `docs/referencia-spec/` (copia
  íntegra del handoff con `LEEME-ESTADO.md`: es diseño objetivo, no
  configuración vigente).
- `.gitattributes`: `*.sh` y `core/**` con LF.

### Cambiado (2026-10-05)
- `claude-md/base.md`: importa `@MAGIA.md`, referencia el Core, agrega
  protocolo de trabajo (modo plan, rebobinado, `magia-verify`) y decisiones
  siempre humanas. Reglas de proveedores y riesgo sin cambios.
- `templates/settings-hooks-referencia.json`: ahora incluye `permissions.deny`
  (Edit **y** Write por separado) y los 6 eventos; hooks apuntan a
  `.magia/core/hooks/`. Sintaxis verificada contra la documentación oficial
  (2026-10-05).
- `templates/ci-pipeline-referencia.yml`: workflow `magia-gate` unificado
  (check, secretos, pruebas, evals condicionales, job agregador requerido).
- `docs/05-matriz-riesgo.md`: niveles de autonomía NM-1…NM-4.
  `docs/08`: umbrales de evals propuestos (pendientes de ratificar).
  `docs/07`: estructura de plantilla de prompt. `docs/00` §5, `docs/03`,
  `docs/01`: capas nuevas, gobernanza del Core y estado.
- `README.md`, `CLAUDE.md`, `CONTEXTO-PARA-CLAUDE-CODE.md`: estructura y
  adopción actualizadas.

### Corregido (2026-10-05)
- Las 3 Rules de `rules/` usaban solo `scope:`; la documentación oficial de
  Claude Code carga Rules por ruta con `paths:`. Se agregó `paths:` (se
  conserva `scope`). **Las Rules instaladas en HIPERSAP deberían revisarse**:
  si usan solo `scope`, probablemente cargan siempre, no por ruta.
- Hooks: lectura de JSON y rutas absolutas de Windows; hash del lock
  independiente de CRLF/LF (`autocrlf`).

### Instalación piloto v0.3.0 en HIPERSAP (2026-10-05)
Primera prueba real del instalador (ejecutado a mano siguiendo `/magia-instalar`)
en un **worktree aparte** (`C:\NET_PROJECTS\HIPERSAP-magia`, rama local
`chore/adopt-magia-0.3.0` desde `4f0b4d2`, sin commit ni push) porque el árbol
principal de HIPERSAP tenía cambios sin commitear. Config: riesgo Alto, NM-1,
`aiInProduct=false`, enforcement `advertencia`. Migró v0.2.0 → v0.3.0: Core
en `.magia/core/` con `magia.lock`, hooks nuevos (se retiraron los de
`.claude/magia/hooks/`), 7 Skills, 4 agentes, 7 comandos, `paths:` en sus 2
Rules, `MAGIA.md`, `CLAUDE.md` actualizado, workflow `magia-gate`.
`check.sh`: 0 errores, 1 aviso (`CLAUDE.md` 152 líneas). Fricciones
encontradas: `restringido.txt` quedó vacío a propósito (listar código de
`RHModels/` bloquearía el trabajo normal); no hay proyecto de pruebas en la
solución; el job de secretos de la plantilla (gitleaks) exige licencia en
repos de organización.

### Segunda tanda del handoff (2026-10-05)
- Agentes `magia-documenter` (Paquete de Evidencia y docs a partir del reporte
  de `magia-verify`) y `magia-evaluator` (evals independientes, etiquetado de
  fallas, casos propuestos; lo invoca `/magia-eval`). Ya son 6 agentes.
- `templates/ci-revision-pr.yml`: revisión automática de PRs con
  `anthropics/claude-code-action@v1` (sintaxis verificada en la doc oficial;
  `actions/checkout@v6` marcado [VERIFICAR]). Opcional, solo PRs del mismo
  repo, no sustituye al gate. Envía el diff a la API: requiere confirmación del
  comité en riesgo Alto. **No activada en HIPERSAP.**
- `templates/rubrics/ux.md`: rúbrica de UX (AF3) para repos con interfaz.
- `check.sh` valida: `permissions.defaultMode` frente a la autonomía
  (`bypassPermissions`/`dontAsk` = error; `acceptEdits`/`auto` por encima
  del NM = aviso) y, en `docs/magia/delegation.md`, que toda tarea en modo
  agencia declare cómo se verifica y que agencia exija NM-2+. Probado en el
  repo temporal simulado.
- HIPERSAP (rama `chore/adopt-magia-0.3.0`, commit `14bf3d6`): sincronizado con lo anterior.

### Pendiente / no validado (2026-10-05)
- Sin probar dentro de una sesión real de Claude Code, ni el instalador sobre
  un repo real, ni el workflow en GitHub Actions. Probado a nivel de script
  en un repo temporal simulado.
- Sin plugin ni `marketplace.json`: el esquema no está confirmado en la
  documentación oficial. `stop_hook_active` tampoco: `stop-gate.sh` usa su
  propia guarda anti-bucle.
- Decisiones D1, D4–D11 del handoff siguen abiertas (`docs/13`).

### Agregado (2026-08-10)
- **Spike técnico de "Copiloto embebido" ejecutado** (`docs/07-arquitectura-referencia.md`
  §5.1), tarea 3 del Sprint 2 — 5 llamadas reales vía Claude Code CLI en
  modo `--print` (`--system-prompt` propio, `--tools ""`, `--model sonnet`,
  `--output-format json`) simulando sugerencias de copiloto que un humano
  aprueba/descarta. Alcance genérico (sin atar a WMS/HIPERSAP, decisión
  explícita). Métricas reales del propio sistema de facturación, no
  estimadas: costo promedio $0.0241/request, $0.12 total la corrida,
  latencia promedio `duration_api_ms` 8,485 ms / `ttft_ms` 5,230 ms, 0
  fallos en la muestra. Hallazgo no anticipado: cada llamada independiente
  paga cache-creation completo (sin reuso entre requests) más una llamada
  oculta a un modelo Haiku (clasificador interno del CLI) — ninguna de las
  dos la pagaría una integración directa vía API/SDK, así que el número
  medido es un techo, no el costo esperado en producción. Se actualizó el
  criterio de aceptación del Sprint 2 en `docs/01-plan-tecnico-fase1.md`
  a **parcial** (falta el spike de Agente/MCP y de RAG, y repetir este
  spike atado a un caso real).

### Pendiente
- Spike técnico de **Agente con herramientas/MCP** y de **RAG** (Sprint 2)
  — no ejecutados todavía.
- Repetir el spike de Copiloto embebido atado a un caso de negocio real
  (WMS o HIPERSAP), no solo genérico.
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
