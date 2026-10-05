# MAGIA Forge — Módulo de Ingeniería de Software a Gran Escala

**Perfil `forge`** · Extiende `SPEC.md` (no lo reemplaza) · v1.0 · Confidencial — Truck Depot Corporation

> Forge es donde MAGIA debe brillar. Objetivo: que la IA sea **extremadamente inteligente con los recursos** (tokens, cómputo, tiempo de personas), **reduzca drásticamente el tiempo de entrega** y produzca software que mantenga a Truck Depot **en la frontera tecnológica**, sin ceder un punto de calidad.

---

## F0. Cuándo aplica

`profile: "forge"` se sugiere automáticamente cuando el scan detecta al menos dos de:

| Señal | Umbral |
|---|---|
| Tamaño del código | > 50.000 líneas o > 500 archivos fuente |
| Servicios / paquetes | > 3 servicios desplegables o monorepo con > 5 paquetes |
| Equipos | > 1 equipo con commits en los últimos 90 días |
| Criticidad | Transaccional (pagos, inventario, pedidos) o SLA ≥ 99,5% |
| Integraciones | > 5 integraciones externas o internas |

El perfil se puede subir manualmente; bajarlo requiere excepción (SPEC §21.2).

---

## F1. Principios Forge

| # | Principio | Consecuencia práctica |
|---|---|---|
| FP1 | **El contexto correcto, no todo el contexto** | Los agentes consultan el grafo del código y reciben solo lo relevante. Leer un archivo completo es la excepción. |
| FP2 | **Determinista primero** | Si una herramienta (compilador, linter, codemod, script) puede hacerlo, la IA no lo hace: la IA escribe la herramienta y la herramienta ejecuta. |
| FP3 | **Contrato antes que código** | Toda funcionalidad nace como contrato ejecutable (tipos, esquemas, tests de aceptación). El código se escribe para satisfacerlo. |
| FP4 | **Paralelismo por diseño** | Los planes se dividen en olas de tareas sin conflicto de archivos para correr como flota. |
| FP5 | **Verificar solo lo impactado, pero verificar todo lo impactado** | Análisis de impacto decide qué tests, evals y revisiones correr. Nada impactado queda sin verificar. |
| FP6 | **Cada token tiene presupuesto** | Todo run declara presupuesto; el modelo, el contexto y el modo (interactivo o batch) se eligen para cumplirlo. |
| FP7 | **La arquitectura se prueba, no se recuerda** | Las reglas de arquitectura son tests (fitness functions) que corren en CI. |
| FP8 | **Frontera medida, no anunciada** | Toda nueva capacidad de IA se adopta solo tras ganar en el benchmark interno MAGIA Bench. |

---

## F2. Arquitectura del módulo

```
                    ┌──────────────────────────────────────────────┐
 intención / epic → │  F3 Cartografía del código (índice + grafo)  │ ← siempre actualizado
                    └──────────────┬───────────────────────────────┘
                                   ▼
        F4 Spec y contratos → F5 Modelo de amenazas → F6 Análisis de impacto
                                   ▼
                    F7 Plan jerárquico en olas (DAG)  →  DECISIÓN HUMANA: arquitectura
                                   ▼
                    F8 Flota de ejecución paralela (worktrees / contenedores)
                                   ▼
                    F9 Verificación diferencial multicapa
                                   ▼
                    F10 Cola de merge + revisión multiagente + Paquete de Evidencia
                                   ▼
                    DECISIÓN HUMANA: merge  →  F12 Entrega progresiva + SRE con IA
                                   ▼
                    F13 Aprendizaje → Registro MAGIA · F14 Radar de Frontera
```

---

## F3. Cartografía del código (Codebase Intelligence)

La mayor fuente de desperdicio en IA para código es releer el repositorio. Forge mantiene un modelo navegable del sistema.

### F3.1 `magia index`
Genera y mantiene incrementalmente `.magia/index/`:

| Artefacto | Contenido | Uso |
|---|---|---|
| `symbols.db` | Símbolos (funciones, clases, tipos, endpoints) con firma, ubicación y docstring | Búsqueda precisa sin leer archivos |
| `graph.db` | Grafo de dependencias (import, llamada, herencia, uso de tipos), servicio ↔ servicio | Impacto, partición de tareas |
| `embeddings/` | Embeddings por símbolo y por módulo | Búsqueda semántica |
| `ownership.json` | Dueños por ruta (CODEOWNERS + historial git) | Enrutamiento de revisiones |
| `hotspots.json` | Archivos con alta frecuencia de cambio × complejidad × defectos | Priorizar refactors y revisión humana |
| `ARCHITECTURE.md` | Mapa legible: capas, servicios, flujos críticos, decisiones | Contexto base para agentes y personas |
| `critical-paths.json` | Rutas marcadas como críticas (pagos, auth, inventario, datos restringidos) | Revisión humana obligatoria (F10.3) |

- Actualización incremental en cada commit (hook `post-commit` o job CI); reindexado completo solo bajo `--full`.
- Parsers deterministas (tree-sitter o equivalente por lenguaje); la IA solo resume módulos para `ARCHITECTURE.md`.

### F3.2 Servidor MCP `magia-codegraph`
Expone el índice a todos los agentes como herramientas:

| Herramienta | Devuelve |
|---|---|
| `find_symbol(name)` | Ubicación y firma |
| `search(query, k)` | Símbolos/fragmentos semánticamente relevantes |
| `callers(symbol)` / `callees(symbol)` | Vecindario en el grafo |
| `impact(paths[])` | Símbolos, servicios, tests y contratos afectados |
| `module_summary(path)` | Resumen cacheado del módulo |
| `owners(path)` | Dueños |
| `is_critical(path)` | Bool + motivo |

Regla: los subagentes Forge DEBEN usar `magia-codegraph` antes de `Read` de archivos completos. `magia check` reporta el ratio de lecturas completas vs. consultas al grafo por run.

---

## F4. Desarrollo guiado por contratos

Agente `forge-contract`. Para cada funcionalidad:

1. Deriva contratos de la spec: OpenAPI/AsyncAPI para interfaces, JSON Schema/tipos para datos, firmas de módulos.
2. Genera **tests de aceptación ejecutables** desde los criterios de la spec (fallan al inicio: rojo).
3. Genera tests de contrato entre servicios (consumidor ↔ proveedor).
4. Solo entonces el plan asigna tareas de implementación.

Resultado: la definición de "terminado" es objetiva desde el minuto uno y la flota puede trabajar en paralelo contra contratos estables.

---

## F5. Modelo de amenazas por funcionalidad

Agente `forge-threat-modeler`. Para cada epic o cambio en ruta crítica:
- STRIDE sobre el diagrama de flujo de datos derivado del grafo.
- Específico de IA: inyección de prompt, exfiltración vía herramientas, abuso de agentes, envenenamiento de RAG.
- Salida: `docs/magia/threats/<id>.md` + casos en la suite `redteam` + controles como tareas del plan.

---

## F6. Análisis de impacto

`magia impact <diff|plan>` usa `graph.db` para calcular el **radio de impacto**:

| Salida | Uso |
|---|---|
| Símbolos y servicios afectados | Alcance del plan y de la revisión |
| Tests impactados | Verificación diferencial (F9) |
| Contratos impactados | Tests de contrato obligatorios |
| Rutas críticas tocadas | Revisión humana obligatoria |
| Dueños afectados | Revisores sugeridos |
| Riesgo del cambio (bajo/medio/alto) | Profundidad de verificación y de gate |

---

## F7. Planificación jerárquica en olas

Agente `forge-planner` (extiende `magia-planner`).

- Jerarquía: **Epic → Feature → Tarea**. Cada tarea: id, objetivo, archivos que posee, dependencias, contrato que satisface, criterio de terminado, clase de modelo, presupuesto.
- **Partición sin conflicto:** dos tareas de la misma ola NO PUEDEN poseer el mismo archivo. El planner usa el grafo para partir por fronteras de módulo.
- **Olas:** conjuntos de tareas paralelizables; la ola N+1 empieza cuando la N integra en verde.
- **Estimación de costo:** el plan declara tokens y tiempo estimados por ola; `magia budget` los valida contra el presupuesto del run.
- **Decisión humana:** revisión de arquitectura del plan (una pantalla: diagrama, olas, riesgos, costo). Es el punto de mayor apalancamiento del humano en Forge.

---

## F8. Flota de ejecución paralela

`magia fleet run <plan-id> [--max-parallel N]`

| Aspecto | Requisito |
|---|---|
| Aislamiento | Cada `forge-worker` corre en su git worktree; en CI, en contenedor efímero con egreso de red en allowlist |
| Contexto mínimo | El worker recibe: su tarea, contratos, resumen del módulo y vecindario del grafo. No el repo completo. |
| TDD | Rojo → verde → refactor; el worker no termina sin tests de su tarea en verde |
| Autocorrección | `magia-fixer` local por worker (máx. N iteraciones) |
| Reporte | Cada worker devuelve resumen condensado (≤ 300 palabras) + diff; el orquestador nunca recibe trazas completas |
| Fallos | Tarea que no converge se marca `blocked` con diagnóstico; la ola continúa con el resto |
| Ejecución | Interactiva (Claude Code) o headless (Agent SDK / `claude -p`) en CI para flotas grandes |

---

## F9. Verificación diferencial multicapa

Pirámide aplicada solo a lo impactado (F6), y completa en ramas de release.

| Capa | Herramienta / agente | Siempre | Si impacto ≥ medio | Si ruta crítica |
|---|---|---|---|---|
| Tipos, lint, formato | Deterministas | Sí | Sí | Sí |
| Fitness functions de arquitectura | `magia arch-test` | Sí | Sí | Sí |
| Unit tests impactados | Test impact analysis | Sí | Sí | Sí |
| Tests de contrato | `forge-contract` | Si cambia contrato | Sí | Sí |
| Property-based tests | `forge-test-architect` | — | Sí | Sí |
| Mutation testing (sobre lo cambiado) | `forge-test-architect` | — | — | Sí |
| Integración / e2e impactados | Suite del repo | — | Sí | Sí |
| Presupuestos de performance | `forge-perf` | — | Si toca rutas calientes | Sí |
| SAST, dependencias, secretos, SBOM | Deterministas | Sí | Sí | Sí |
| Evals de IA (si hay IA en el producto) | `magia eval` | Si cambia lógica IA | Sí | Sí |
| Red-team | `magia-red-teamer` | — | Riesgo alto | Sí |

- **Cache de verificación:** resultados indexados por hash de (código impactado + tests + config). Un resultado verde no se recalcula si nada cambió.
- **Calidad de tests:** la puntuación de mutación sobre código cambiado DEBE superar el umbral del proyecto en rutas críticas; tests que no detectan mutantes no cuentan como cobertura.

### F9.1 Fitness functions (`.magia/local/architecture.json`)
Reglas declarativas evaluadas en CI. Ejemplos: capas permitidas (`ui → app → domain`, nunca `domain → infra`); sin ciclos entre paquetes; tamaño máximo de módulo; servicios sin acceso directo a la base de datos de otro; latencia p95 de endpoints críticos; tamaño de bundle.

---

## F10. Integración, revisión y merge a escala

### F10.1 Cola de merge
Agente `forge-merge-steward`: ordena PRs de la flota por dependencias, rebasa, re-ejecuta verificación diferencial y resuelve conflictos triviales; conflictos semánticos vuelven al worker dueño.

### F10.2 Revisión multiagente
En paralelo: `magia-reviewer` (Rules), `magia-security`, `forge-perf`, `forge-arch-reviewer` (coherencia con `ARCHITECTURE.md` y ADRs). Hallazgos deduplicados en un solo informe.

### F10.3 Revisión humana focalizada
El humano revisa:
- El Paquete de Evidencia (siempre).
- Línea por línea **solo** los cambios en `critical-paths.json` y en `hotspots.json` con riesgo alto.
- Todo lo demás se aprueba por evidencia.

---

## F11. Modernización y migraciones a escala

`magia migrate <receta>` — Agente `forge-migrator`.

1. La IA analiza patrones a migrar con el grafo (p. ej. framework antiguo, API deprecada, lenguaje legado).
2. La IA **escribe un codemod** determinista (AST) y sus tests.
3. El codemod se aplica en olas por módulo; la IA solo atiende los casos que el codemod no cubre.
4. Backfill de tests de caracterización antes de migrar código sin tests.
5. Verificación diferencial por ola; rollback por ola.

Recetas iniciales sugeridas: actualización mayor de framework, migración de API interna, tipado progresivo, extracción de servicio desde monolito, backfill de tests.

---

## F12. Entrega progresiva y SRE con IA

| Capacidad | Agente | Comportamiento |
|---|---|---|
| Feature flags por defecto | `forge-planner` | Todo cambio de comportamiento sale detrás de flag |
| Canary + rollback automático | Pipeline | Regresión en SLO o evals de producción → rollback sin intervención |
| Triaje de incidentes | `forge-sre` | Correlaciona alertas, logs, despliegues y grafo; propone causa probable y mitigación |
| Runbooks vivos | `forge-sre` | Genera/actualiza runbooks desde incidentes reales |
| Post-mortems | `forge-sre` | Borrador sin culpables + tareas + casos de test/eval que previenen recurrencia |

Acciones de mitigación en producción: NM-3 (checkpoint humano) salvo rollback automático predefinido.

---

## F13. Economía de recursos — cómo Forge ahorra

| Palanca | Mecanismo | Efecto esperado |
|---|---|---|
| Contexto por grafo | `magia-codegraph` en lugar de leer archivos | Menos tokens de entrada por tarea |
| Subagentes con contexto aislado | Workers devuelven resúmenes condensados | El orquestador no se satura; menos compactaciones |
| Enrutamiento de modelos | Frontera para planificar/revisar; eficiente para tareas mecánicas | Menor costo por tarea sin perder calidad |
| Prompt caching | Prefijos estables (Constitución, MAGIA.md, contratos) primero | Menor costo y latencia en llamadas repetidas |
| Modo batch | Evals, documentación, backfills y migraciones no urgentes vía API de batches | Menor costo en trabajo no interactivo |
| Determinista primero | Codemods, generadores, linters en vez de LLM | Costo marginal casi cero y resultado reproducible |
| Verificación diferencial + cache | Solo lo impactado; resultados por hash | Menos minutos de CI |
| Paralelismo en olas | Flota sin conflictos | Menor tiempo calendario |
| Registro MAGIA | Reutilizar capacidades validadas | Menos trabajo nuevo |
| Presupuesto por run | `magia budget` corta o degrada de forma controlada | Sin gastos descontrolados |

> Los efectos se cuantifican en el piloto (F17) con las métricas de F16; no se publican cifras antes de medirlas.

### F13.1 `magia budget`
Cada run declara `{ tokens, costoUsd, minutosCI, tiempoMax }`. Al 80% el orquestador reduce paralelismo y cambia tareas mecánicas a modelo eficiente; al 100% detiene, integra lo que está en verde y reporta.

---

## F14. Radar de Frontera y MAGIA Bench

Mantener a Truck Depot al frente **con evidencia**.

### F14.1 MAGIA Bench
Suite interna de benchmarks construida con tareas reales de la corporación:

| Suite | Contenido |
|---|---|
| `bench-code` | Issues reales resueltos (con tests ocultos) de repos Truck Depot |
| `bench-review` | PRs con defectos conocidos sembrados |
| `bench-arch` | Planes de epics evaluados contra rúbrica de arquitectura |
| `bench-product` | Golden sets de productos IA en producción (SAC, Tienda…) |
| `bench-cost` | Costo y latencia por tarea |

### F14.2 `magia frontier`
- Al aparecer un modelo, versión o herramienta nueva: ejecuta MAGIA Bench, compara contra la configuración vigente en calidad, costo y latencia.
- Si gana sin perder en ninguna métrica de calidad: abre PR al Registro actualizando el enrutamiento de modelos y notifica al Comité (R3).
- Mantiene `docs/magia/tech-radar.md`: **Adoptar / Probar / Evaluar / Retener** para modelos, frameworks de agentes, herramientas y patrones.

### F14.3 Carril de exploración
Repositorios con `lane: "exploracion"`: prototipos con capacidades de frontera (nuevos modelos, modalidades, agentes de larga duración, uso de computador) en sandbox, sin datos `confidencial`/`restringido`. Gate reducido para explorar rápido; para pasar a producción DEBEN graduarse con el gate completo del perfil.

---

## F15. Agentes y comandos Forge

### Subagentes (`.claude/agents/forge-*.md`)
| Agente | Rol |
|---|---|
| `forge-cartographer` | Mantiene índice, `ARCHITECTURE.md`, hotspots y rutas críticas |
| `forge-contract` | Spec → contratos y tests de aceptación |
| `forge-threat-modeler` | Modelo de amenazas por epic |
| `forge-planner` | Plan jerárquico en olas sin conflictos, con costo |
| `forge-worker` | Implementación TDD de una tarea con contexto mínimo |
| `forge-test-architect` | Property-based, mutation, tests de caracterización |
| `forge-perf` | Presupuestos de performance, profiling, regresiones |
| `forge-arch-reviewer` | Coherencia con arquitectura, ADRs y fitness functions |
| `forge-merge-steward` | Cola de merge y conflictos |
| `forge-migrator` | Codemods y migraciones en olas |
| `forge-sre` | Incidentes, runbooks, post-mortems |
| `forge-frontier` | MAGIA Bench y radar tecnológico |

### Slash commands
| Comando | Acción |
|---|---|
| `/forge-epic <intención>` | Pipeline Forge completo (F2) hasta PRs con evidencia |
| `/forge-impact` | Radio de impacto del diff actual |
| `/forge-migrate <receta>` | Migración en olas |
| `/forge-perf <ruta\|endpoint>` | Diagnóstico y mejora de performance con presupuesto |
| `/forge-incident <alerta\|id>` | Triaje y propuesta de mitigación |
| `/forge-frontier` | Ejecuta MAGIA Bench y propone actualizaciones del radar |
| `/forge-explain <ruta>` | Explica un módulo a una persona nueva usando el índice |

### CLI adicional
`magia index` · `magia impact` · `magia fleet run|status` · `magia arch-test` · `magia budget` · `magia migrate` · `magia bench` · `magia frontier`

---

## F16. Métricas Forge

| Métrica | Qué mide |
|---|---|
| Lead time epic → producción | Velocidad |
| Horas humanas por epic (decisión + revisión) | Esfuerzo humano |
| Tokens y costo por tarea / por epic | Eficiencia de recursos |
| Ratio consultas al grafo / lecturas completas | Inteligencia de contexto |
| % tareas de flota en verde sin escalar | Autonomía efectiva |
| Minutos de CI por PR | Eficiencia de verificación |
| Tasa de defectos escapados a producción | Calidad (no debe subir) |
| Puntuación de mutación en rutas críticas | Calidad real de los tests |
| Cambio en fallas / MTTR | Confiabilidad |
| Posición en MAGIA Bench vs. configuración anterior | Frontera tecnológica |

---

## F17. Piloto e hitos Forge

| Hito | Entregable | Criterios de aceptación |
|---|---|---|
| **FG1 Cartografía** | `magia index`, `magia-codegraph` MCP, `ARCHITECTURE.md`, rutas críticas | En un repo real > 50k líneas: índice incremental < 1 min por commit típico; `impact` coincide con revisión manual en ≥ 9/10 casos de muestra |
| **FG2 Contratos y plan en olas** | `forge-contract`, `forge-threat-modeler`, `forge-planner`, `magia budget` | Plan de epic real con olas sin conflictos de archivos; tests de aceptación generados y en rojo antes de implementar |
| **FG3 Flota y verificación diferencial** | `magia fleet`, workers aislados, test impact analysis, cache, mutation en críticos | Epic real ejecutada por flota; verificación corre solo lo impactado sin escapar defectos sembrados |
| **FG4 Merge y revisión a escala** | `forge-merge-steward`, revisión multiagente, revisión humana focalizada | PRs de flota integrados vía cola; humano revisa solo rutas críticas + evidencia |
| **FG5 Frontera** | MAGIA Bench, `magia frontier`, tech radar, carril de exploración | Bench reproducible; cambio de enrutamiento propuesto por evidencia |
| **FG6 Migraciones y SRE** | `forge-migrator`, `forge-sre` | Migración en olas con codemod en repo piloto; post-mortem generado desde incidente simulado |

Piloto recomendado: el repositorio de mayor tamaño y criticidad de Tienda/ecommerce, con línea base de F16 medida **antes** de activar Forge.

---

## F18. Marcos de Anthropic en Forge

Detalle en `modules/ANTHROPIC-FRAMEWORKS.md`.

| Sección Forge | Marco | Aplicación |
|---|---|---|
| F2, F8 | AF12 Cerebro / manos / sesión | Orquestador = cerebro; flota en sandbox = manos; `runs/<id>/` = sesión. Se cambia de modelo sin tocar manos ni sesión |
| F3 | AF5 Context Engineering | El grafo es la recuperación justo a tiempo; subagentes con contexto limpio y resúmenes ≤ 300 palabras |
| F3.2 | AF8, AF11 | `magia-codegraph` cumple el Estándar de herramientas y se expone también como API de código; carga diferida |
| F4, F10 | AF3 Builders | Tests de aceptación primero; checklist de evaluación de código IA en revisión humana focalizada |
| F7, F8 | AF6 Harness de larga duración | Cada epic tiene `features.json`; cada worker trabaja una funcionalidad y la marca como lista solo con evidencia de punta a punta |
| F7 | AF12 Escalar esfuerzo | El planner fija el número de subagentes según la complejidad y justifica el multiagente por costo y beneficio |
| F8 | AF10 Sandbox | Workers en contenedor con egreso en allowlist: autonomía sin confirmaciones de rutina |
| F9 | AF2, AF9 | Fallas etiquetadas por propiedad; tareas de agente con varios intentos; `pass^k` en rutas críticas |
| F13 | AF11 | Filtrado de datos en ejecución de código: menos tokens de resultados intermedios |
| F14 | AF7 | MAGIA Bench con ablación: se retira el andamiaje que el nuevo modelo ya no necesita |
| F8, F10 | AF13 Claude Code in Action | Flota en headless con modo de permiso sin confirmaciones solo en contenedor aislado; `magia-verify` y gate de fin de turno por worker; verificación proporcional máxima por ser trabajo no supervisado; revisión automática de PRs de la flota |
| F14 | AF13 | `magia frontier` corre como rutina programada al publicarse cada modelo |
| F15 | AF13 | Agentes y comandos Forge se distribuyen en el plugin `magia-forge` |
| F7, F10 | AF14 AI Fluency | Cada tarea del plan declara `mode`; la revisión de arquitectura es aumentación (decide la persona); la flota es agencia con verificación obligatoria; cada PR lleva Declaración de Diligencia |
| F12, F13, F14 | AF15 Claude API | Productos Forge siguen la arquitectura de referencia API9; contextualización de chunks, migraciones masivas y MAGIA Bench en batch; caché de prefijos estables obligatoria; razonamiento extendido solo con evidencia de eval |
