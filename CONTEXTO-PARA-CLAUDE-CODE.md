# Contexto del proyecto MAGIA — para continuar en Claude Code

Este documento existe para que una sesión nueva de Claude Code tenga
continuidad completa del proyecto, sin tener que repetir todo lo ya
decidido. Léelo primero, antes de tocar cualquier archivo del repo.

---

## 1. Qué es MAGIA y para qué existe

**MAGIA = Marco de Arquitectura y Gobernanza de Inteligencia Artificial.**

Objetivo de negocio: que el desarrollo de software de la empresa incorpore
IA de forma **ágil**, **estandarizada** y **gobernada**, al nivel de una
empresa que genera valor real con IA — no solo que "usa IA".

**El objetivo final no es el documento de MAGIA.** Es que su gobernanza se
convierta en artefactos ejecutables de Claude Code que aceleren el trabajo
diario:

| Pilar de MAGIA | Se traduce en |
|---|---|
| Gobernanza + Diligencia | `CLAUDE.md` (reglas globales, siempre activas) |
| Estándares de desarrollo | `.claude/rules/` (reglas por carpeta/ruta) |
| Arquitectura de referencia + Catálogo de capacidades | `.claude/skills/` (procedimientos reutilizables) |
| Ciclo de vida y compuertas | hooks en `settings.json` (enforcement automático) |

Importante: MAGIA **no está escrito en piedra**. Es un producto interno con
su propio ciclo de vida — se actualiza con cadencia fija a medida que
evolucionan los modelos y las capacidades de Claude Code (ver
`docs/03-gobernanza-repositorio.md`).

## 2. Los 5 pilares del marco (contenido, no solo estructura)

1. **Arquitectura de referencia** — patrones de integración de IA aprobados
   (RAG, agentes/MCP, prompting directo, copiloto embebido, orquestador).
2. **Gobernanza y roles** — comité de gobernanza, RACI, niveles de riesgo,
   proceso de aprobación de casos de uso.
3. **Estándares de desarrollo** — guía de prompting, testing/evals, CI/CD
   para componentes de IA, versionado de prompts.
4. **Catálogo de capacidades** — matriz "tarea → modelo/herramienta
   recomendada", proveedores aprobados.
5. **Ciclo de vida y diligencia** — compuertas de creación/transparencia/
   despliegue antes de llevar algo a producción.

Detalle completo de cada uno: `docs/00-plan-metodologico-4D.md`.

## 3. El plan de 10 semanas (ya definido, no reabrir sin razón)

- **Fase 1 (semanas 1-8):** construir los 5 pilares + primeras Skills/Rules
  en un repo piloto. Desglosado en 4 sprints de 2 semanas — ver
  `docs/01-plan-tecnico-fase1.md` para el detalle técnico completo (tareas,
  entregables, criterios de aceptación por sprint).
- **Fase 2 (semanas 9-10):** validar el marco con un producto/caso de uso
  real de principio a fin — la prueba de que MAGIA funciona en la práctica,
  no solo en el papel.

Existe también una presentación gerencial (`MAGIA-plan-de-trabajo-10-semanas.pptx`,
generada fuera de este repo) con esta misma estructura en formato ejecutivo.

## 4. La capa de valor y adopción (paralela, no un pilar más)

Se identificó que un framework de gobernanza por sí solo **no genera valor
de negocio** — solo controla el riesgo. Ver `docs/02-valor-y-adopcion.md`
para el detalle de las tres brechas a cubrir en paralelo a los sprints
técnicos:
1. Motor de valor (priorización por impacto de negocio, no solo factibilidad).
2. Capa humana (adopción real vs. cumplimiento formal, capacitación continua,
   patrocinio ejecutivo).
3. Fundamento de datos e infraestructura (calidad de dato, observabilidad,
   estrategia de proveedores).

## 5. Decisiones de arquitectura del repositorio ya tomadas

- **GitHub es la fuente de verdad**, no una app aparte. Una app/dashboard
  futura (Fase 2+) solo *leería* de este repo, nunca lo reemplazaría.
- Estructura de carpetas ya definida (ver `README.md` de este repo).
- Cada repo de producto **copia y fija una versión** de este framework —
  no hay propagación automática de cambios.
- Versionado semántico + `CHANGELOG.md` obligatorio en cada cambio.
- Todo cambio a `docs/`, `claude-md/`, `rules/` o `skills/` va por Pull
  Request, aprobado por el comité de gobernanza.
- Detalle completo: `docs/03-gobernanza-repositorio.md`.

## 6. Sprint 1 — cerrado (2026-08-04)

Resuelto — 2026-08-04: comité de gobernanza y dueños de Skills/Rules ya
tienen nombres reales (José Alonso, Pablo Breganza, Josué Gamarro; modelo de
decisión por consenso). Ver `docs/01-plan-tecnico-fase1.md` (roles),
`docs/03-gobernanza-repositorio.md` (dueños por artefacto) y
`docs/00-plan-metodologico-4D.md` §4 (responsable de la compuerta final).

Resuelto — 2026-08-04: proveedor/modelo de IA **aprobado** = **Anthropic
(Claude Code)**, único para desarrollo. **En evaluación/prueba** (sin
aprobación de producción): ChatGPT y Grok — no usar con datos reales de
clientes ni PII mientras estén en esta fase. Ver `claude-md/base.md` (regla
global) y `docs/00-plan-metodologico-4D.md` §1. Pendiente: registrar el
detalle de estas pruebas (qué repo/feature, qué dato, PII sí/no) en el
inventario de casos de uso.

Resuelto — 2026-08-04: inventario de casos de uso en
`docs/04-diagnostico-inventario-ia.md`. Cubre Claude Code (este repo) y
Cursor en **WMS** (Core de Operaciones Internas) e **HIPERSAP** (procesos
administrativos, integra con SAP B1) con Composer 2.5 fast, Grok 4.5 high
fast, Opus 5, Sonnet 5 y GPT-5.6 — confirmado que las menciones sueltas de
"ChatGPT"/"Grok" eran este mismo uso, no casos separados. **Cursor es la
herramienta formal de IA de la empresa desde hace ~1 año, previa a Claude
Code** — el comité aprobó los cuatro proveedores (Anthropic, xAI, OpenAI,
Cursor/Composer) dado ese historial real de uso. Ver `claude-md/base.md`.

Resuelto — 2026-08-04: matriz de niveles de riesgo con rúbrica técnica de 4
criterios (PII, autonomía, exposición externa, reversibilidad) en
`docs/05-matriz-riesgo.md`. Ejemplos reales clasificados: **WMS = Medio**,
**HIPERSAP = Alto** (por su exposición externa vía SAP B1), confirmado por
el comité.

Resuelto — 2026-08-04: levantamiento de stack técnico en
`docs/06-stack-tecnico.md`. GitHub (multi-repo), GitHub Actions, Azure como
cloud aprobado. WMS e HIPERSAP corren en .NET/C#.

**Sprint 1 cerrado formalmente el 2026-08-04** (ver `CHANGELOG.md` v0.2.0 y
criterio de aceptación marcado en `docs/01-plan-tecnico-fase1.md`), con un
pendiente que se dejó deliberadamente abierto porque corre en paralelo y no
bloquea el Sprint 2:

- Criterio de priorización de casos de uso por impacto de negocio (capa de
  valor, `docs/02-valor-y-adopcion.md` — no es un pilar técnico, corre en
  paralelo a los sprints).

Deuda técnica registrada, sin bloquear tampoco:
- Completar el inventario si aparece otro repo/feature de IA no reportado.
- Crear la ficha de diligencia (Sprint 3) y aplicarla retroactivamente a
  WMS e HIPERSAP por estar en Medio/Alto.

**Próximo paso: Sprint 2 — Semanas 3-4, Arquitectura de referencia** (ver
`docs/01-plan-tecnico-fase1.md`) — catálogo de patrones de integración,
selección de 2-3 patrones prioritarios cruzados contra el inventario real
(WMS/HIPERSAP), spike técnico por patrón, y convenciones de versionado de
prompts/logging. El stack ya conocido (.NET/C#, GitHub Actions, Azure) debe
enmarcar estos spikes, no un ejemplo genérico.

**Nota de calendario (2026-08-04):** el Sprint 1 se cerró el mismo día que
el calendario alcanzó la semana 4 (inicio del Sprint 2 según
`docs/01-plan-tecnico-fase1.md`) — quedamos sincronizados con el plan de 10
semanas, sin haber saltado ninguna dependencia entre sprints.

## 7. Cómo debe trabajar Claude Code en este proyecto

- Sigue el **modo Metodología** del framework 4D (Delegation → Description →
  Discernment → Diligence) al producir cualquier pieza nueva de MAGIA —
  no redactes contenido genérico de "mejores prácticas de la industria" sin
  marcarlo como tal.
- Cuando falte un dato específico de la empresa, usa `[por definir: ...]` en
  vez de inventar — igual que se hizo en todos los documentos existentes.
- Para crear Skills reales de Claude Code (no solo el borrador en
  `skills/`), usa la skill `skill-creator` si está disponible en el entorno.
- Todo cambio a este repo (`docs/`, `claude-md/`, `rules/`, `skills/`) debe
  ir acompañado de una entrada en `CHANGELOG.md` y, si corresponde, un bump
  de `VERSION`.
- No adelantes contenido de la Fase 2 (semanas 9-10) mientras el Sprint 1
  siga abierto — las dependencias entre sprints son deliberadas (ver
  `docs/01-plan-tecnico-fase1.md`, sección de dependencias críticas).
- Ante cualquier ambigüedad sobre alcance u organización, pregunta antes de
  producir un documento largo — es más barato preguntar que rehacer.

## 8. Primer paso sugerido al abrir esta sesión en Claude Code

1. Confirmar que el repo está clonado/inicializado localmente y conectado a
   GitHub (ver instrucciones de git más abajo).
2. Revisar con la persona los `[por definir]` de la sección 6 — son el
   bloqueador real del Sprint 1, no un tecnicismo.
3. Retomar las tareas técnicas del Sprint 1 en `docs/01-plan-tecnico-fase1.md`.

---

## Comandos Git para la subida inicial

```bash
cd magia-framework
git init
git add .
git commit -m "chore: esqueleto inicial de MAGIA v0.1.0"
git branch -M main
git remote add origin <URL_DEL_REPO_EN_GITHUB>
git push -u origin main
git tag v0.1.0
git push origin v0.1.0
```

Reemplaza `<URL_DEL_REPO_EN_GITHUB>` por la URL real una vez creado el
repositorio vacío en tu cuenta/organización de GitHub.
