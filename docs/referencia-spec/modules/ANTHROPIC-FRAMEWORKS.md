# MAGIA — Marcos de Anthropic integrados

**Módulo de referencia** · Extiende `SPEC.md`, `modules/FORGE.md` y `modules/FLOW.md` · v1.0 · Confidencial — Truck Depot Corporation

> MAGIA adopta los marcos que Anthropic publica en su Academia y en su blog de ingeniería, y los convierte en **requisitos verificables**. Este documento dice, para cada marco: qué es (en nuestras palabras), qué exige MAGIA y dónde se aplica. MAGIA no está afiliado a Anthropic; los marcos se usan como referencia pública.

## Índice

| # | Marco | Familia | Se aplica en |
|---|---|---|---|
| AF1 | 4D AI Fluency + ciclo Descripción–Discernimiento | Fluidez humana | SPEC §2, §3, §27 · FLOW L2, L4 |
| AF2 | Capacidades y Limitaciones (4 propiedades) | Fluidez humana | SPEC §15, §19, §30 · FORGE F9 |
| AF3 | AI Fluency for Builders | Fluidez humana | SPEC §3 · FORGE F4, F10 |
| AF4 | Hoja de ruta Individuo → Equipo → Organización | Adopción | SPEC §23 · FLOW L8 |
| AF5 | Context Engineering | Arquitectura | SPEC §8, §11 · FORGE F3, F8 |
| AF6 | Harness para agentes de larga duración | Arquitectura | SPEC §27 · FORGE F7, F8 |
| AF7 | Harness design: las suposiciones caducan | Arquitectura | SPEC §22, §31 · FORGE F14 |
| AF8 | Diseño de herramientas para agentes | Arquitectura | SPEC §20 · FORGE F3.2 |
| AF9 | Evals para agentes | Calidad | SPEC §15 · FORGE F9, F14 |
| AF10 | Permisos estructurados y sandboxing | Seguridad | SPEC §14, §16.2 · FORGE F8 |
| AF11 | Code execution con MCP + Advanced tool use | Eficiencia | SPEC §20 · FORGE F3.2, F13 |
| AF12 | Multiagente + Managed Agents (cerebro, manos, sesión) | Arquitectura | SPEC §12, §27 · FORGE F2, F8 |
| AF14 | AI Fluency: Framework & Foundations (curso, profundiza AF1) | Fluidez humana | `modules/AI-FLUENCY.md` · SPEC §36 |
| AF15 | Building with the Claude API (curso) | Plano de Ejecución | `modules/CLAUDE-API.md` · SPEC §37 |
| AF16 | AI Fluency for Small Businesses (curso) | Fluidez operativa | `modules/AI-FLUENCY-OPERATIONS.md` · SPEC §38 |
| AF13 | Claude Code in Action (curso) | Práctica de ingeniería | `modules/CLAUDE-CODE-IN-ACTION.md` · SPEC §35 |

---

## AF1. 4D AI Fluency y ciclo Descripción–Discernimiento

**Qué es.** Cuatro competencias humanas para colaborar con IA: **Delegación** (qué trabajo hace la IA), **Descripción** (contexto e instrucciones), **Discernimiento** (evaluar exactitud y utilidad) y **Diligencia** (uso responsable y hacerse cargo del resultado). Descripción y Discernimiento forman un ciclo: se instruye, se examina el resultado, se ajusta la instrucción.

**Qué exige MAGIA.**
| D | Requisito | Artefacto |
|---|---|---|
| Delegación | Toda intención declara qué se delega a la IA y qué queda en manos humanas, usando la tabla SPEC §3.1 | Sección "Delegación" en `brief.md` y en la Ficha de Proceso (Flow) |
| Descripción | Todo prompt de sistema, Skill y tarea de subagente usa la **Plantilla de Descripción MAGIA**: objetivo · contexto · restricciones · formato de salida · ejemplos · criterio de terminado | `templates/descripcion-magia.md` (formato en AF1.1) |
| Discernimiento | Ningún output se acepta sin evaluación: evals automáticos (AF9) y, en los gates humanos, el Paquete de Evidencia | `magia eval`, Paquete de Evidencia |
| Diligencia | Cada entrega tiene un responsable humano nombrado; la divulgación de IA (R7) y la trazabilidad son obligatorias | `owner` en config; firma en el gate |

**El ciclo como mecanismo.** El patrón evaluador–optimizador (SPEC §16.3), `magia-fixer` y `magia optimize` son el ciclo Descripción–Discernimiento automatizado: el agente ajusta su instrucción o su código, el evaluador examina, y se repite hasta pasar el umbral o escalar.

> Profundizado en `modules/AI-FLUENCY.md` (AF14): 3 modos de interacción, Delegación en 3 partes, Descripción y Discernimiento en 3 niveles (producto, proceso, desempeño), Diligencia de creación, transparencia y despliegue. La plantilla vigente es la versión 3P de `templates/descripcion-magia.md`.

### AF1.1 Plantilla de Descripción MAGIA (versión resumida; ver 3P)
```markdown
## Objetivo        — qué resultado y para quién
## Contexto        — lo mínimo necesario (enlaces a MAGIA.md, contratos, fuentes)
## Restricciones   — Rules aplicables, qué NO hacer, presupuesto
## Formato         — estructura exacta de la salida
## Ejemplos        — 1–3 ejemplos canónicos (no listas exhaustivas de casos borde)
## Terminado si    — criterio verificable (tests, evals, checklist)
```

---

## AF2. Capacidades y Limitaciones — las 4 propiedades

**Qué es.** El complemento del 4D: describe las propiedades de la máquina a las que responden las competencias humanas. Son cuatro, cada una en un continuo de capacidad a limitación:
- **Predicción del siguiente token:** de dónde salen las respuestas. La fluidez no garantiza exactitud.
- **Conocimiento:** lo que el modelo sabe, congelado en su fecha de corte. Pierde en lo raro, lo reciente o lo de nicho.
- **Memoria de trabajo:** lo que está atendiendo ahora, con un límite y degradación cuando se excede.
- **Direccionabilidad (steerability):** cuánto control dan realmente las instrucciones.

La mayoría de las fallas reales son **dos propiedades que chocan**. Además, el ajuste fino deja huellas de comportamiento: complacencia, verbosidad, exceso de cautela y confianza mal calibrada.

**Qué exige MAGIA.**
1. **Taxonomía de fallas.** Todo caso de eval que falla y todo evento `guard.fallback`/`guard.escalate` DEBE etiquetarse con `failureProperty` ∈ {`prediccion`, `conocimiento`, `memoria`, `direccionabilidad`} y, si aplica, `collision: [a, b]`.
2. **Manual de corrección por propiedad** (lo usan `magia-fixer` y `magia improve`):

| Propiedad | Señal típica | Corrección MAGIA |
|---|---|---|
| Conocimiento | Datos de partes, precios o políticas inventados u obsoletos | `magia-grounding` (RAG + citas); nunca conocimiento libre del modelo |
| Memoria de trabajo | Olvida instrucciones o datos en tareas largas | Context engineering (AF5): compactación, notas, subagentes |
| Direccionabilidad | Ignora el formato o las restricciones | Plantilla de Descripción (AF1.1), ejemplos canónicos, salidas estructuradas, herramientas en vez de instrucciones |
| Predicción | Respuestas plausibles pero inexactas bajo presión de especificidad | Verificación determinista, citas obligatorias, permitir "no sé" (R4) |

3. **Huellas del ajuste fino en las rúbricas.** Las rúbricas de `magia-evals` DEBEN incluir criterios contra la **complacencia** (no ceder ante una corrección incorrecta del usuario), la **verbosidad**, el **exceso de cautela** (negarse a algo válido) y la **confianza mal calibrada**.
4. **Reporte.** `magia audit` muestra la distribución de fallas por propiedad y la colisión más frecuente por proyecto.

---

## AF3. AI Fluency for Builders

**Qué es.** El 4D aplicado a construir productos con IA: escribir tests de aceptación, evaluar código generado por IA y criticar experiencias de usuario construidas con IA.

**Qué exige MAGIA.**
- **Tests de aceptación antes que código** (ya está en FORGE F4; se extiende a todos los perfiles en la etapa 2 del SPEC §3).
- **Checklist de evaluación de código IA** para `magia-reviewer` y para la revisión humana focalizada: corrección frente al contrato, casos borde, manejo de errores, seguridad, dependencias nuevas, complejidad innecesaria, tests que realmente prueban algo (mutación en rutas críticas).
- **Crítica de UX construida con IA:** rúbrica `evals/rubrics/ux.md` (claridad, consistencia con la marca, estados de error y vacío, accesibilidad, divulgación de IA). Obligatoria en productos con interfaz.

---

## AF4. Hoja de ruta Individuo → Equipo → Organización

**Qué es.** Empezar en pequeño y crecer: primeros pasos, un plan de 30 días y una ruta de adopción de la persona al equipo y del equipo a la organización.

**Qué exige MAGIA.**

| Fase | Alcance | Criterio para avanzar |
|---|---|---|
| Individuo | AI Champion y primeros usuarios por área | Formación por rol completada; primer producto Flow o PR con `/magia-ship` |
| Equipo | El área completa usa MAGIA en sus proyectos | ≥ 1 producto en producción con gate aprobado y métricas de valor medidas |
| Organización | Todas las áreas; Registro con capacidades compartidas | Auditoría trimestral del Comité sin violaciones críticas |

**Ruta de formación por rol (cursos de Anthropic Academy):**
| Rol | Ruta |
|---|---|
| Directorio y gerencias | AI Fluency: Framework & Foundations → AI Capabilities and Limitations |
| Todo colaborador (MAGIA Diario) | AI Fluency for Small Businesses + inducción MAGIA de 30 minutos (ver AF16 SB8 por rol) |
| Usuarios Flow | Claude 101 → AI Fluency: Framework & Foundations → Introducción a Claude Cowork |
| AI Champions | Lo anterior + AI Fluency for Builders + Introducción a Agent Skills |
| Ingeniería (estándar/Forge) | AI Capabilities and Limitations → Claude Code in Action → Agent Skills → Subagents → MCP (intro y avanzado) → Building with the Claude API → AI Fluency for Builders |

Requisito: el owner de un proyecto (`project.owner`) DEBE haber completado la ruta de su rol antes de aprobar gates.

**Plan de 30 días por área** (plantilla en `templates/adopcion-30-dias.md`): semana 1 formación y Ficha de Proceso; semana 2 primer producto en piloto; semana 3 prueba guiada y gate; semana 4 publicación y medición.

---

## AF5. Context Engineering

**Qué es.** Tratar el contexto como un **presupuesto de memoria de trabajo** finito, no como un depósito: el objetivo es el conjunto más pequeño de información de alta señal que maximiza el resultado. Técnicas para tareas largas: **compactación**, **notas estructuradas** fuera del contexto y **arquitecturas multiagente** con contextos aislados. Se prefiere la recuperación justo a tiempo (búsqueda agéntica) frente a precargar todo.

**Qué exige MAGIA.**
| Requisito | Detalle |
|---|---|
| Presupuesto de contexto | Cada agente declara un presupuesto; `magia-perf-optimizer` lo mide por run |
| `MAGIA.md` conciso | Tamaño máximo propuesto: 300 líneas; el detalle vive en Skills y se carga por **divulgación progresiva** |
| Prompts de sistema "a la altura correcta" | Ni reglas frágiles tipo if-else ni vaguedades; la Plantilla de Descripción (AF1.1) |
| Recuperación justo a tiempo | Los agentes buscan (grafo, búsqueda) en lugar de precargar archivos (FORGE FP1) |
| Notas estructuradas | `docs/magia/runs/<id>/progress.md` y `NOTES.md` por run |
| Compactación | Antes del límite, el agente compacta conservando decisiones, pendientes y errores abiertos |
| Subagentes con contexto limpio | Devuelven resúmenes condensados, nunca trazas completas |
| Ejemplos canónicos | 1–3 ejemplos diversos en vez de listas exhaustivas de casos borde |

---

## AF6. Harness para agentes de larga duración

**Qué es.** Para trabajo que excede una ventana de contexto: un **agente inicializador** prepara el entorno en la primera sesión y un **agente de código** avanza de forma incremental en cada sesión, dejando artefactos claros para la siguiente: lista de funcionalidades con estado, script de arranque, archivo de progreso e historial de git.

**Qué exige MAGIA (aplicado a `magia run` y a FORGE).**
1. **Sesión 0 (inicializador):** crea en `docs/magia/runs/<id>/`:
   - `features.json`: lista completa de funcionalidades con `passes: false`, derivada de la spec.
   - `init.sh`: arranca el entorno y corre una prueba básica de humo.
   - `progress.md`: bitácora.
   - Commit inicial.
2. **Sesiones siguientes (agente de código):**
   - Al empezar: leer `progress.md`, el `git log` y `features.json`; ejecutar `init.sh`; verificar que lo existente funciona antes de tocar nada.
   - Trabajar **una funcionalidad por sesión**.
   - Marcar `passes: true` **solo con evidencia de prueba de punta a punta** (tests, evals; navegador automatizado si hay UI).
   - Al terminar: commit descriptivo y actualización de `progress.md`.
3. **Prohibido** eliminar o reescribir entradas de `features.json` para "terminar" antes (lo valida `magia check`).
4. Agentes especializados opcionales por rol (pruebas, QA, limpieza) con el mismo harness y distinto prompt inicial.

---

## AF7. Harness design: las suposiciones caducan

**Qué es.** Cada componente de un harness existe porque se asume que el modelo no puede hacer algo por sí solo. Esas suposiciones vencen a medida que los modelos mejoran. Además, el modelo que genera tiende a evaluar su propio trabajo con indulgencia, así que conviene separar generador y evaluador.

**Qué exige MAGIA.**
- Toda Skill, hook, guarda, subagente y paso de pipeline DEBE declarar en su frontmatter:
  ```yaml
  magia:
    assumption: "<qué limitación del modelo compensa>"
    reviewBy: "<fecha o versión de modelo>"
  ```
- **Ablación en `magia frontier`** (FORGE F14): con cada modelo nuevo se ejecuta MAGIA Bench con y sin cada componente de andamiaje. Si quitarlo no baja la calidad, se propone retirarlo (menos costo y latencia).
- **Generador ≠ evaluador:** el juez de evals y `magia-reviewer` usan un prompt aislado, sin acceso al razonamiento del generador, y criterios explícitos. Excepción: las Rules Core **nunca** se retiran por ablación; solo las salvaguardas de capacidad.

---

## AF8. Diseño de herramientas para agentes

**Qué es.** Las herramientas son la interfaz de usuario del agente: nombres, esquemas, respuestas y mensajes de error determinan su desempeño. Pocas herramientas de alto impacto rinden más que envolver cada endpoint. Se evalúan con agentes y se mejoran con agentes.

**Estándar MAGIA de herramientas** (obligatorio para todo servidor MCP interno y de la allowlist):
| Requisito | Detalle |
|---|---|
| Pocas y de alto impacto | Consolidar flujos (p. ej. `buscar_repuesto_compatible` en vez de 4 llamadas encadenadas) |
| Espacios de nombres claros | `catalogo_*`, `inventario_*`, `sac_*` |
| Respuestas con significado | Nombres e identificadores legibles; no UUIDs crudos sin contexto |
| Eficiencia de tokens | Paginación, filtros, truncado con aviso; `formato: "conciso" \| "detallado"` |
| Errores accionables | El mensaje dice qué corregir, no un código opaco |
| Descripciones como para alguien nuevo | Qué hace, cuándo usarla, parámetros con ejemplos |
| Evaluación | `magia tool-eval <servidor>`: tareas realistas, métricas de éxito, llamadas, tokens y errores; el agente propone mejoras a descripciones y esquemas |

---

## AF9. Evals para agentes

**Qué es.** Evaluar agentes es distinto de evaluar una llamada: hay **tareas**, varios **intentos** por tarea, **evaluadores** (código, modelo, humano), **transcripciones** completas y el **resultado** final. Como un agente puede llegar bien por caminos distintos, se evalúa el resultado y no un camino exacto.

**Qué exige MAGIA (extiende SPEC §15).**
| Requisito | Detalle |
|---|---|
| Dos tipos de suite | **Capacidad** (¿qué tan bien hace algo nuevo?, se espera que mejore) y **regresión** (no debe empeorar; casi 100%) |
| Varios intentos | Tareas de agente se corren k veces |
| Métrica según uso | `pass@k` para tareas donde basta un éxito (exploración); `pass^k` (éxito en todos los intentos) para flujos de cliente y riesgo alto |
| Jerarquía de evaluadores | Código determinista primero; modelo-juez con rúbrica cuando no alcanza; humano para calibrar al juez periódicamente |
| Evaluar resultado, no camino | Verificar el estado final (archivos, base de datos, respuesta), no la secuencia exacta de pasos |
| Leer transcripciones | Revisión periódica de transcripciones de casos fallidos y de una muestra de exitosos |
| Origen de las tareas | Empezar con 20–50 tareas tomadas de fallas reales y de trabajo real del área |
| Tareas sin ambigüedad | Cada tarea tiene solución de referencia verificable |

Campos nuevos en `eval-case`: `kind: "capacidad" | "regresion"`, `trials`, `metric: "pass@k" | "pass^k"`, `grader: "codigo" | "modelo" | "humano"`.

---

## AF10. Permisos estructurados y sandboxing

**Qué es.** En vez de depender de pedir permiso a cada paso, se define un **sandbox** con límites de sistema de archivos y de red. Dentro de esos límites el agente opera con autonomía; fuera, no puede. Menos interrupciones y más seguridad a la vez.

**Qué exige MAGIA.**
- **Política declarativa** en `.magia/local/permissions.json`, compilada a `.claude/settings.json`: rutas de lectura y escritura, comandos permitidos y dominios de red permitidos.
- **Sistema de archivos:** escritura solo dentro del repo (o del worktree en Forge); lectura denegada en rutas `restringido` y secretos.
- **Red:** egreso solo a la allowlist (registry de paquetes, API de modelos aprobada, servidores MCP aprobados).
- **Autonomía según sandbox:** NM-2+ requiere el sandbox activo; dentro de él, se eliminan las confirmaciones de rutina y se mantienen solo los `human-checkpoint` de acciones irreversibles.
- `magia check` falla si NM ≥ 2 y no hay sandbox configurado.

---

## AF11. Code execution con MCP y Advanced tool use

**Qué es.** Cargar todas las definiciones de herramientas y pasar cada resultado intermedio por el contexto del modelo es caro. En su lugar, el agente **escribe código** que llama a las herramientas como una API, descubre herramientas bajo demanda y filtra los datos en el entorno de ejecución, de modo que solo el resultado relevante vuelve al modelo. Como complemento: búsqueda de herramientas con carga diferida, llamadas programáticas a herramientas y ejemplos de uso en las definiciones.

**Qué exige MAGIA.**
| Requisito | Detalle |
|---|---|
| Carga diferida | Servidores con > 10 herramientas DEBEN usar búsqueda de herramientas y carga bajo demanda |
| Ejecución de código para flujos con datos voluminosos | Filtrado, agregación y joins en el entorno de ejecución (sandbox AF10); solo el resumen entra al contexto |
| Privacidad | Los datos intermedios `confidencial`/`restringido` no pasan por el contexto del modelo; `data-shield` tokeniza PII en el entorno |
| Ejemplos en herramientas | Herramientas complejas incluyen ejemplos de uso en su definición |
| `magia-codegraph` | Disponible también como API de código, además de herramientas MCP (FORGE F3.2) |
| Medición | `magia-perf-optimizer` reporta tokens de definiciones de herramientas y de resultados intermedios por run |

---

## AF12. Multiagente y Managed Agents (cerebro, manos, sesión)

**Qué es.** En el sistema multiagente de investigación, un agente líder planifica y lanza subagentes en paralelo con instrucciones precisas; cada uno explora con su propio contexto y devuelve resultados condensados. El esfuerzo se escala según la complejidad, y el uso de tokens explica gran parte del desempeño: rinde cuando el valor de la tarea lo justifica. Managed Agents separa el **cerebro** (modelo + harness), las **manos** (sandbox y herramientas donde se ejecuta) y la **sesión** (registro durable de eventos), con interfaces estables para que el harness pueda cambiar cuando mejoran los modelos.

**Qué exige MAGIA.**
1. **Arquitectura de referencia para todo agente MAGIA:**

| Componente | En MAGIA | Interfaz estable |
|---|---|---|
| Cerebro | Orquestador (`magia run`, `forge-planner`, `magia-builder`) + prompts + Skills | Entrada: intención y estado; salida: acciones |
| Manos | Workers en sandbox/worktree/contenedor, herramientas MCP, ejecución de código | `ejecutar(acción) → resultado` |
| Sesión | `docs/magia/runs/<id>/` (eventos, `progress.md`, `features.json`, `state.json`) | Registro solo-anexar, reanudable |

   Cambiar de modelo o de harness NO DEBE requerir cambiar manos ni sesión.
2. **Instrucciones a subagentes** con la Plantilla de Descripción (AF1.1): objetivo, formato de salida, herramientas, límites y criterio de terminado. Sin instrucciones vagas.
3. **Escalar el esfuerzo según la complejidad:**

| Complejidad | Subagentes | Ejemplo |
|---|---|---|
| Simple | 0–1 | Corregir un bug acotado |
| Media | 2–4 | Feature con 2–3 módulos |
| Alta | 5+ en olas | Epic Forge, migración |

4. **Salidas al sistema de archivos:** los subagentes escriben sus artefactos en archivos y devuelven solo una referencia y un resumen, para que el orquestador no pierda información en el paso intermedio.
5. **Multiagente solo cuando paga:** `magia-planner` justifica el uso de multiagente frente a un agente único, comparando costo y beneficio en el plan.

---

## Hitos

| Hito | Entregable | Criterio de aceptación |
|---|---|---|
| AFM1 | Plantilla de Descripción, taxonomía de fallas por propiedad, rúbricas anti-complacencia | Fallas de eval etiquetadas; `audit` muestra distribución |
| AFM2 | Harness de larga duración (`features.json`, `init.sh`, sesiones) | Run interrumpido se reanuda sin pérdida; no se puede marcar `passes` sin evidencia |
| AFM3 | Estándar de herramientas + `magia tool-eval` + carga diferida | Servidor MCP interno evaluado y mejorado con agentes |
| AFM4 | Sandbox declarativo + permisos | NM-2 opera sin confirmaciones de rutina; egreso fuera de allowlist bloqueado |
| AFM5 | Ablación de suposiciones en `magia frontier` | Componente innecesario detectado y retirado sin pérdida de calidad |
| AFM6 | Ruta de formación por rol y plan de 30 días | Owners certificados antes de aprobar gates |
