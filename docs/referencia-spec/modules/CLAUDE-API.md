# MAGIA — Building with the Claude API aplicado

**Módulo de referencia (AF15)** · Plano de **Ejecución** · Extiende `SPEC.md` §4.2, §11.3, §15, §20 · `FLOW.md` · `FORGE.md` · v1.0 · Confidencial — Truck Depot Corporation

> El curso **Building with the Claude API** de Anthropic Academy cubre cómo integrar Claude en aplicaciones de producción: acceso a la API, evaluación e ingeniería de prompts, uso de herramientas, RAG y búsqueda agéntica, capacidades avanzadas (razonamiento extendido, imágenes, PDF, citas, caché de prompts, ejecución de código, Files API), MCP, y workflows y agentes. Este módulo convierte todo eso en el **estándar de construcción de productos IA de Truck Depot** y en el diseño de `@truckdepot/magia-runtime`.
>
> Nota para quien implemente: parámetros, nombres de modelos y endpoints DEBEN confirmarse contra la documentación vigente de la API de Claude. Este módulo fija el comportamiento requerido.

## Mapa

| Módulo del curso | Estándar MAGIA | Sección |
|---|---|---|
| Acceso a la API | Cliente corporativo: autenticación, conversación, streaming, temperatura, salida estructurada | API1 |
| Evaluación de prompts | Pipeline de eval de prompts como requisito de CI | API2 |
| Ingeniería de prompts | Prompts versionados, XML, ejemplos, claridad | API3 |
| Uso de herramientas | Estándar de tool use y herramientas integradas | API4 |
| RAG y búsqueda agéntica | Pipeline RAG híbrido con contextual retrieval, reranking y citas | API5 |
| Capacidades de Claude | Políticas de razonamiento extendido, visión, PDF, citas, caché, ejecución de código, Files API, batch | API6 |
| MCP | Construcción de servidores MCP corporativos | API7 |
| Workflows y agentes | Patrones en runtime y Agent SDK | API8 |

---

## API1. Cliente corporativo (`magia-runtime` → Claude API)

| Requisito | Detalle |
|---|---|
| Autenticación | Llave solo desde el vault (R6); rotación; una llave por entorno y por producto para atribuir costo |
| Conversación | La API no guarda estado: el runtime mantiene el historial en un **conversation store** con recorte y compactación (AF5); nunca se envía historial con datos `restringido` sin redactar |
| Prompt de sistema | Construido desde la plantilla versionada (API3): Constitución resumida + rol + Rules del producto |
| Temperatura por clase de tarea | `extraccion`/`clasificacion`/`codigo`: baja · `generacion` de contenido: media · `ideacion`: alta. Definida en la plantilla, no en el código |
| Streaming | Obligatorio en interfaces de usuario (latencia percibida); las guardas post-generación (R1, R4) se aplican antes de mostrar contenido sensible o al cierre del bloque, según riesgo |
| Salida estructurada | Toda salida consumida por código usa esquema (salidas estructuradas o herramienta con esquema); técnicas de respaldo: prellenado de respuesta y secuencias de parada. Validación con el esquema; reintento acotado ante inválido |
| Resiliencia | Reintentos con backoff ante errores transitorios; límite de concurrencia por producto (evita rate limits); timeout por clase |
| Enrutamiento | Modelo elegido por clase de tarea según `magia optimize` (SPEC §31) |
| `max_tokens` | Explícito por plantilla; nunca el máximo por defecto |

Interfaz ampliada (complementa SPEC §11.3):
```ts
magia.llm.call(templateId: string, vars: Record<string, unknown>, opts?: {
  stream?: boolean; schema?: JsonSchema; tools?: ToolRef[]; thinking?: ThinkingPolicy;
  cache?: 'auto' | 'off'; citations?: boolean; files?: FileRef[]; mode?: 'interactive' | 'batch';
}): Promise<LlmResult> | AsyncIterable<LlmChunk>
```

---

## API2. Evaluación de prompts (gate de CI)

Flujo del curso, convertido en obligatorio:
1. **Generar dataset de prueba:** casos reales anonimizados + casos generados por Claude a partir de la spec (incluyendo `unknown` y `adversarial`).
2. **Ejecutar:** plantilla + caso → respuesta, con concurrencia controlada.
3. **Calificar:** primero **calificadores de código** (formato, esquema, campos, regex, valores exactos); después **calificación por modelo** con rúbrica (calidad, tono, utilidad); humano para calibrar.
4. **Puntuar y comparar** contra la versión anterior de la plantilla.

Regla: **todo cambio en una plantilla de prompt (`prompts/**`) dispara `magia eval` de esa plantilla en CI**; sin eval no hay merge (R5). Integra SPEC §15 y AF9.

---

## API3. Ingeniería de prompts — plantillas versionadas

Los prompts son código: viven en `prompts/<id>@<version>.md`, con frontmatter, y se referencian por ID desde el runtime.

| Técnica del curso | Estándar MAGIA |
|---|---|
| Claro y directo | Primera línea: la tarea en una oración imperativa |
| Específico | Formato, longitud, criterios y qué evitar, explícitos (Plantilla 3P, AF14) |
| Estructura con etiquetas XML | Secciones en etiquetas (`<contexto>`, `<documentos>`, `<instrucciones>`, `<formato>`); **todo contenido externo o del usuario va dentro de etiquetas de datos** y el prompt indica que no son instrucciones (defensa contra inyección de prompt) |
| Ejemplos | 1–3 ejemplos en `<ejemplo>`, diversos y representativos |
| Rol y descomposición | Rol en el prompt de sistema; tareas complejas encadenadas (SPEC §16.3) |

Orden obligatorio para aprovechar la caché (API6.5): **estático primero** (sistema, Constitución, instrucciones, ejemplos, catálogo de referencia) → **dinámico al final** (documentos recuperados, entrada del usuario).

Plantilla de referencia: `templates/runtime/prompt-template.example.md`.

---

## API4. Uso de herramientas

| Requisito | Detalle |
|---|---|
| Esquemas | JSON Schema estricto, descripciones según AF8 (para alguien nuevo, con ejemplos) |
| Bucle de herramientas | `tool_use` → ejecutar → `tool_result` → continuar; máximo de iteraciones por plantilla; errores devueltos como resultado accionable, no como excepción opaca |
| Varias herramientas y llamadas en paralelo | Permitidas cuando son independientes; el runtime las ejecuta concurrentemente |
| Streaming de parámetros de herramientas | Para herramientas con entradas grandes en interfaces interactivas |
| Herramientas que mutan | Pasan por `humanCheckpoint` si son irreversibles (R4, NM-3) |
| Herramienta de edición de texto | Solo en sandbox y sobre rutas permitidas |
| Búsqueda web | Solo con allowlist de dominios por producto; prohibida en flujos con datos `confidencial`/`restringido`; resultados tratados como contenido no confiable y citados |
| Telemetría | Cada llamada a herramienta se registra (nombre, duración, éxito, tokens del resultado) |

---

## API5. RAG de producción

Pipeline estándar `magia.grounding` (implementa R1):

```
ingesta → chunking por estructura → contextualización de chunks → embeddings + índice BM25
consulta → búsqueda híbrida (densa + BM25) → fusión → reranking → top-k → prompt con <documentos>
respuesta → citas nativas → grounding.require (valida que cada afirmación cite un chunk real)
```

| Etapa | Estándar |
|---|---|
| Chunking | Por estructura del documento (secciones, tablas, fichas) antes que por tamaño fijo; solapamiento moderado; metadatos (fuente, fecha, clasificación, SKU) |
| **Contextual retrieval** | Cada chunk se indexa con un breve contexto generado por Claude que lo sitúa en su documento (p. ej. "Ficha técnica del filtro FL-2201, sección compatibilidad"). Se genera en batch y con caché del documento |
| Índice multiíndice | Búsqueda semántica (embeddings) + léxica (BM25) — imprescindible para números de parte y códigos exactos |
| Reranking | Sobre los candidatos fusionados antes de pasar al modelo |
| Citas | Función de citas de Claude activada en todo flujo de riesgo medio/alto; `grounding.require` verifica que las citas existan y correspondan |
| Búsqueda agéntica | Para preguntas complejas, el agente decide qué buscar y en cuántos pasos (con presupuesto) |
| Evaluación de recuperación | Suite propia: recall@k y precisión sobre preguntas con respuesta conocida; se mide separada de la calidad de generación |
| Frescura | Reindexado incremental cuando cambia la fuente (catálogo, políticas); `fecha` en metadatos y en citas |

---

## API6. Capacidades de Claude — políticas de uso

### API6.1 Razonamiento extendido
- **Política:** se activa **solo** cuando los evals demuestran que, con el prompt ya optimizado, la precisión no alcanza el umbral. Primero prompt, después razonamiento.
- Presupuesto de razonamiento explícito por plantilla; costo y latencia medidos.
- Uso típico: diagnóstico técnico complejo, análisis financiero, planificación (agentes `architect`/`planner`).

### API6.2 Imágenes
- Identificación de repuestos por foto (Tienda, SAC): imagen → descripción estructurada → RAG del catálogo → candidatos citados → confirmación del cliente. Nunca se confirma compatibilidad solo por la imagen (R1).
- Documentos escaneados (facturas, guías de despacho).

### API6.3 PDF
- Facturas, órdenes de compra, contratos, fichas técnicas de proveedores, manuales (Flow L3.1, L3.8).
- Extracción con esquema + validación de campos + citas a la página.

### API6.4 Citas
- Obligatorias en riesgo medio/alto (R1); visibles al usuario cuando la respuesta es de cara al cliente.

### API6.5 Caché de prompts
- Todo prefijo estable > umbral de tamaño se marca para caché: prompt de sistema, Constitución, ejemplos, catálogo o políticas de referencia, documento analizado en varias preguntas.
- `magia-perf-optimizer` reporta tasa de aciertos de caché; objetivo de tasa fijado por el Comité.

### API6.6 Ejecución de código y Files API
- Análisis de datos (Flow L3.5, BI): archivos subidos una vez con Files API y analizados por la herramienta de ejecución de código en sandbox; solo resultados y gráficos vuelven al usuario (AF11).
- Datos `restringido`: prohibido salvo aprobación del Comité.

### API6.7 Procesamiento por lotes
- Modo `batch` para trabajo no urgente y masivo: descripciones del catálogo completo, contextualización de chunks, clasificación histórica de tickets, evals, MAGIA Bench. Menor costo; resultados validados con los mismos evals.

---

## API7. MCP — servidores corporativos

- Primitivas: **herramientas** (acciones), **recursos** (datos de lectura), **prompts** (plantillas reutilizables).
- Servidores iniciales (D6): catálogo de repuestos, inventario, tickets SAC; después ERP (lectura), BI.
- Estándar de herramientas AF8; carga diferida AF11; permisos mínimos R9.
- Prueba obligatoria con el inspector de MCP y con `magia tool-eval` antes de publicar en la allowlist.
- Cada servidor se publica en el Registro MAGIA y en el plugin correspondiente (AF13).

---

## API8. Workflows y agentes en producto

- **Workflow determinista** (encadenamiento, enrutamiento, paralelización) cuando los pasos se conocen: más barato, predecible y fácil de evaluar.
- **Agente** cuando los pasos no se conocen: el modelo inspecciona el entorno, usa herramientas y decide. Implementado con Claude Agent SDK, con sandbox (AF10), presupuesto y arquitectura cerebro / manos / sesión (AF12).
- La elección se justifica con evals (SPEC §16.3, P3).

---

## API9. Arquitectura de referencia de un producto IA Truck Depot

```
Interfaz (web / app / WhatsApp / interno)
  → Backend del producto
  → magia.respond()
      1. dataShield.redact                       (R2)
      2. grounding.retrieve  — híbrido + rerank    (API5)
      3. llm.call(plantilla@versión)              (API1, API3)
           · prefijo estático en caché           (API6.5)
           · herramientas MCP                    (API4, API7)
           · citas activadas                     (API6.4)
           · razonamiento solo si eval lo exige  (API6.1)
      4. grounding.require — valida citas        (R1)
      5. hallucinationGuard.check → pass / fallback / escalate (R4)
      6. brandVoice.apply + disclose             (R7)
      7. telemetry.emit                          (§19)
  → streaming al usuario
```

### API9.1 Productos de referencia
| Producto | Área | Capacidades del curso |
|---|---|---|
| Identificador de repuestos por foto | Tienda, SAC | Imágenes + RAG híbrido + citas + salida estructurada |
| Asistente SAC | SAC | RAG + herramientas MCP (pedidos, stock) + streaming + citas + checkpoint |
| Extractor de facturas y órdenes | Compras, Contabilidad | PDF + salida estructurada + validación + batch |
| Catálogo enriquecido | Marketing, Tienda | Batch + caché + evals de brand-voice |
| Analista de ventas | BI, Operaciones | Files API + ejecución de código + razonamiento extendido justificado |
| Asistente de políticas | RRHH | RAG con contextual retrieval + citas |

---

## API10. Manual de costo y latencia

| Palanca | Efecto | Cuándo |
|---|---|---|
| Caché de prompts | Menor costo y latencia en prefijos repetidos | Siempre que haya prefijo estable |
| Batch | Menor costo | Trabajo masivo no urgente |
| Enrutamiento de modelos | Menor costo por tarea | Siempre (`magia optimize`) |
| Streaming | Menor latencia percibida | Interfaces de usuario |
| `max_tokens` ajustado | Evita respuestas largas e innecesarias | Siempre |
| Salida estructurada | Evita reintentos por formato inválido | Toda salida consumida por código |
| Recorte de contexto y RAG top-k ajustado | Menos tokens de entrada | Siempre |
| Razonamiento solo si el eval lo exige | Evita costo y latencia innecesarios | Por política API6.1 |
| Ejecución de código para datos | Datos voluminosos fuera del contexto | Análisis y transformación |

---

## Hitos

| Hito | Entregable | Criterio de aceptación |
|---|---|---|
| APIM1 | Cliente `magia.llm.call` con conversación, streaming, salida estructurada, resiliencia | Tests de reintento, esquema inválido y límite de concurrencia |
| APIM2 | Plantillas versionadas en `prompts/` + eval por plantilla en CI | Cambio de plantilla sin eval bloquea el merge |
| APIM3 | Pipeline RAG híbrido con contextual retrieval, reranking y citas | Suite de recuperación con recall@k medido; R1 verificado con citas nativas |
| APIM4 | Herramientas, búsqueda web con allowlist, MCP corporativos | Servidor de catálogo publicado tras inspector y `tool-eval` |
| APIM5 | Políticas de razonamiento, visión, PDF, Files API, ejecución de código, batch | Identificador por foto y extractor de facturas en piloto con evals en verde |
| APIM6 | Manual de costo/latencia en `magia-perf-optimizer` | Reporte de caché, batch y enrutamiento por producto |
