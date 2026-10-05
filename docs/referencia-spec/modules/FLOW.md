# MAGIA Flow — Módulo para Áreas Administrativas

**Perfil `flow`** · Extiende `SPEC.md` · v1.0 · Confidencial — Truck Depot Corporation

> Para áreas que crean productos con IA que **no son grandes desarrollos de software**: automatizaciones, reportes, documentos, asistentes internos y agentes de tareas. Objetivo: que el dueño del proceso pase de la necesidad a un producto funcionando **en días, no meses**, sin escribir código y sin saltarse el estándar MAGIA.

---

## L0. Cuándo aplica

| Señal | Flow |
|---|---|
| Quién lo impulsa | Dueño de proceso de Compras, RRHH, Contabilidad, Auditoría, Créditos y Cobros, SAC (operación), Marketing, BI |
| Tamaño | Sin código o código menor (< 2.000 líneas, scripts, fórmulas, flujos) |
| Usuarios | Internos del área, o salida revisada por una persona antes de llegar a terceros |
| Integración | Lectura de sistemas; escritura solo con checkpoint humano |

**Graduación obligatoria a perfil `estandar` o `forge`** cuando: > 50 usuarios activos; escribe en sistemas transaccionales sin checkpoint; atiende clientes externos de forma directa; o supera 2.000 líneas de código propio.

---

## L1. Dónde trabaja el usuario

Los usuarios administrativos no necesitan Claude Code. Flow distribuye las mismas Skills y Rules en dos superficies:

| Superficie | Para quién | Qué instala MAGIA |
|---|---|---|
| **Espacio de trabajo Claude (apps)** | Dueños de proceso | Proyecto por área con Constitución + Skills Flow + conectores aprobados (MCP) |
| **Repositorio ligero** (`profile: flow`) | AI Champion / analista | Igual que SPEC, con gates ligeros (L5) |

`magia flow publish <area>` empaqueta las Skills Flow del área para el espacio de trabajo, con la Constitución y las Rules como instrucciones de proyecto.

---

## L2. Ficha de Proceso (intake)

Todo producto Flow empieza con una Ficha de Proceso (`templates/flow/ficha-de-proceso.md`), que la IA ayuda a llenar conversando con el dueño:

| Campo | Ejemplo |
|---|---|
| Proceso actual | Conciliación mensual de pagos de clientes |
| Volumen y frecuencia | 1.200 movimientos / mes |
| Tiempo humano actual | Horas por ciclo (medido, no estimado) |
| Dolor principal | Errores de digitación, retrasos de cierre |
| Datos y sistemas | ERP (lectura), extracto bancario (CSV) |
| Clasificación de datos | Confidencial |
| Resultado deseado | Propuesta de conciliación + lista de excepciones para revisión |
| Quién revisa la salida | Analista contable |

Con la ficha, MAGIA calcula riesgo, sugiere **receta** (L3), estima horas ahorradas y crea el proyecto.

---

## L3. Recetas Flow

Plantillas probadas que resuelven el 80% de los casos administrativos. Cada receta trae: Skills, prompts, golden set semilla, conectores, formato de salida y checklist de prueba.

| # | Receta | Áreas típicas | Patrón (SPEC §16.3) |
|---|---|---|---|
| L3.1 | **Procesamiento de documentos** — extraer, validar y estructurar datos de facturas, órdenes, contratos, CVs | Compras, Contabilidad, RRHH | Encadenamiento |
| L3.2 | **Conciliación y validación** — cruzar fuentes y listar diferencias | Contabilidad, Créditos y Cobros, Auditoría | Encadenamiento + checkpoint |
| L3.3 | **Asistente de conocimiento** — responder sobre políticas, procedimientos y manuales con citas | RRHH, SAC, Compras | Llamada única + RAG |
| L3.4 | **Generador de documentos** — cartas, informes, comunicados en voz de marca desde plantilla + datos | Cobros, Marketing, RRHH | Evaluador–optimizador |
| L3.5 | **Reporte y análisis asistido** — de Excel/CSV/BI a hallazgos y gráficos explicados | BI, Contabilidad, Operaciones | Encadenamiento |
| L3.6 | **Clasificación y enrutamiento** — correos, tickets, solicitudes a la cola correcta | SAC, Compras, IT | Enrutamiento |
| L3.7 | **Agente de tareas supervisado** — ejecuta pasos repetitivos con aprobación antes de enviar o registrar | Cobros, Compras | Agente (NM-2/NM-3 con checkpoint) |
| L3.8 | **Revisión de cumplimiento** — revisar documentos contra checklist normativo o política | Auditoría, Contabilidad | Paralelización |

`magia flow new --recipe <id>` crea el proyecto con la receta. Las recetas viven en el Registro MAGIA y mejoran con cada uso.

---

## L4. Pipeline Flow (intención → producto)

```
Ficha de Proceso (dueño + IA)
  → Receta sugerida + riesgo calculado
  → IA construye el producto (prompts, Skills, conectores, formato de salida)
  → IA genera golden set desde 10–20 ejemplos reales del dueño (anonimizados)
  → Prueba guiada: el dueño valida resultados en una tabla simple (correcto / incorrecto / comentario)
  → magia-fixer ajusta hasta pasar umbrales
  → DECISIÓN HUMANA: dueño de proceso + AI Champion aprueban publicación
  → Publicación en el espacio de trabajo del área
  → Medición: horas ahorradas, errores, uso
```

Intervención humana: **llenar la ficha, aportar ejemplos reales, validar resultados y aprobar**. Todo lo demás lo hace la IA.

---

## L5. Gates ligeros (sin rebajar el estándar)

| Requisito | Flow riesgo bajo | Flow riesgo medio | Flow riesgo alto |
|---|---|---|---|
| Golden set mínimo | 10 casos | 20 casos | 50 casos (o graduar perfil) |
| Validación del dueño | Tabla de prueba guiada | Tabla + segunda persona | Tabla + AI Champion + Riesgo |
| `data-shield` | Siempre | Siempre | Siempre |
| `human-checkpoint` | Antes de enviar fuera del área | Antes de enviar o registrar | Antes de cualquier acción |
| Aprobación | Dueño + AI Champion | Dueño + AI Champion | Comité |
| Rules R1–R9 | Todas | Todas | Todas |

Las Rules Core no cambian por perfil. Lo que se aligera es la **ceremonia**, no la protección.

---

## L6. Skills Flow

| Skill | Función |
|---|---|
| `flow-intake` | Conduce la entrevista y redacta la Ficha de Proceso |
| `flow-recipe` | Selecciona y adapta la receta; justifica si ninguna aplica |
| `flow-examples` | Convierte ejemplos reales en golden set anonimizado |
| `flow-test-table` | Genera la tabla de prueba guiada y procesa la validación del dueño |
| `flow-excel` | Lectura, limpieza y análisis seguro de planillas; fórmulas y gráficos explicados |
| `flow-docs` | Extracción estructurada de documentos con validación de campos |
| `flow-writer` | Redacción en voz de marca desde plantilla + datos, con revisión |
| `flow-roi` | Mide horas ahorradas y errores evitados antes/después |

Se suman a las Skills base de SPEC §11 (`data-shield`, `grounding`, `brand-voice`, `human-checkpoint`, `telemetry` según riesgo).

---

## L7. Métricas Flow

| Métrica | Qué mide |
|---|---|
| Días de ficha a producto publicado | Velocidad |
| Horas humanas ahorradas por mes, por proceso | Valor |
| Tasa de errores del proceso antes/después | Calidad |
| % de salidas aceptadas sin edición por el revisor | Calidad percibida |
| Recetas reutilizadas por área | Efecto compuesto |
| Productos graduados a `estandar`/`forge` | Crecimiento sano |

---

## L8. Hitos Flow

| Hito | Entregable | Criterios de aceptación |
|---|---|---|
| **FL1 Intake y recetas** | `flow-intake`, `flow-recipe`, recetas L3.1, L3.3, L3.5 | Dueño no técnico crea un producto desde la ficha con la receta sin escribir código |
| **FL2 Prueba guiada y gates ligeros** | `flow-examples`, `flow-test-table`, gates L5 | Producto no se publica sin tabla validada y golden set mínimo |
| **FL3 Publicación en espacio de trabajo** | `magia flow publish`, empaquetado de Skills y conectores | Área publicada con Constitución, Skills y conectores aprobados |
| **FL4 Recetas completas y ROI** | L3.2, L3.4, L3.6–L3.8, `flow-roi` | Medición antes/después reportada en `magia audit` |

Piloto sugerido: Contabilidad (L3.2 conciliación) y RRHH (L3.3 asistente de políticas).

---

## L9. Marcos de Anthropic en Flow

Detalle en `modules/ANTHROPIC-FRAMEWORKS.md`.

| Sección Flow | Marco | Aplicación |
|---|---|---|
| L2 | AF1 Delegación | La Ficha de Proceso incluye qué hace la IA y qué decide la persona |
| L3, L6 | AF1 Descripción | Cada receta trae sus prompts en la Plantilla de Descripción MAGIA, listos para usar |
| L4 | AF1 Discernimiento | La prueba guiada es el ciclo Descripción–Discernimiento: el dueño marca resultados y la IA ajusta |
| L4 | AF2 4 propiedades | Cada resultado marcado como incorrecto se clasifica (conocimiento, memoria, direccionabilidad, predicción) para aplicar la corrección adecuada |
| L5 | AF1 Diligencia | El dueño del proceso firma la publicación y responde por el resultado |
| L8 | AF4 Hoja de ruta | Formación: Claude 101 → AI Fluency: Framework & Foundations → Introducción a Claude Cowork; plan de 30 días por área |
| L2, L4, L5 | AF14 AI Fluency | La Ficha de Proceso incluye conciencia del problema y modo (automatización, aumentación o agencia); la prueba guiada etiqueta cada falla como producto, proceso o desempeño; todo producto publicado lleva Declaración de Diligencia; RRHH, Créditos y Auditoría exigen revisión de sesgo |
| L3 | AF15 Claude API | L3.1 y L3.8 usan soporte de PDF e imágenes con salida estructurada y citas a la página; L3.3 usa RAG híbrido con contextual retrieval; L3.5 usa Files API + ejecución de código en sandbox; trabajos masivos de cualquier receta corren en modo batch |
| L0, L2, L3 | AF16 Small Businesses | Flow recibe workflows graduados desde MAGIA Diario: la Ficha de Workflow alimenta la Ficha de Proceso; el Contexto de Área es la base de cada receta; la matriz de datos de clientes aplica a toda receta de SAC, ventas, marketing y cobros |
