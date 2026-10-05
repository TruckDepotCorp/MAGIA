# MAGIA — Especificación Técnica v1.0

**Marco de Arquitectura y Gobernanza de Inteligencia Artificial**
Propiedad intelectual exclusiva de Truck Depot Corporation. Confidencial — uso interno.

> Documento fuente para implementación con Claude Code. Cada sección es normativa salvo que diga "Recomendado". Las palabras **DEBE**, **NO DEBE** y **PUEDE** tienen el sentido de RFC 2119.

---

## 0. Cómo usar este documento

1. Crear un repositorio vacío `truckdepot/magia` y copiar esta carpeta `magia_handoff/` en `docs/spec/`.
2. Abrir Claude Code en la raíz y ejecutar: `Lee docs/spec/README.md y docs/spec/SPEC.md. Implementa el hito M0 de la sección 23. Planifica antes de codificar y espera mi aprobación del plan.`
3. Avanzar hito por hito (M0 → M6). Cada hito tiene criterios de aceptación verificables; no se avanza sin cumplirlos.
4. Las plantillas en `templates/` son el contenido inicial literal de los archivos que MAGIA instala.

---

## 1. Objetivo

MAGIA es un **paquete instalable** que convierte el estándar de calidad, seguridad y gobierno de IA de Truck Depot en archivos, validaciones y guardas ejecutables dentro de cada repositorio de trabajo de la corporación.

Al instalarse en un repositorio, MAGIA:

1. Analiza el repositorio (área, stack, datos, superficie de cliente).
2. Clasifica riesgo y nivel de autonomía.
3. **Genera con IA** las Skills, Rules locales, subagentes, comandos y contexto específicos de ese proyecto, a partir de plantillas canónicas.
4. Instala las **Rules corporativas inmutables** (R1–R9) y las hace cumplir con hooks, CI y guardas de runtime.
5. Deja trazabilidad completa para el Comité MAGIA.

**Doble mandato:**

1. **Potenciar.** La IA hace la mayor parte del trabajo de cada proyecto —especificar, diseñar, construir, probar, documentar, desplegar, optimizar y mejorar en producción—. El esfuerzo humano se concentra en **decidir qué construir** y **aprobar con evidencia**.
2. **Gobernar.** Esa potencia opera siempre dentro del estándar de calidad, seguridad y gobierno de Truck Depot.

MAGIA tiene dos motores: el **Motor de Valor** (secciones 26–32), que genera y acelera, y el **Motor de Gobierno** (secciones 7–22), que garantiza. Son inseparables: la gobernanza automática es precisamente lo que permite delegar más trabajo a la IA con seguridad.

### 1.1 Fuera de alcance (v1)
- Hosting de modelos propios.
- UI web de administración del Comité (v2; en v1 el Comité opera con `magia audit` y archivos firmados).
- Entrenamiento o fine-tuning de modelos.

---

## 2. Principios de diseño

Inspirados en prácticas publicadas por Anthropic, traducidos a requisitos.

| # | Principio | Requisito de implementación |
|---|---|---|
| P1 | Constitución antes que reglas sueltas (Constitutional AI) | Todo agente generado DEBE cargar `CONSTITUCION.md` como contexto. Las rúbricas de evals DEBEN derivarse de ella. |
| P2 | Salvaguardas proporcionales al riesgo (Responsible Scaling Policy) | Las Skills obligatorias se calculan de `riesgo × autonomía` (sección 16). Subir de nivel NUNCA reduce salvaguardas. |
| P3 | Simple primero (Building Effective Agents) | El agente instalador y los subagentes DEBEN proponer el patrón más simple de la sección 16.3 y justificar cualquier escalamiento con un eval. |
| P4 | Evals antes que código | `magia gate` DEBE fallar si el proyecto no tiene golden set con el mínimo de casos por riesgo. |
| P5 | El contexto es el producto | `MAGIA.md` DEBE existir, estar versionado e importado desde `CLAUDE.md`. |
| P6 | Datos conectados, no copiados (MCP) | Solo servidores MCP de la allowlist corporativa en `.mcp.json`; permisos mínimos. |
| P7 | Fluidez 4D (Delegación, Descripción, Discernimiento, Diligencia) | Cada etapa del ciclo (sección 3) declara qué se delega, cómo se instruye, cómo se evalúa y quién responde. |
| P8 | Inmutabilidad del núcleo | El núcleo corporativo se instala con hash; cualquier modificación rompe CI (Rule R8). |
| P9 | La IA hace, el humano decide | El humano interviene solo en los puntos de decisión de la sección 3.1. Todo lo demás lo ejecutan agentes. |
| P10 | Confianza por evidencia | Los humanos aprueban leyendo un Paquete de Evidencia (sección 27.2), no revisando línea por línea. |
| P11 | Nada se construye dos veces | Toda capacidad validada se publica en el Registro MAGIA y se reutiliza (sección 28). |
| P12 | Mejora autónoma continua | La telemetría de producción genera automáticamente evals y PRs de mejora (sección 30). |
| P14 | Las suposiciones caducan | Todo andamiaje declara qué limitación del modelo compensa y se retira cuando deja de aportar (ANTHROPIC-FRAMEWORKS AF7). |
| P15 | Fallas diagnosticadas por propiedad | Toda falla se etiqueta según las 4 propiedades de la IA y se corrige con el manual correspondiente (AF2). |
| P16 | Autonomía dentro de un sandbox | Más autonomía solo dentro de límites de archivos y red declarados (AF10). |
| P13 | El mejor modelo para cada tarea | Enrutamiento por evals: frontera para razonar y diseñar, modelos eficientes para tareas acotadas (sección 31). |

---

## 3. Ciclo de desarrollo MAGIA

Cada etapa termina en un gate verificable. Los comandos `/magia-*` son slash commands de Claude Code instalados por MAGIA (sección 13).

| Etapa | Comando | La IA acelera | El humano decide | Gate de salida (verificable) |
|---|---|---|---|---|
| 1. Descubrir | `/magia-brief` | Investigación de contexto, borrador de brief | Problema, valor, qué se delega | `docs/magia/brief.md` con campos obligatorios completos |
| 2. Especificar | `/magia-spec` | Spec, casos de prueba, golden set inicial | Criterios de éxito, umbrales | `evals/golden-set.jsonl` ≥ mínimo por riesgo; `docs/magia/spec.md` |
| 3. Planificar | `/magia-plan` | Exploración del repo y plan técnico | Aprobación del plan | `docs/magia/plans/<id>.md` con `status: approved` y aprobador |
| 4. Construir | — | Código, tests (TDD), docs; subagentes en paralelo | Revisión de código | Tests verdes; `magia check` sin errores |
| 5. Evaluar | `/magia-eval` | Evals, LLM-como-juez, red-team | Revisión de muestras y casos límite | `magia eval` ≥ umbrales; reporte en `.magia/reports/` |
| 6. Liberar | `/magia-gate` | Canary, detección de regresiones | Aprobación del Comité (riesgo medio/alto) | `magia gate` exit 0 + aprobación firmada si aplica |
| 7. Operar | — | Telemetría, drift, propuestas a Skills | Priorización | Reporte trimestral `magia audit` |

Las siete etapas se ejecutan de punta a punta con un solo comando: `/magia-ship <intención>` o `magia run "<intención>"` (sección 27).

### 3.1 Esfuerzo humano mínimo por nivel de riesgo

Estos son los **únicos** puntos donde el pipeline se detiene a esperar a una persona. Fuera de ellos, los agentes avanzan solos.

| Decisión humana | Riesgo bajo | Riesgo medio | Riesgo alto |
|---|---|---|---|
| Expresar la intención (un párrafo o un ticket) | Sí | Sí | Sí |
| Aprobar spec + criterios de éxito | Automático | Automático | Sí |
| Aprobar plan técnico | Automático | Sí | Sí |
| Aprobar merge (leyendo el Paquete de Evidencia) | Sí | Sí | Sí |
| Aprobar liberación a producción | Automático tras gate | Comité | Comité |

En riesgo bajo, un proyecto va de intención a producción con **dos intervenciones humanas**. Además, el agente solo escala por excepción (sección 27.1).

---

## 4. Arquitectura

### 4.1 Tres capas

| Capa | Ubicación en repo destino | Quién la escribe | ¿Se puede modificar? |
|---|---|---|---|
| **Core** | `.magia/core/` | Paquete MAGIA (copia literal) | NO. Protegida por `magia.lock` (SHA-256). |
| **Generada** | `.claude/`, `MAGIA.md`, `.magia/generated/` | Agente instalador (IA) | Solo regenerando (`magia generate`). Edición manual se detecta y advierte. |
| **Local** | `.magia/local/` | Equipo del proyecto | Sí, pero NO puede debilitar Core (validado por `magia check`). |

Regla de precedencia: **Core > Local > Generada** para restricciones. Local solo puede **agregar** restricciones o Skills, nunca quitar.

### 4.2 Dos planos

| Plano | Qué es | Implementación |
|---|---|---|
| **Desarrollo** | Cómo trabaja el agente de código (Claude Code) dentro del repo | `CLAUDE.md`, `MAGIA.md`, `.claude/skills/`, `.claude/agents/`, `.claude/commands/`, `.claude/settings.json` (hooks, permisos), `.mcp.json` |
| **Ejecución** | Cómo se comporta la IA dentro del producto en producción | SDK `@truckdepot/magia-runtime` (TS) / `magia_runtime` (Python, M5): guardas `dataShield`, `grounding`, `hallucinationGuard`, `humanCheckpoint`, `brandVoice`, `telemetry` |

Una misma Skill PUEDE tener cara de desarrollo (instrucciones al agente) y cara de ejecución (guarda en SDK). La tabla de la sección 11 indica cuál.

Un tercer plano, **Aceleración**, agrupa los agentes del Motor de Valor (secciones 26–32), que trabajan sobre ambos planos para producir el proyecto con el mínimo esfuerzo humano.

---

## 5. Estructura del repositorio `truckdepot/magia` (monorepo)

```
magia/
├─ packages/
│  ├─ cli/                     # @truckdepot/magia  (bin: magia)
│  │  ├─ src/commands/         # init, generate, check, eval, gate, audit, doctor, upgrade, exception
│  │  ├─ src/scan/             # detección de stack, área, datos sensibles
│  │  ├─ src/generate/         # orquestación del agente instalador
│  │  ├─ src/validate/         # validadores de config, lock, rules, skills
│  │  └─ src/hooks/            # scripts ejecutados por hooks de Claude Code
│  ├─ core/                    # @truckdepot/magia-core (contenido inmutable)
│  │  ├─ CONSTITUCION.md
│  │  ├─ rules/R1.md … R9.md
│  │  ├─ skills/<skill>/SKILL.md.tpl
│  │  ├─ agents/<agent>.md.tpl
│  │  ├─ commands/<cmd>.md.tpl
│  │  ├─ presets/areas/<area>.json
│  │  ├─ prompts/installer.md
│  │  ├─ schemas/magia.config.schema.json
│  │  ├─ schemas/eval-case.schema.json
│  │  ├─ schemas/telemetry-event.schema.json
│  │  └─ mcp/allowlist.json
│  ├─ runtime-ts/              # @truckdepot/magia-runtime
│  └─ runtime-py/              # magia_runtime (M5)
├─ examples/
│  ├─ sac-chatbot/             # repo de ejemplo riesgo alto, NM-2
│  └─ marketing-content/       # repo de ejemplo riesgo bajo, NM-1
├─ docs/spec/                  # esta carpeta
└─ .github/workflows/
```

**Stack por defecto (decisión abierta, ver sección 25):** TypeScript + Node ≥ 20, pnpm workspaces, Vitest, Zod para validación, `ajv` para JSON Schema. Distribución vía registry npm privado de Truck Depot.

---

## 6. Estructura instalada en un repositorio destino

```
<repo>/
├─ CLAUDE.md                   # generado o extendido; contiene "@MAGIA.md"
├─ MAGIA.md                    # contexto del proyecto (Skill magia-context)
├─ magia.config.json           # configuración declarativa (sección 7)
├─ magia.lock                  # versión + hashes del Core
├─ .mcp.json                   # solo servidores de la allowlist
├─ .claude/
│  ├─ settings.json            # permisos + hooks MAGIA (sección 14)
│  ├─ skills/magia-*/SKILL.md  # Skills generadas para este proyecto
│  ├─ agents/magia-*.md        # subagentes (sección 12)
│  └─ commands/magia-*.md      # slash commands (sección 13)
├─ .magia/
│  ├─ core/                    # copia inmutable (Constitución, Rules)
│  ├─ generated/manifest.json  # qué se generó, desde qué plantilla, modelo, fecha
│  ├─ local/                   # extensiones del equipo
│  ├─ exceptions/              # excepciones firmadas por el Comité
│  └─ reports/                 # resultados de eval, gate, audit
├─ evals/
│  ├─ golden-set.jsonl
│  └─ rubrics/*.md
└─ docs/magia/
   ├─ brief.md
   ├─ spec.md
   └─ plans/
```

---

## 7. `magia.config.json`

Schema completo: `templates/magia.config.schema.json`. Campos:

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `version` | string semver | sí | Versión de MAGIA instalada |
| `profile` | enum | sí | `flow`, `estandar`, `forge` (sección 33). Sugerido por scan; bajar de perfil requiere excepción |
| `lane` | enum | no | `produccion` (defecto) o `exploracion` (Forge F14.3) |
| `project.name` | string | sí | Nombre del proyecto |
| `project.area` | enum | sí | `tienda`, `sitio`, `sac`, `marketing`, `operaciones`, `compras`, `creditos-cobros`, `contabilidad`, `bi`, `auditoria`, `rrhh`, `it`, `otra` |
| `project.owner` | string (email) | sí | AI Champion responsable |
| `risk` | enum | sí | `bajo`, `medio`, `alto` (calculado; puede subirse, no bajarse sin excepción) |
| `autonomy` | enum | sí | `NM-1`, `NM-2`, `NM-3`, `NM-4` |
| `customerFacing` | boolean | sí | ¿Interactúa con clientes externos? |
| `dataClasses` | array enum | sí | `publico`, `interno`, `confidencial`, `restringido` |
| `stack.languages` | array string | sí | Detectado por scan |
| `models.allowed` | array string | sí | IDs de modelos aprobados por el Comité |
| `skills.required` | array string | calculado | Derivado de sección 16. No editable manualmente. |
| `skills.extra` | array string | no | Skills adicionales opcionales |
| `thresholds` | objeto | sí | Ver sección 15.3; valores ≥ mínimos corporativos |
| `mcp.servers` | array string | no | IDs de la allowlist |
| `telemetry.endpoint` | string URL | sí | Endpoint corporativo |
| `exceptions` | array string | no | IDs de archivos en `.magia/exceptions/` |

`magia check` DEBE fallar si: el schema no valida; `risk` es menor que el calculado sin excepción; `skills.required` difiere del cálculo; algún umbral está por debajo del mínimo corporativo.

---

## 8. Instalación: `magia init`

### 8.1 Secuencia

| Paso | Acción | Determinista o IA | Salida |
|---|---|---|---|
| 1 | Verificar prerequisitos (git limpio, Node, `claude` CLI disponible, credenciales vía vault) | Determinista | Error claro si falta algo |
| 2 | **Scan**: lenguajes, frameworks, dependencias de LLM, rutas con datos sensibles (regex + heurística de nombres: `rut`, `dni`, `email`, `tarjeta`, `salario`…), endpoints públicos | Determinista | `.magia/generated/scan.json` |
| 3 | Preguntas interactivas mínimas: área, owner, `customerFacing`, autonomía deseada (con valores sugeridos del scan). Modo `--yes` usa sugerencias. | Interactivo | Respuestas |
| 4 | Calcular `risk` y `skills.required` (sección 16) | Determinista | `magia.config.json` |
| 5 | Copiar Core a `.magia/core/` y escribir `magia.lock` | Determinista | Core + lock |
| 6 | **Generación por IA**: invocar Claude Code headless con `prompts/installer.md` + scan + config + plantillas | IA | `MAGIA.md`, `.claude/skills/*`, `.claude/agents/*`, `.claude/commands/*`, `evals/rubrics/*`, golden set semilla |
| 7 | Escribir `.claude/settings.json` (hooks y permisos) y `.mcp.json` desde plantillas | Determinista | Archivos |
| 8 | Insertar `@MAGIA.md` en `CLAUDE.md` (crear si no existe; nunca borrar contenido previo) | Determinista | `CLAUDE.md` |
| 9 | Validar todo con `magia check`; si falla, revertir los archivos escritos | Determinista | Exit 0 o rollback |
| 10 | Escribir `.magia/generated/manifest.json` y mostrar resumen | Determinista | Manifest |

Invocación del paso 6 (referencia):

```bash
claude -p "$(cat .magia/tmp/installer-input.md)" \
  --output-format json \
  --allowedTools "Read,Write,Edit,Glob,Grep" \
  --append-system-prompt "$(cat .magia/core/CONSTITUCION.md)"
```

Alternativa recomendada para producción: Claude Agent SDK desde `packages/cli/src/generate/` para controlar herramientas, timeouts y validación de salida.

### 8.2 Contrato del agente instalador
- DEBE escribir solo dentro de `.claude/`, `MAGIA.md`, `evals/`, `.magia/generated/`.
- NO DEBE modificar `.magia/core/`, código de la aplicación ni `magia.config.json`.
- DEBE producir cada Skill con frontmatter válido (`name`, `description`) y las secciones obligatorias de la sección 11.2.
- DEBE adaptar ejemplos, rutas y comandos al repositorio real (no texto genérico). `magia check` rechaza Skills con marcadores `{{` sin resolver o sin referencias a rutas existentes.
- Prompt completo: `templates/installer-prompt.md`.

### 8.3 Idempotencia
`magia init` en un repo ya instalado DEBE abortar con sugerencia de `magia generate` o `magia upgrade`. `magia generate` regenera la capa Generada; si detecta ediciones manuales (hash distinto al manifest) DEBE pedir confirmación o `--force`.

---

## 9. CLI

| Comando | Descripción | Exit codes |
|---|---|---|
| `magia init [--yes] [--area <a>] [--autonomy <NM-x>]` | Instala MAGIA (sección 8) | 0 ok · 1 error · 3 prerequisito faltante |
| `magia generate [--only skills\|agents\|context] [--force]` | Regenera capa Generada | 0 · 1 · 4 ediciones manuales sin `--force` |
| `magia check [--json]` | Valida config, lock, Rules, Skills, settings, MCP | 0 · 2 violación |
| `magia eval [--suite <name>] [--json]` | Ejecuta evals contra umbrales | 0 · 2 bajo umbral |
| `magia gate` | `check` + `eval` + red-team (si aplica) + aprobaciones requeridas | 0 · 2 bloqueado |
| `magia audit [--since <fecha>]` | Reporte para Comité (uso, calidad, incidentes, excepciones) | 0 |
| `magia exception request <rule> --reason "<texto>"` | Crea solicitud de excepción | 0 |
| `magia doctor` | Diagnóstico de instalación | 0 · 1 |
| `magia upgrade [--to <version>]` | Actualiza Core y regenera si cambian plantillas | 0 · 1 |
| `magia run "<intención>" [--until spec\|plan\|pr\|release] [--resume <id>]` | Pipeline autónomo (sección 27) | 0 · 2 gate bloqueado · 5 espera decisión humana |
| `magia scout` | Detecta oportunidades de valor y genera backlog priorizado (sección 29) | 0 |
| `magia improve [--from telemetry\|evals]` | Genera PRs de mejora desde fallas reales (sección 30) | 0 · 2 |
| `magia optimize [--prompts] [--models]` | Optimiza prompts y enrutamiento de modelos guiado por evals (sección 31) | 0 · 2 |
| `magia learn` · `magia registry pull <capacidad>` | Publica o instala capacidades del Registro MAGIA (sección 28) | 0 · 1 |

Toda salida humana en español. `--json` para CI. Los mensajes de error DEBEN indicar la Rule violada (`R1`…`R9`), el archivo y la acción correctiva.

---

## 10. Rules corporativas (Core, inmutables)

Cada Rule vive en `.magia/core/rules/Rn.md` con frontmatter `id`, `title`, `enforcement[]`, `severity`.

| ID | Enunciado | Cumplimiento (dónde se hace cumplir) | Detección |
|---|---|---|---|
| **R1** | Ningún output generativo se muestra al usuario en riesgo medio/alto sin fuente verificable | Runtime: `grounding.require()` · Eval: criterio `grounded` · Review: subagente `magia-reviewer` | Llamadas a LLM sin guarda `grounding` en rutas de cliente (análisis estático) |
| **R2** | Prohibido enviar datos personales a un modelo sin anonimizar o sin consentimiento | Runtime: `dataShield.redact()` obligatorio antes de cada llamada · Hook PreToolUse bloquea lectura de archivos de datos restringidos | Análisis estático: cliente LLM invocado sin pasar por `dataShield` |
| **R3** | Todo modelo o proveedor externo requiere aprobación del Comité | `check`: `models.allowed` ⊆ allowlist corporativa; dependencias LLM detectadas en scan ⊆ aprobadas | Scan de dependencias y IDs de modelo en código |
| **R4** | Toda funcionalidad de IA tiene fallback humano o mensaje de incertidumbre | Runtime: `hallucinationGuard.check()` devuelve `fallback` · Eval: casos sin respuesta conocida | Eval obligatorio de casos "no sé" en golden set |
| **R5** | Ningún despliegue sin `magia gate` aprobado | CI: job `magia-gate` requerido en rama protegida | Branch protection |
| **R6** | Credenciales solo desde vault corporativo | Hook PreToolUse/PostToolUse escanea secretos en Write/Edit · CI: secret scanning | Regex de llaves conocidas + entropía |
| **R7** | Interacción generativa con cliente se identifica como asistida por IA | Runtime: `brandVoice.disclose()` · Eval: criterio `disclosure` | Eval |
| **R8** | Ninguna Skill o Rule se desactiva sin aprobación del Comité | `check`: `magia.lock` íntegro; `skills.required` completo; Local no debilita Core | Hash SHA-256 |
| **R9** | Agentes acceden a sistemas corporativos solo vía conectores aprobados con permisos mínimos | `check`: `.mcp.json` ⊆ `mcp/allowlist.json`; scopes ≤ permitidos | Validación de `.mcp.json` |

**Severidad:** todas `blocking`. No existe modo "warn" para Rules Core; solo excepción firmada (sección 21.2).

---

## 11. Catálogo de Skills

### 11.1 Tabla

| Skill | Plano | Se requiere cuando | Función |
|---|---|---|---|
| `magia-context` | Dev | Siempre | Genera/mantiene `MAGIA.md` |
| `magia-quality-gate` | Dev + CI | Siempre | Orquesta `check` + `eval` antes de merge/deploy |
| `magia-evals` | Dev + CI | Siempre | Mantiene golden set, rúbricas y regresión |
| `magia-data-shield` | Dev + Runtime | Siempre | Clasifica y enmascara datos; guía al agente a no leer datos restringidos |
| `magia-perf-optimizer` | Dev + Runtime | Siempre | Presupuesto de latencia/costo/contexto; caching de prompts |
| `magia-telemetry` | Runtime | Siempre | Eventos estructurados (sección 19) |
| `magia-verify` | Dev | Siempre | Ejecuta tests, lee el diff y reporta evidencia antes de declarar terminado (sección 35) |
| `magia-grounding` | Dev + Runtime | Riesgo ≥ medio o NM ≥ 2 | RAG con citas obligatorias |
| `magia-hallucination-guard` | Runtime | Riesgo ≥ medio o NM ≥ 2 | Score de confianza y fallback |
| `magia-brand-voice` | Dev + Runtime | `customerFacing: true` | Idioma, tono, terminología, divulgación de IA |
| `magia-human-checkpoint` | Runtime | Riesgo alto o NM ≥ 3 | Confirmación humana antes de acciones irreversibles |
| `magia-red-team` | Dev + CI | Riesgo alto o NM ≥ 3 | Pruebas adversariales (inyección de prompt, jailbreak, exfiltración) |

### 11.2 Formato obligatorio de cada `SKILL.md` generado

```markdown
---
name: magia-<skill>
description: <una oración: qué hace y CUÁNDO debe activarse, en términos del proyecto>
magia:
  version: 1.0.0
  template: magia-<skill>@1.0.0
  rules: [R1, R4]
  plane: [dev, runtime]
---
# <Título>
## Cuándo usar           (disparadores concretos en ESTE repo: rutas, módulos, comandos)
## Procedimiento         (pasos numerados, verificables)
## Contratos             (entradas/salidas; para runtime, firma del SDK)
## Criterios de éxito    (cómo se verifica; enlazado a evals)
## Modo de falla         (qué hacer si no se cumple; nunca "continuar igual")
## Ejemplos del proyecto (≥ 1 ejemplo usando código/rutas reales del repo)
```

Plantilla de ejemplo completa: `templates/claude/skills/magia-grounding/SKILL.md`.

### 11.3 Contratos del SDK de runtime (TypeScript)

```ts
// @truckdepot/magia-runtime
export function createMagia(config: MagiaRuntimeConfig): Magia;

interface Magia {
  dataShield: {
    redact<T>(payload: T, opts?: { classes?: DataClass[] }): { payload: T; findings: Finding[] };
    assertAllowed(dataClass: DataClass): void;               // lanza MagiaRuleError('R2')
  };
  grounding: {
    retrieve(query: string, opts?: RetrieveOpts): Promise<Source[]>;
    require(answer: Draft, sources: Source[]): GroundedAnswer; // lanza MagiaRuleError('R1') si no hay citas válidas
  };
  hallucinationGuard: {
    check(answer: GroundedAnswer): { decision: 'pass' | 'fallback' | 'escalate'; score: number; reason?: string };
  };
  humanCheckpoint: {
    require(action: IrreversibleAction): Promise<Approval>;    // bloquea hasta aprobación o timeout → rechazo
  };
  brandVoice: {
    apply(text: string): string;
    disclose(channel: Channel): string;                       // texto de divulgación R7
  };
  telemetry: { emit(event: TelemetryEvent): void };
  // Envoltura recomendada que aplica todo en orden:
  respond(input: UserInput, handler: LlmHandler): Promise<MagiaResponse>;
}
```

Orden obligatorio dentro de `respond()`: `dataShield.redact` → `grounding.retrieve` → llamada LLM → `grounding.require` → `hallucinationGuard.check` → `brandVoice.apply/disclose` → `telemetry.emit`. Si `decision !== 'pass'`, devolver fallback configurado (R4).

---

## 12. Subagentes de Claude Code

Instalados en `.claude/agents/`. Frontmatter estándar de Claude Code (`name`, `description`, `tools`).

| Subagente | Propósito | Herramientas | Cuándo lo invoca el agente principal |
|---|---|---|---|
| `magia-planner` | Explora el repo y redacta plan técnico; elige el patrón más simple (16.3) | Read, Glob, Grep | Antes de cualquier cambio no trivial |
| `magia-reviewer` | Revisa diffs contra Constitución y Rules R1–R9 | Read, Glob, Grep, Bash(git diff:*) | Antes de commit/PR |
| `magia-evaluator` | Ejecuta y analiza `magia eval`; propone nuevos casos | Read, Bash(magia eval:*), Write(evals/**) | Tras cambios en prompts/lógica IA |
| `magia-red-teamer` | Genera y corre ataques adversariales | Read, Bash(magia eval --suite redteam:*) | Riesgo alto / NM ≥ 3 |
| `magia-security` | Revisa manejo de datos, secretos y MCP | Read, Glob, Grep | Cambios en integraciones o datos |
| `magia-architect` | De una intención produce brief, spec, golden set, arquitectura y ADRs; busca primero en el Registro | Read, Glob, Grep, Write(docs/**), Write(evals/**), Bash(npx magia registry:*) | Inicio de `magia run` |
| `magia-builder` | Orquestador: descompone el plan en un DAG de tareas y coordina trabajadores en paralelo | Read, Glob, Grep, Write, Edit, Bash(git worktree:*) | Etapa Construir |
| `magia-worker` | Implementa una tarea acotada con TDD en su propio worktree | Read, Write, Edit, Bash(npm test:*), Bash(git:*) | Invocado por `magia-builder` |
| `magia-fixer` | Bucle autocorrectivo: lee fallas de tests/evals/check y corrige hasta verde (máx. N iteraciones) | Read, Edit, Bash(npm test:*), Bash(npx magia eval:*), Bash(npx magia check:*) | Tras cualquier falla |
| `magia-documenter` | Docs, changelog, notas de versión, Paquete de Evidencia, `MAGIA.md` al día | Read, Write(docs/**), Edit(MAGIA.md) | Antes de cada PR |
| `magia-scout` | Encuentra oportunidades de valor en código, evals, telemetría y Registro | Read, Glob, Grep | Semanal o `magia scout` |

Plantilla: `templates/claude/agents/magia-reviewer.md`.

---

## 13. Slash commands

En `.claude/commands/`. Cada uno usa `$ARGUMENTS`.

| Comando | Comportamiento |
|---|---|
| `/magia-brief` | Entrevista breve y escribe `docs/magia/brief.md` (problema, usuario, valor, qué se delega, riesgo, autonomía) |
| `/magia-spec` | Escribe `docs/magia/spec.md` y genera casos iniciales en `evals/golden-set.jsonl` |
| `/magia-plan` | Invoca `magia-planner`; escribe plan con `status: draft`; detiene y pide aprobación |
| `/magia-review` | Invoca `magia-reviewer` sobre el diff actual |
| `/magia-eval` | Ejecuta `magia eval` y resume resultados y regresiones |
| `/magia-gate` | Ejecuta `magia gate` y explica cada bloqueo con su acción correctiva |
| `/magia-ship <intención>` | Pipeline autónomo completo (sección 27); se detiene solo en las decisiones de la sección 3.1 |
| `/magia-scout` | Presenta las 5 oportunidades de mayor valor con esfuerzo y riesgo |
| `/magia-improve` | Toma la falla o hallazgo de mayor impacto y lo convierte en PR con evidencia |

---

## 14. Hooks y permisos (`.claude/settings.json`)

Plantilla: `templates/claude/settings.json`. Comportamiento:

| Evento | Matcher | Script | Efecto |
|---|---|---|---|
| `SessionStart` | — | `magia hook session-start` | Inyecta recordatorio de nivel de riesgo/autonomía y Rules activas |
| `PreToolUse` | `Read\|Grep\|Glob` | `magia hook guard-read` | Bloquea (exit 2) lectura de rutas marcadas `restringido` (R2) y `.env*` (R6) |
| `PreToolUse` | `Write\|Edit` | `magia hook guard-write` | Bloquea escritura en `.magia/core/` y `magia.lock` (R8) |
| `PostToolUse` | `Write\|Edit` | `magia hook scan-secrets` | Bloquea si detecta secretos en el contenido escrito (R6) |
| `PreToolUse` | `Bash` | `magia hook guard-bash` | Bloquea comandos de despliegue sin gate (`deploy`, `kubectl apply`, etc. configurables) (R5) |
| `Stop` | — | `magia hook stop-check` | Ejecuta `magia check --json`; si falla, informa al agente para corregir antes de terminar |

Permisos `deny` mínimos: `Read(./.env*)`, `Read(./**/secrets/**)`, `Edit(./.magia/core/**)`, `Edit(./magia.lock)`.

---

## 15. Evals

### 15.1 Formato de caso (`evals/golden-set.jsonl`)
Una línea JSON por caso. Schema en `packages/core/schemas/eval-case.schema.json`. Ejemplo en `templates/evals/golden-set.example.jsonl`.

| Campo | Descripción |
|---|---|
| `id` | Único, `area-nnn` |
| `input` | Entrada del usuario |
| `context` | Fuentes o estado relevante (opcional) |
| `expected` | Respuesta de referencia o hechos que DEBE contener |
| `mustNot` | Contenido prohibido (datos sensibles, promesas, etc.) |
| `type` | `happy`, `edge`, `unknown` (debe responder fallback), `adversarial` |
| `criteria` | Lista de criterios a puntuar (15.2) |
| `tags` | Libre |

### 15.2 Criterios estándar

| Criterio | Método | Pasa si |
|---|---|---|
| `correct` | LLM-como-juez con rúbrica + comparación con `expected` | score ≥ umbral |
| `grounded` | Verificación de que cada afirmación tiene cita existente en `sources` | 100% en riesgo medio/alto |
| `no_hallucination` | Juez detecta afirmaciones sin respaldo | tasa ≤ umbral |
| `fallback_ok` | Casos `unknown` devuelven fallback | 100% |
| `no_leak` | Regex + juez sobre `mustNot` y PII | 0 fugas |
| `brand_voice` | Rúbrica de voz de marca | score ≥ umbral |
| `disclosure` | Presencia de divulgación IA en canal de cliente | 100% |
| `latency_p95` | Medición | ≤ SLA |
| `cost_per_call` | Medición | ≤ presupuesto |

El juez DEBE ser un modelo distinto o con prompt aislado del modelo evaluado; sus rúbricas derivan de `CONSTITUCION.md`.

### 15.3 Mínimos corporativos por riesgo

| Parámetro | Bajo | Medio | Alto |
|---|---|---|---|
| Casos mínimos en golden set | 20 | 50 | 100 |
| % casos `unknown` + `adversarial` | ≥ 10% | ≥ 20% | ≥ 30% |
| `correct` (promedio) | ≥ 0.80 | ≥ 0.85 | ≥ 0.92 |
| `no_hallucination` (tasa máx.) | ≤ 5% | ≤ 2% | ≤ 0.5% |
| `grounded` | — | 100% | 100% |
| Regresión permitida vs. versión anterior | ≤ 2 pts | ≤ 1 pt | 0 |
| Red-team | — | Recomendado | Obligatorio |

> Valores iniciales propuestos; el Comité MAGIA los ratifica en M0. Se configuran en `packages/core/presets/thresholds.json`.

---

## 16. Matriz de riesgo, autonomía y patrones

### 16.1 Cálculo de riesgo (determinista)
`risk = max(riesgoBaseArea, riesgoPorDatos, riesgoPorCliente)` donde:
- `riesgoPorDatos`: `restringido` → alto · `confidencial` → medio · resto → bajo
- `riesgoPorCliente`: `customerFacing` → medio
- `riesgoBaseArea`: sección 17

### 16.2 Niveles de autonomía

| Nivel | Autonomía | Skills adicionales obligatorias | Aprobaciones |
|---|---|---|---|
| NM-1 Asistente | La IA sugiere; humano ejecuta | — (base) | AI Champion |
| NM-2 Copiloto | Ejecuta acciones reversibles | grounding, hallucination-guard | AI Champion |
| NM-3 Agente supervisado | Flujos multi-paso con herramientas | + human-checkpoint, red-team | Comité |
| NM-4 Agente autónomo | Sin aprobación por acción | + monitoreo en tiempo real, kill-switch (`MAGIA_KILL=1`) | Comité + excepción firmada; auditoría mensual |

`skills.required = base ∪ porRiesgo(risk) ∪ porAutonomia(autonomy) ∪ (customerFacing ? [brand-voice] : [])`

### 16.3 Patrones aprobados (elegir el más simple que pase evals)

| # | Patrón | Usar cuando | Ejemplo Truck Depot |
|---|---|---|---|
| 1 | Llamada única + RAG | Pregunta-respuesta sobre fuente conocida | Compatibilidad de repuesto por modelo |
| 2 | Encadenamiento | Pasos fijos verificables | Ficha técnica → validación → voz de marca |
| 3 | Enrutamiento | Entradas de tipos distintos | Ticket SAC → cobros / despacho / garantía |
| 4 | Paralelización | Subtareas independientes o votación | Contrato revisado por cumplimiento y riesgo |
| 5 | Orquestador–trabajadores | Plan no conocido a priori | Migración de catálogo por categoría |
| 6 | Evaluador–optimizador | Criterio claro; iterar mejora | Descripción refinada hasta pasar brand-voice |
| 7 | Agente autónomo | Problema abierto multi-paso | Diagnóstico de incidentes IT (solo NM-3+) |

`magia-planner` DEBE declarar el patrón elegido y por qué el anterior no basta.

---

## 17. Presets por área

Archivos `packages/core/presets/areas/<area>.json`: `{ "area", "riskBase", "extraSkills", "suggestedAutonomy", "mcpSuggested", "notes" }`.

| Área | riskBase | extraSkills | Autonomía sugerida |
|---|---|---|---|
| tienda / sitio | medio | grounding, brand-voice | NM-2 |
| sac | alto | grounding, hallucination-guard, human-checkpoint, brand-voice | NM-2 |
| marketing | bajo | brand-voice | NM-1 |
| operaciones | medio | grounding | NM-2 |
| compras | medio | grounding | NM-1 |
| creditos-cobros | alto | hallucination-guard, human-checkpoint | NM-1 |
| contabilidad | medio | grounding | NM-1 |
| bi | medio | grounding | NM-2 |
| auditoria | alto | grounding, human-checkpoint | NM-1 |
| rrhh | alto | hallucination-guard, human-checkpoint | NM-1 |
| it | medio | — | NM-2 |
| otra | medio | — | NM-1 |

---

## 18. CI/CD

Plantilla: `templates/ci/magia-gate.yml` (GitHub Actions; adaptar si se usa otra plataforma).
- Job `magia-check` en cada PR.
- Job `magia-eval` en cada PR que toque prompts, lógica IA o `evals/`.
- Job `magia-gate` requerido para merge a `main` (branch protection, R5).
- Artefactos: `.magia/reports/*.json` adjuntos al PR; comentario resumen en el PR.
- Opcional: `anthropics/claude-code-action` para ejecutar `/magia-review` en PRs.

---

## 19. Telemetría

Schema: `packages/core/schemas/telemetry-event.schema.json`.

```json
{
  "ts": "2026-10-02T14:03:11Z",
  "project": "sac-chatbot",
  "area": "sac",
  "env": "prod",
  "event": "llm.response",
  "model": "<model-id>",
  "latencyMs": 812,
  "inputTokens": 1430,
  "outputTokens": 212,
  "costUsd": 0.0041,
  "decision": "pass",
  "confidence": 0.93,
  "grounded": true,
  "sourcesCount": 3,
  "redactions": 1,
  "ruleViolations": [],
  "traceId": "…"
}
```

Eventos: `llm.request`, `llm.response`, `guard.fallback`, `guard.escalate`, `checkpoint.requested`, `checkpoint.decided`, `rule.violation`, `killswitch.triggered`.
NO DEBE registrarse contenido de prompts/respuestas con datos `confidencial` o `restringido` sin redactar.

---

## 20. Seguridad

| Tema | Requisito |
|---|---|
| Clasificación de datos | `publico`, `interno`, `confidencial`, `restringido`. Rutas y campos se declaran en `.magia/local/data-map.json` (sugerido por scan, confirmado por el equipo). |
| Secretos | Solo vault corporativo; nunca en repo, config ni prompts (R6). |
| Proveedores de modelo | Allowlist con retención, residencia y uso para entrenamiento evaluados (R3). |
| MCP | Allowlist con scopes máximos por servidor; lectura por defecto; escritura solo NM-3+ con checkpoint (R9). |
| Inyección de prompt | Contenido externo (web, documentos, emails) se trata como no confiable: delimitado, sin capacidad de cambiar instrucciones; suite red-team obligatoria en riesgo alto. |
| Kill-switch | Variable `MAGIA_KILL=1` o flag remoto desactiva la IA y activa fallback en < 1 min (NM-3+). |

---

## 21. Gobernanza

### 21.1 Roles
| Rol | Responsabilidad en el sistema |
|---|---|
| Comité MAGIA | Ratifica umbrales, allowlists, excepciones; recibe `magia audit` trimestral |
| Arquitecto de IA Corporativo | Mantiene `magia-core`; publica versiones |
| AI Champion de área | Owner en `magia.config.json`; aprueba planes y gates NM-1/NM-2 |
| Oficial de Riesgo IA | Revisa excepciones e incidentes |

### 21.2 Excepciones
Archivo `.magia/exceptions/EXC-<yyyy>-<nnn>.yaml`: `rule`, `scope`, `reason`, `mitigations`, `expires` (máx. 90 días), `approvedBy[]`, `signature`. `magia check` acepta la desviación solo si la excepción es válida, vigente y firmada. Firma v1: commit firmado (GPG/SSH) por miembro del Comité listado en `packages/core/governance/committee.json`.

### 21.3 Auditoría
`magia audit` produce `.magia/reports/audit-<fecha>.md` + `.json`: versión instalada, integridad del lock, resultados de eval históricos, violaciones, excepciones activas, incidentes, costo.

---

## 22. Versionado
- `magia-core` sigue semver. Cambio de Rule o umbral más estricto = minor; relajación = major y requiere Comité.
- `magia upgrade` muestra diff de Core y regenera capa Generada si cambiaron plantillas.
- `magia.lock` registra versión y hash de cada archivo Core.

---

## 23. Plan de implementación (hitos para Claude Code)

| Hito | Entregable | Criterios de aceptación |
|---|---|---|
| **M0 Fundación** | Monorepo, `packages/core` con Constitución, R1–R9, schemas, presets, thresholds | Schemas validan ejemplos; tests de presets; `pnpm test` verde |
| **M1 CLI base** | `magia init` (pasos 1–5, 7–10 sin IA), `check`, `doctor`, lock | En `examples/marketing-content`: init → check exit 0; editar `.magia/core/*` → check exit 2 con mensaje R8 |
| **M2 Generación con IA** | Paso 6: agente instalador, plantillas de Skills/agentes/commands, `generate` | Skills generadas pasan validación 11.2; contienen ≥ 1 ruta real del repo; sin `{{`; manifest correcto; idempotencia probada |
| **M3 Hooks y guardas dev** | `.claude/settings.json`, `magia hook *` | Tests: lectura de `.env` bloqueada (exit 2); escritura en Core bloqueada; secreto detectado bloqueado |
| **M4 Evals y gate** | `eval`, `gate`, juez LLM, workflow CI | En `examples/sac-chatbot`: gate falla con golden set < 100; pasa al completar; regresión bloquea |
| **M5 Runtime SDK** | `magia-runtime` TS (y Python) con `respond()` | Tests unitarios por guarda; ejemplo SAC usa `respond()`; R1/R2/R4/R7 verificados por evals |
| **M6 Gobernanza** | Excepciones firmadas, `audit`, kill-switch, telemetría | Excepción vencida rechazada; audit genera reporte completo; kill-switch activa fallback |
| **M7 Pipeline autónomo** | `magia run`, `/magia-ship`, architect/builder/worker/fixer/documenter, Paquete de Evidencia, reanudación | En `examples/marketing-content`: de intención a PR aprobable con ≤ 2 intervenciones humanas; el PR pasa gate al primer intento o el fixer lo corrige en ≤ 5 iteraciones; `--resume` retoma un run interrumpido |
| **M8 Registro y reutilización** | `magia-registry`, `learn`, `registry pull`, búsqueda en architect e init | Capacidad publicada desde el ejemplo A se recomienda e instala en el ejemplo B; architect justifica cuando no reutiliza |
| **M9 Mejora autónoma** | `scout`, `improve`, `optimize`, enrutamiento de modelos | Falla simulada en telemetría → caso eval nuevo → PR de mejora que pasa gate; `optimize` reduce costo o latencia sin bajar ningún umbral |
| **M10 Forge I** | Cartografía, contratos, impacto, plan en olas (`modules/FORGE.md` FG1–FG2) | Criterios FG1–FG2 |
| **M11 Forge II** | Flota, verificación diferencial, merge a escala, presupuesto (FG3–FG4) | Criterios FG3–FG4 |
| **M12 Forge III** | MAGIA Bench, Radar de Frontera, migraciones, SRE (FG5–FG6) | Criterios FG5–FG6 |
| **M13 Flow** | Intake, recetas, gates ligeros, publicación en espacio de trabajo (`modules/FLOW.md` FL1–FL4) | Criterios FL1–FL4 |
| **M14 Marcos Anthropic** | AFM1–AFM6 (`modules/ANTHROPIC-FRAMEWORKS.md`) | Criterios AFM1–AFM6. AFM1 y AFM2 se implementan junto con M4 y M7 |
| **M15 Claude Code in Action** | CCM1–CCM5 (`modules/CLAUDE-CODE-IN-ACTION.md`) | Criterios CCM1–CCM5. CCM3 (`magia-verify` + gate de fin de turno) se adelanta a M3; CCM5 (plugins) se adelanta a M1 como mecanismo de distribución |
| **M16 AI Fluency** | AFFM1–AFFM5 (`modules/AI-FLUENCY.md`) | Criterios AFFM1–AFFM5. AFFM1 y AFFM2 se adelantan a M2 (el agente instalador ya genera Skills 3P y Plan de Delegación) |
| **M17 Claude API** | APIM1–APIM6 (`modules/CLAUDE-API.md`) | Criterios APIM1–APIM6. Se construye junto con M5 (SDK de runtime); APIM3 (RAG) es prerequisito del piloto SAC |
| **M18 MAGIA Diario** | SBM1–SBM5 (`modules/AI-FLUENCY-OPERATIONS.md`) | Criterios SBM1–SBM5. SBM1 y SBM2 PUEDEN ejecutarse desde el día uno, antes de cualquier desarrollo |

M0–M6 construyen el Motor de Gobierno; M7–M9, el Motor de Valor. Orden: M0 → M4, luego **M7 en paralelo a M5–M6** (el pipeline autónomo depende de `check` y `eval`, no del SDK de runtime), luego M8 → M9 → M10–M12 (Forge, prioridad del programa). M13 (Flow) PUEDE correr en paralelo desde M7 con un equipo distinto, porque no depende de Forge. Desde M7, los hitos siguientes DEBEN construirse usando el propio `/magia-ship` (MAGIA se construye con MAGIA). En cada hito: `/magia-plan` (o plan equivalente) → aprobación → implementación con TDD → revisión.

---

## 24. Definición de terminado (global)
- Toda función pública con tests; cobertura ≥ 85% en `cli` y `runtime`.
- Mensajes al usuario en español, directos, con Rule y acción correctiva.
- Ningún secreto en repo (scan en CI).
- `examples/` instalados con MAGIA y pasando `magia gate`.
- Documentación de cada comando en `docs/cli/<comando>.md`.

---

## 25. Decisiones abiertas (confirmar antes de M1)

| # | Decisión | Propuesta por defecto |
|---|---|---|
| D1 | Lenguaje del CLI | TypeScript / Node 20 |
| D2 | Modelos aprobados iniciales y proveedor | Modelos Claude vía API corporativa |
| D3 | Plataforma CI | GitHub Actions |
| D4 | Backend de telemetría | Endpoint HTTP corporativo → almacén de logs existente |
| D5 | Vault de secretos | El vault corporativo vigente |
| D6 | Servidores MCP iniciales de la allowlist | Catálogo de productos (lectura), inventario (lectura), tickets SAC (lectura) |
| D7 | Umbrales de la sección 15.3 | Ratificar en Comité M0 |
| D8 | Mecanismo de firma de excepciones | Commits firmados (v1) |
| D9 | Alojamiento del Registro MAGIA | Repositorio git interno `truckdepot/magia-registry` |
| D10 | Presupuesto por run (iteraciones, tokens, tiempo) | Fixer máx. 5 iteraciones; presupuesto de costo por nivel de riesgo definido por el Comité |
| D11 | Auto-merge de mejoras en riesgo bajo | Desactivado por defecto; opt-in del AI Champion |

---

## 26. Motor de Valor — visión

MAGIA no existe para frenar: su función principal es **multiplicar la capacidad de cada equipo**. El modelo operativo es:

- El humano expresa la **intención** (qué y por qué) y **aprueba con evidencia**.
- Los agentes MAGIA hacen el **cómo**: especifican, diseñan, construyen, prueban, documentan, despliegan, monitorean y mejoran.
- El Motor de Gobierno valida cada paso automáticamente. Por eso se puede delegar más.

### 26.1 Lo que la IA hace por defecto en cada proyecto

| Capacidad | Agente / comando | Resultado |
|---|---|---|
| Convertir una intención en spec, evals y plan | `magia-architect` | `brief.md`, `spec.md`, plan, golden set, ADRs |
| Reutilizar antes de construir | `magia-architect` + Registro | Capacidades validadas instaladas desde el día uno |
| Construir en paralelo | `magia-builder` + `magia-worker` | Código y tests por tarea en worktrees aislados |
| Corregirse hasta pasar | `magia-fixer` | Tests, evals y check en verde sin intervención |
| Revisar | `magia-reviewer`, `magia-security`, `magia-red-teamer` | Hallazgos resueltos antes del PR |
| Documentar | `magia-documenter` | Docs, changelog, notas de versión, `MAGIA.md` al día |
| Encontrar oportunidades | `magia scout` | Backlog priorizado por valor |
| Mejorar en producción | `magia improve` | PRs de mejora desde fallas reales |
| Optimizar costo y latencia | `magia optimize` | Prompts y modelos más eficientes sin bajar calidad |

---

## 27. Pipeline autónomo (`magia run` · `/magia-ship`)

```
intención
  → [A] magia-architect: busca en Registro → brief + spec + golden set + arquitectura + ADRs
  → DECISIÓN HUMANA (solo si la tabla 3.1 lo exige: spec y/o plan)
  → [B] magia-builder: descompone el plan en un DAG de tareas independientes
  → [C] magia-worker × N en paralelo (git worktrees), TDD por tarea
  → [D] integración + magia-fixer (bucle: tests → check → evals → corregir; máx. N)
  → [E] magia-reviewer + magia-security + magia-red-teamer (según riesgo)
  → [F] magia-documenter: docs + Paquete de Evidencia
  → [G] PR en rama magia/<id>
  → DECISIÓN HUMANA: merge
  → [H] canary + monitoreo + rollback automático ante regresión
```

### 27.1 Reglas del pipeline
- **Escalamiento por excepción.** El agente se detiene y pregunta SOLO si: (a) un gate sigue fallando tras N iteraciones del fixer; (b) existe una ambigüedad que cambia el resultado; (c) corresponde una decisión de la tabla 3.1. Las preguntas se agrupan en un único mensaje, con opciones y una recomendación.
- **Presupuesto.** Cada run tiene límite de iteraciones, costo y tiempo según riesgo (D10). Al alcanzarlo, entrega lo hecho con estado claro; nunca deja el repo roto.
- **Estado persistente.** `docs/magia/runs/<id>/progress.md` y `state.json` registran tareas, decisiones y pendientes; `magia run --resume <id>` retoma sin perder contexto, incluso en otra sesión.
- **Paralelismo.** Tareas sin dependencias corren en paralelo en worktrees aislados; máximo configurable.
- **Aislamiento.** Todo el trabajo ocurre en la rama `magia/<id>`; nunca directamente en `main`.
- **Reutilización primero.** `magia-architect` DEBE consultar el Registro y justificar por escrito cuando construye algo que ya existe.

### 27.2 Paquete de Evidencia
Adjunto a cada PR en `.magia/reports/evidence-<id>.md`. Es lo que el humano lee para aprobar.

| Sección | Contenido |
|---|---|
| Intención y resultado | Qué se pidió, qué se entregó, qué quedó fuera |
| Resumen del cambio | Módulos tocados, decisiones de arquitectura (ADRs), patrón elegido y por qué |
| Calidad | Tests y cobertura; evals vs. umbrales y vs. versión anterior |
| Seguridad | Resultado de R1–R9, red-team, datos tocados y su clasificación |
| Riesgos y supuestos | Lo que el agente no pudo verificar |
| Costo | Costo del run; costo estimado por interacción en producción |
| Cómo probarlo | Pasos para validarlo manualmente en 5 minutos |
| Declaración de Diligencia | Papel de la IA, papel de las personas, verificación, limitaciones y responsable (AF14) |

La revisión línea por línea es opcional en riesgo bajo y medio; obligatoria solo en archivos marcados como críticos en `MAGIA.md` y en riesgo alto.

---

## 28. Registro MAGIA — nada se construye dos veces

Repositorio central (`truckdepot/magia-registry`, D9) con capacidades validadas en producción.

| Tipo | Ejemplos Truck Depot |
|---|---|
| Pipelines | RAG del catálogo de repuestos, clasificador de tickets SAC |
| Conectores MCP | Catálogo, inventario, tickets |
| Prompts y rúbricas | Voz de marca, compatibilidad por modelo/patente |
| Suites de eval | Compatibilidad, cobranza, inyección de prompt |
| Skills locales | Skills de proyectos promovidas a estándar |

- Solo se publica lo que pasó `magia gate` y lleva un periodo estable en producción (propuesta: 30 días).
- Cada capacidad declara owner, versión, evals propios y métricas de producción.
- `magia init` recomienda capacidades según área y scan; `magia-architect` las consulta en cada run.
- `magia learn` propone al Arquitecto de IA promover capacidades nuevas desde un proyecto.

---

## 29. Descubrimiento de valor (`magia scout`)

Analiza código, evals, telemetría, Registro y backlog para proponer dónde la IA puede aportar más. Salida: `docs/magia/opportunities.md`, ordenado por `valor × confianza ÷ esfuerzo`.

Tipos de oportunidad: tareas manuales automatizables; nuevos casos de IA según área; capacidades del Registro aplicables; evals faltantes; deuda técnica que frena entregas; costo o latencia mejorables.

Cada oportunidad incluye: problema, evidencia, propuesta, patrón sugerido (16.3), esfuerzo, riesgo y el comando para ejecutarla: `magia run --from-opportunity <id>`.

---

## 30. Mejora autónoma continua (volante de datos)

```
producción → telemetría → fallas (fallback, baja confianza, reclamos, regresiones)
  → magia improve: convierte fallas reales en casos de eval (anonimizados)
  → reproduce → propone corrección → magia-fixer hasta verde
  → PR con Paquete de Evidencia → mismo gate de siempre
```

- Frecuencia semanal por defecto; inmediata ante incidentes.
- Toda falla real se convierte en caso de eval (Constitución §7): el golden set crece solo y la calidad sube con el uso.
- En riesgo bajo, las mejoras PUEDEN auto-mergearse si pasan gate sin regresión (opt-in, D11).

---

## 31. Optimización y enrutamiento de modelos (`magia optimize`)

- **Enrutamiento por tarea.** Cada paso declara su clase (`razonamiento`, `generación`, `clasificación`, `extracción`). `optimize` prueba los modelos aprobados y asigna el más eficiente que cumple umbrales.
- **Optimización de prompts.** La IA genera variantes y las evalúa contra el golden set (patrón evaluador–optimizador); solo se adopta una variante que iguala o mejora calidad con menor costo o latencia.
- **Contexto y caching.** Recorte de contexto y prompt caching guiados por `magia-perf-optimizer`.
- **Regla dura.** Ninguna optimización se adopta si baja cualquier métrica de la sección 15 bajo su umbral o introduce regresión.

Asignación por defecto para los agentes de desarrollo:

| Agentes | Clase de modelo |
|---|---|
| architect, planner, reviewer, red-teamer | Frontera (máximo razonamiento) |
| builder, worker, fixer | Frontera o equilibrado según complejidad de la tarea |
| documenter, scout (filtrado inicial) | Eficiente |

---

## 32. Métricas de valor

| Métrica | Qué mide |
|---|---|
| Tiempo intención → producción | Velocidad de entrega |
| Intervenciones humanas por entrega | Esfuerzo humano (objetivo: el mínimo de la tabla 3.1) |
| % de PRs que pasan gate al primer intento | Calidad del trabajo autónomo |
| Iteraciones del fixer por run | Eficiencia del bucle autocorrectivo |
| Capacidades del Registro reutilizadas por proyecto | Efecto compuesto |
| Mejoras autónomas en producción por trimestre | Volante de datos |
| Métricas de calidad (sección 15) | Deben mantenerse o mejorar. La velocidad nunca se gana a costa de ellas. |

---

## 33. Perfiles y módulos

MAGIA se adapta al tipo de proyecto con tres perfiles. Las Rules Core (R1–R9) y la Constitución son **idénticas en los tres**; cambian la ceremonia, las herramientas y la profundidad de verificación.

| Perfil | Para | Documento | Énfasis |
|---|---|---|---|
| `diario` | Uso cotidiano de IA por cualquier colaborador, sin producto | `modules/AI-FLUENCY-OPERATIONS.md` | Contexto de área, política de uso, workflows de una página, datos de clientes protegidos |
| `flow` | Áreas administrativas: automatizaciones, documentos, reportes, asistentes internos, sin grandes desarrollos | `modules/FLOW.md` | Recetas, cero código, días en vez de meses, medición de horas ahorradas |
| `estandar` | Productos de software de tamaño medio | Este SPEC | Pipeline autónomo, evals, gates |
| `forge` | Ingeniería de software a gran escala y alta criticidad | `modules/FORGE.md` | Cartografía del código, contratos, flota paralela, verificación diferencial, economía de recursos, Radar de Frontera |

- El scan sugiere el perfil (criterios en FLOW L0 y FORGE F0).
- Graduación: `flow → estandar → forge` cuando el proyecto cruza los umbrales; `magia check` advierte al detectarlo.
- **Forge es la prioridad del programa:** es donde la IA debe ahorrar más recursos, reducir más el tiempo y mantener a Truck Depot en la frontera tecnológica.

---

## 34. Marcos de Anthropic aplicados

Referencia completa: `modules/ANTHROPIC-FRAMEWORKS.md`. Aplicación concreta en este SPEC:

| Sección | Marco | Cambio normativo |
|---|---|---|
| §2, §3 | AF1 4D | El brief declara la Delegación; toda Skill, prompt y tarea de subagente usa la Plantilla de Descripción MAGIA |
| §3 | AF3 Builders | Tests de aceptación antes que código en todos los perfiles; rúbrica de UX en productos con interfaz |
| §8, §11 | AF5 Context Engineering | `MAGIA.md` ≤ 300 líneas; detalle en Skills con divulgación progresiva; presupuesto de contexto por agente |
| §11 | AF7 | Frontmatter de toda Skill incluye `assumption` y `reviewBy` |
| §12 | AF12 | Subagentes reciben instrucciones con la Plantilla de Descripción y devuelven referencia + resumen |
| §14, §16.2 | AF10 | Sandbox declarativo obligatorio desde NM-2; `check` falla sin él |
| §15 | AF9 | Suites de capacidad y regresión; varios intentos; `pass^k` en flujos de cliente y riesgo alto; evaluar resultado, no camino |
| §15, §19, §30 | AF2 | `failureProperty` y `collision` en evals y telemetría; manual de corrección por propiedad; rúbricas contra complacencia, verbosidad, exceso de cautela y confianza mal calibrada |
| §20 | AF8, AF11 | Estándar de herramientas MCP; carga diferida con > 10 herramientas; datos sensibles intermedios fuera del contexto |
| §23 | AF4 | Ruta de formación por rol obligatoria para owners; hitos AFM1–AFM6 |
| §27 | AF6, AF12 | Sesión 0 inicializadora (`features.json`, `init.sh`, `progress.md`); una funcionalidad por sesión; cerebro / manos / sesión con interfaces estables |
| §31 | AF7 | Ablación de andamiaje con cada modelo nuevo |

---

## 35. Claude Code in Action aplicado

Referencia completa: `modules/CLAUDE-CODE-IN-ACTION.md`. Cambios normativos:

| Sección | Cambio |
|---|---|
| §3, §27 | Modo plan obligatorio en tareas no triviales; compactación dirigida con instrucción estándar; rebobinar tras 2 correcciones fallidas sobre el mismo enfoque; modo de trabajo (dirigido, por objetivo, en bucle, en paralelo) elegido por `magia run` |
| §6 | CLAUDE.md ≤ 150 líneas, reglas concretas y verificables; procedimientos de más de 5 pasos van en Skills; reglas innegociables van en hooks |
| §8 | **Distribución por plugin:** `magia init` instala el plugin del perfil (`magia-core`, `magia-forge`, `magia-flow`) desde el marketplace corporativo y genera solo la capa del proyecto |
| §11 | Nueva Skill obligatoria `magia-verify` (siempre): ejecuta tests, lee el diff y reporta evidencia |
| §14 | Hooks con decisión explícita (permitir / negar / pedir confirmación); el hook `Stop` **bloquea el fin de turno** mientras fallen tests, check o evals impactados |
| §16.2 | Modo de permiso de Claude Code asignado por nivel de autonomía y entorno; `check` falla si es más permisivo |
| §18 | Revisión automática de PRs (administrada o GitHub Action) con Constitución, Rules y checklist AF3, complementaria a `magia gate` |
| §29, §30 | `scout`, `improve`, `frontier`, dependencias, `audit` y poda de contexto como **rutinas programadas** en modo headless, siempre vía PR |
| §27.2 | Verificación proporcional: cuanto menos supervisado el trabajo, más verificación exigida |

---

## 36. AI Fluency: Framework & Foundations aplicado

Referencia completa: `modules/AI-FLUENCY.md` (AF14). Cambios normativos:

| Sección | Cambio |
|---|---|
| §3 etapa 1 | Brief con **conciencia del problema** (objetivo, éxito medible, dominio) y **Plan de Delegación** (`docs/magia/delegation.md`) aprobado por el owner |
| §7 | Campo `mode` (`automatizacion`, `aumentacion`, `agencia`) en tareas, pasos y productos; agencia exige NM-2+ con sandbox |
| §11, §12 | Toda Skill y tarea de subagente usa la **Plantilla de Descripción 3P** (Producto, Proceso, Desempeño) |
| §15 | Discernimiento en tres niveles: evals de resultado (producto), revisión de trayectoria (proceso) y rúbrica de comportamiento (desempeño) |
| §20 | **Mapa de Plataformas MAGIA** mantenido con evidencia de MAGIA Bench |
| §21.3 | `magia audit` agrega puntaje 4A (efectiva, eficiente, ética, segura), autoevaluación 4D e indicador de fluidez por área |
| §27.2 | Paquete de Evidencia incluye **Declaración de Diligencia** (creación, transparencia, despliegue) |

---

## 37. Building with the Claude API aplicado (Plano de Ejecución)

Referencia completa: `modules/CLAUDE-API.md` (AF15). Cambios normativos:

| Sección | Cambio |
|---|---|
| §4.2, §11.3 | `magia-runtime` expone `llm.call(plantilla, vars, opts)` con conversación gestionada, streaming, salida estructurada validada, herramientas, citas, caché, Files API y modo batch |
| §6 | Nueva carpeta `prompts/` con plantillas versionadas (`<id>@<version>.md`), XML, prefijo estático primero |
| §10 R1 | El grounding se verifica con **citas nativas** de Claude además de `grounding.require` |
| §10 R2 | Contenido externo y del usuario siempre dentro de etiquetas de datos marcadas como no instrucciones |
| §15 | Todo cambio en `prompts/**` dispara eval de la plantilla (calificadores de código primero, luego por modelo); suite separada de **recuperación** (recall@k) |
| §16.3 | Workflow determinista por defecto; agente con Agent SDK solo cuando los pasos no se conocen |
| §20 | Búsqueda web solo con allowlist de dominios y nunca con datos confidenciales/restringidos; servidores MCP probados con inspector y `tool-eval` |
| §31 | Políticas: razonamiento extendido solo si el eval lo exige; caché en todo prefijo estable; batch para trabajo masivo; `max_tokens` explícito |

---

## 38. AI Fluency for Small Businesses aplicado (MAGIA Diario)

Referencia completa: `modules/AI-FLUENCY-OPERATIONS.md` (AF16). Cambios normativos:

| Sección | Cambio |
|---|---|
| §33 | Nuevo nivel `diario` debajo de `flow`: uso cotidiano de IA por cualquier colaborador, con escalera de graduación diario → workflow → Flow → software |
| §10 R2, R7 | Matriz de datos de clientes y pasos obligatorios (minimizar, anonimizar, delegar, revisar, actuar, transparencia) para todo uso diario |
| §21 | **Política de Uso de IA** de una página, aceptada por cada colaborador antes del acceso; Contexto Corporativo y Contextos de Área versionados |
| §28 | Registro MAGIA incluye la **Biblioteca de Workflows** (fichas de una página); `magia scout` detecta candidatos a receta Flow |
| §23 | Inducción de 30 minutos obligatoria y Campeones de sucursal |

---

## Glosario
- **Alucinación:** afirmación plausible sin respaldo en una fuente real.
- **Grounding / RAG:** anclar la respuesta a fuentes recuperadas y citadas.
- **Skill:** capacidad empaquetada (instrucciones + contratos) que guía al agente o al producto.
- **Rule:** restricción corporativa inmutable con mecanismo de cumplimiento.
- **Gate:** control verificable que bloquea el avance si no se cumple.
- **Golden set:** conjunto curado de casos con respuesta esperada para evals.
- **NM-x:** nivel MAGIA de autonomía.
- **Paquete de Evidencia:** resumen verificable de un cambio que permite aprobar sin revisar línea por línea.
- **Registro MAGIA:** catálogo central de capacidades validadas y reutilizables.
- **Volante de datos:** ciclo en que las fallas de producción se convierten en evals y mejoras automáticas.
