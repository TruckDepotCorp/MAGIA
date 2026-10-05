# MAGIA — Claude Code in Action aplicado

**Módulo de referencia** · Extiende `SPEC.md`, `modules/FORGE.md` y `modules/ANTHROPIC-FRAMEWORKS.md` (AF13) · v1.0 · Confidencial — Truck Depot Corporation

> El curso **Claude Code in Action** de Anthropic Academy enseña a llevar Claude Code más allá de la tarea rápida: dirigir sesiones largas, configurar reglas que no se pueden saltar, automatizar el trabajo repetido y verificar lo que se hizo sin supervisión. MAGIA convierte cada uno de sus cuatro módulos en capacidades instaladas y verificables.
>
> Nota para quien implemente: los nombres exactos de comandos, modos y campos de configuración DEBEN confirmarse contra la documentación vigente de Claude Code al implementar (`claude --help`, docs oficiales). Este módulo define el comportamiento requerido; la sintaxis se ajusta a la versión instalada.

## Mapa

| Módulo del curso | Capacidad MAGIA | Dónde |
|---|---|---|
| CC1 Dirigir el trabajo | Protocolo de sesión: modo plan, compactación dirigida, checkpoints, ejecución supervisada vs. autónoma, worktrees | SPEC §3, §27 · FORGE F7, F8 |
| CC2 Configurar Claude | Tres superficies de instrucción (CLAUDE.md, Skills, hooks) + modos de permiso según autonomía | SPEC §6, §11, §14, §16.2 |
| CC3 Automatizar el trabajo repetido | Rutinas programadas, modo headless, revisión de PRs administrada y GitHub Action | SPEC §18, §29, §30 · FORGE F12, F14 |
| CC4 Verificar y compartir | Skill `magia-verify`, gates sobre resultados reales, verificación proporcional, **MAGIA como plugin** | SPEC §8, §15, §27.2 |

---

## CC1. Dirigir el trabajo — Protocolo de sesión MAGIA

### CC1.1 Modo plan obligatorio
- Toda tarea no trivial empieza en **modo plan**: el agente explora y propone sin editar.
- El plan se guarda en `docs/magia/plans/<id>.md` (SPEC §3, etapa 3) y solo entonces se sale del modo plan.
- "No trivial" = toca más de un archivo, cambia un contrato, toca una ruta crítica o supera 30 minutos estimados.

### CC1.2 Compactación dirigida
La compactación automática resume sin saber qué importa. MAGIA usa **compactación dirigida**: el agente compacta antes del límite con instrucciones explícitas de qué conservar.

Instrucción estándar (Skill `magia-context`, sección "Compactar"):
```
Conserva: objetivo del run, decisiones tomadas y su porqué, archivos modificados,
tests/evals que fallan y su causa, pendientes de features.json, Rules en juego.
Descarta: salidas completas de comandos, exploraciones descartadas, código ya commiteado.
```
Antes de compactar: actualizar `progress.md` (AF6). Así la sesión sobrevive aunque el resumen pierda algo.

### CC1.3 Checkpoints y rebobinado
- Ante un desvío (enfoque equivocado, cambios no deseados), el agente o la persona **rebobina** al checkpoint anterior en lugar de "arreglar encima".
- Regla MAGIA: después de 2 intentos fallidos de corrección sobre el mismo enfoque, rebobinar y replantear desde el plan (lo aplica `magia-fixer`).
- Los commits de AF6 son el checkpoint duradero; el rebobinado de sesión es el checkpoint rápido.

### CC1.4 Supervisado vs. autónomo
| Modo de trabajo | Cuándo | Cómo |
|---|---|---|
| **Dirigido** (humano al volante) | Exploración, decisiones de arquitectura, rutas críticas | Sesión interactiva, modo plan, revisión paso a paso |
| **Por objetivo** | Tarea con criterio de terminado verificable | El agente trabaja hasta cumplir el objetivo o agotar presupuesto (`magia run`) |
| **En bucle** | Trabajo recurrente o iterativo (corregir hasta verde, revisar cola de issues) | Bucle con condición de salida y presupuesto (`magia-fixer`, `magia improve`) |
| **En paralelo** | Tareas independientes | Git worktrees, un agente por worktree (FORGE F8) |

Selección automática: `magia run` elige el modo según riesgo, ruta crítica y existencia de criterio verificable. Sin criterio verificable no hay modo autónomo.

---

## CC2. Configurar Claude — Tres superficies de instrucción

| Superficie | Para qué | Regla MAGIA |
|---|---|---|
| **CLAUDE.md** | Lo que el agente debe saber siempre | Corto, específico y obedecible. Importa `@MAGIA.md`. Nada de procedimientos largos |
| **Skills** | Procedimientos repetibles que se cargan cuando aplican | Todo procedimiento de más de 5 pasos vive en una Skill, no en CLAUDE.md |
| **Hooks** | Reglas que **no se pueden saltar** | Toda Rule Core con verificación automática se implementa como hook o gate, nunca solo como texto |

Principio: **si una regla es innegociable, no se escribe como sugerencia; se hace cumplir con un hook.** El texto en CLAUDE.md explica; el hook obliga.

### CC2.1 CLAUDE.md que se obedece
`magia check` valida:
- ≤ 150 líneas en `CLAUDE.md` y ≤ 300 en `MAGIA.md` (propuesta).
- Cada regla es concreta y verificable ("Ejecuta `pnpm test` antes de commitear"), no aspiracional ("escribe buen código").
- Sin duplicar contenido de Skills ni de Rules Core (enlaza).
- Sin contradicciones con hooks o permisos.
- Comandos de build, test, lint y eval presentes y ejecutables.

`magia generate --only context` reescribe `CLAUDE.md` y `MAGIA.md` con este estándar; `magia-scout` propone podar reglas que los transcripts muestran que no se siguen o no aportan.

### CC2.2 Modos de permiso según autonomía
Claude Code ofrece varios modos de permiso. MAGIA asigna el modo según el nivel de autonomía (SPEC §16.2) y el entorno:

| Situación | Modo de permiso | Condición |
|---|---|---|
| Exploración y planificación | Modo plan (solo lectura) | Siempre al inicio de tareas no triviales |
| NM-1 Asistente | Por defecto (pide confirmación) | — |
| NM-2 Copiloto | Aceptar ediciones automáticamente | Solo con sandbox AF10 activo |
| NM-3 Agente supervisado | Aceptar ediciones + comandos en allowlist | Sandbox + `human-checkpoint` para irreversibles |
| CI / contenedor efímero (flota Forge) | Sin confirmaciones | Solo en contenedor aislado sin credenciales de producción y con egreso en allowlist |

`magia check` falla si el modo configurado es más permisivo que el permitido para el nivel y el entorno.

### CC2.3 Hooks que permiten, niegan o piden confirmación
Cada hook MAGIA declara su decisión explícita:

| Decisión | Uso |
|---|---|
| **Permitir** | Acciones seguras conocidas (tests, lint) para reducir interrupciones |
| **Negar** | Violaciones de Rules (leer secretos, editar Core, desplegar sin gate) |
| **Pedir confirmación** | Acciones legítimas pero sensibles (migraciones de datos, cambios en rutas críticas) |

Los hooks devuelven al agente un mensaje accionable: Rule violada + qué hacer en su lugar.

---

## CC3. Automatizar el trabajo repetido

### CC3.1 Rutinas programadas
Prompts que ya son confiables se ejecutan **programados** (en la infraestructura de rutinas de Claude Code o en el scheduler corporativo):

| Rutina | Frecuencia sugerida | Acción |
|---|---|---|
| `magia scout` | Semanal | Backlog de oportunidades |
| `magia improve` | Semanal / ante incidente | PRs desde fallas reales |
| `magia frontier` | Al publicarse un modelo nuevo + mensual | MAGIA Bench y ablación |
| Actualización de dependencias | Semanal | PR con tests y evals en verde |
| `magia audit` | Trimestral | Reporte al Comité |
| Poda de contexto | Mensual | Propuestas de limpieza de CLAUDE.md, MAGIA.md y Skills |

Toda rutina: presupuesto, salida en PR (nunca push directo a `main`), y el mismo gate que el trabajo humano.

### CC3.2 Modo headless
Cuando el trabajo necesita un pipeline propio (CI, flota Forge, rutinas internas), se ejecuta Claude Code sin interfaz desde scripts, con salida estructurada en JSON, herramientas permitidas explícitas y presupuesto. Es la base de `magia run` en CI, `magia fleet` y de las rutinas.

### CC3.3 Revisión de PRs administrada y GitHub Action
- Todo PR recibe revisión automática de Claude (revisión administrada o GitHub Action), configurada con la Constitución, las Rules y el checklist AF3.
- Mencionar a Claude en un issue o PR dispara `/magia-ship` o `/magia-review` según la etiqueta.
- La revisión de Claude **complementa** a `magia gate`; no lo reemplaza.

---

## CC4. Verificar y compartir

### CC4.1 Skill `magia-verify`
Skill que **ejecuta tests, lee el diff y reporta evidencia** automáticamente. Es el motor del Paquete de Evidencia (SPEC §27.2).

Procedimiento:
1. `git diff` contra la rama base → lista de cambios y su propósito.
2. Ejecutar tests impactados (o todos si no hay índice), `magia check`, `magia eval`.
3. Verificar cada criterio de `features.json` / spec con evidencia concreta (salida de test, captura de navegador automatizado si hay UI).
4. Revisar el diff contra el checklist AF3 y las Rules.
5. Escribir el reporte: qué se verificó, cómo, resultado, qué NO se pudo verificar.

Regla: el agente **no declara terminado** sin ejecutar `magia-verify`. Plantilla: `templates/claude/skills/magia-verify/SKILL.md`.

### CC4.2 Gates sobre resultados reales
El hook de fin de turno (`Stop`) **bloquea la finalización** mientras tests, `magia check` o los evals impactados fallen, y devuelve al agente la falla para que continúe. El agente no puede terminar un turno "creyendo" que funciona: termina cuando las pruebas lo demuestran. Límite de reintentos para evitar bucles infinitos (después escala por excepción, SPEC §27.1).

### CC4.3 Verificación proporcional
Cuanto menos se observó el trabajo, más se verifica:

| Cómo se hizo el trabajo | Verificación mínima |
|---|---|
| Dirigido, paso a paso | `magia-verify` estándar |
| Por objetivo, supervisión parcial | + revisión multiagente + lectura del Paquete de Evidencia |
| Autónomo / rutina / flota sin supervisión | + verificación diferencial completa (FORGE F9) + muestra de transcripciones + revisión humana de rutas críticas |

### CC4.4 MAGIA como plugin de Claude Code
La configuración confiable se empaqueta como **plugin** que todo el equipo instala, en lugar de copiar archivos.

| Pieza | Contenido |
|---|---|
| Plugin `magia-core` | Constitución, comandos `/magia-*`, subagentes, Skills Core, hooks de Rules, servidores MCP aprobados |
| Plugin `magia-forge` | Agentes y comandos Forge, `magia-codegraph` |
| Plugin `magia-flow` | Skills y recetas Flow para trabajo en repositorio ligero |
| **Marketplace corporativo** | `truckdepot/magia-marketplace`: catálogo privado de plugins MAGIA y del Registro |

Efecto en la instalación (SPEC §8): `magia init` instala el plugin correspondiente al perfil y luego genera solo la capa **específica del proyecto** (MAGIA.md, Skills locales, evals). El Core llega por plugin con versión, por lo que actualizar MAGIA en toda la corporación es actualizar el plugin. `magia.lock` registra la versión del plugin.

Estructura de referencia en `templates/plugin/`.

---

## Métricas

| Métrica | Qué mide |
|---|---|
| % de tareas no triviales iniciadas en modo plan | Disciplina de planificación |
| Turnos bloqueados por el gate de fin de turno y luego resueltos | Efectividad del gate |
| Reglas de CLAUDE.md incumplidas en transcripts | Calidad de las instrucciones |
| Rutinas ejecutadas y PRs aceptados de rutinas | Automatización efectiva |
| Proyectos con plugin MAGIA en la última versión | Adopción y actualización |

## Hitos

| Hito | Entregable | Criterio de aceptación |
|---|---|---|
| CCM1 | Protocolo de sesión: modo plan obligatorio, compactación dirigida, regla de rebobinado | Tareas no triviales sin plan son detectadas por `magia check` sobre transcripts de muestra |
| CCM2 | Validador de CLAUDE.md y matriz de modos de permiso | `check` falla con CLAUDE.md > 150 líneas, reglas vagas o modo de permiso excesivo |
| CCM3 | `magia-verify` + gate de fin de turno | El agente no puede terminar con un test en rojo; el reporte se adjunta al PR |
| CCM4 | Rutinas programadas + headless + revisión de PRs | Las rutinas de CC3.1 corren con presupuesto y abren PRs que pasan gate |
| CCM5 | Plugins `magia-core`, `magia-forge`, `magia-flow` + marketplace corporativo | Instalación de MAGIA en repo nuevo vía plugin; actualización corporativa con un solo cambio de versión |
