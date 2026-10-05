# MAGIA — AI Fluency: Framework & Foundations aplicado

**Módulo de referencia (AF14)** · Profundiza AF1 de `modules/ANTHROPIC-FRAMEWORKS.md` · Extiende `SPEC.md`, `FLOW.md`, `FORGE.md` · v1.0 · Confidencial — Truck Depot Corporation

> El curso **AI Fluency: Framework & Foundations** de Anthropic Academy (marco de Rick Dakan y Joseph Feller) define la fluidez con IA como colaborar con ella de forma **efectiva, eficiente, ética y segura**, mediante cuatro competencias (las 4D) aplicadas en tres modos de interacción. MAGIA convierte cada concepto en un artefacto, un campo de configuración o un criterio de gate. Es el **manual operativo humano** bajo todo el resto del marco.

## Mapa

| Concepto del curso | En MAGIA | Artefacto |
|---|---|---|
| 4 adverbios: efectiva, eficiente, ética, segura | Las 4 dimensiones de evaluación de todo proyecto | Puntaje 4A en `magia audit` |
| 3 modos: Automatización, Aumentación, Agencia | Campo `mode` en cada paso, tarea y producto | `magia.config.json`, plan, Ficha Flow |
| Delegación = conciencia del problema + de la plataforma + delegación de tareas | Plan de Delegación obligatorio | `docs/magia/delegation.md` |
| Descripción = producto + proceso + desempeño | Plantilla de Descripción 3P | `templates/descripcion-magia.md` |
| Discernimiento = evaluar producto, proceso y desempeño | Evals de resultado, de trayectoria y de comportamiento | Suites en `evals/` |
| Ciclo Descripción–Discernimiento | Bucle evaluador–optimizador / fixer / prueba guiada | `progress.md` |
| Diligencia = creación, transparencia, despliegue | Declaración de Diligencia en cada entregable | `templates/declaracion-diligencia.md` |

---

## AFF1. Los cuatro adverbios como dimensiones de calidad

| Adverbio | Pregunta | Pilar MAGIA | Medido por |
|---|---|---|---|
| **Efectiva** | ¿Logra el resultado correcto y útil? | Calidad | Evals `correct`, `grounded`, aceptación del revisor |
| **Eficiente** | ¿Con el mínimo de tiempo, costo y esfuerzo humano? | Desempeño / Motor de Valor | Costo por tarea, lead time, intervenciones humanas |
| **Ética** | ¿Respeta la Constitución, es transparente y justa? | Gobernanza | Declaración de Diligencia, `disclosure`, revisión de sesgo en RRHH/Créditos |
| **Segura** | ¿Protege datos, personas y operación? | Seguridad | R1–R9, red-team, incidentes |

`magia audit` reporta un **puntaje 4A** por proyecto (0–100 por adverbio, umbrales del Comité). Un proyecto no se considera exitoso si mejora un adverbio a costa de otro: la eficiencia nunca compensa una caída en efectividad, ética o seguridad.

---

## AFF2. Los tres modos de interacción

| Modo | Qué es | Dónde aparece en MAGIA | Exigencia 4D específica |
|---|---|---|---|
| **Automatización** | La IA ejecuta tareas bien definidas según instrucciones | Recetas Flow, rutinas programadas, codemods, tareas mecánicas de la flota | Descripción de producto precisa; Discernimiento por muestreo y evals de regresión |
| **Aumentación** | Persona e IA piensan juntas; las ideas van en ambas direcciones | Brief, spec, modo plan, revisión de arquitectura, análisis BI, `/forge-explain` | Ciclo Descripción–Discernimiento intensivo; la decisión final es humana |
| **Agencia** | Se configura a la IA para actuar de forma independiente en nombre de alguien | `magia run`, flota Forge, agentes NM-3/NM-4, agentes de tareas Flow | Delegación explícita de límites; Diligencia de despliegue; sandbox y checkpoints |

**Requisito:** cada paso del pipeline, cada tarea del plan y cada producto Flow declara `mode: automatizacion | aumentacion | agencia`. El modo determina:
- **Agencia** exige nivel de autonomía NM-2+ con todas sus salvaguardas (SPEC §16.2) y sandbox (AF10).
- **Aumentación** exige que el registro de decisiones identifique qué decidió la persona.
- **Automatización** exige criterio de terminado verificable sin juicio humano.

Error común que MAGIA previene: tratar como automatización algo que requiere juicio (se detecta cuando una tarea "automatizada" acumula correcciones humanas; `magia scout` la propone reclasificar a aumentación).

---

## AFF3. Delegación — Plan de Delegación obligatorio

La delegación tiene tres partes, y las tres quedan escritas antes de construir:

### AFF3.1 Conciencia del problema
Antes de involucrar a la IA: ¿qué se quiere lograr, cómo se ve el éxito y qué pensamiento requiere? Lo responde el experto de dominio, no la IA.
- Campo obligatorio en `brief.md` y en la Ficha de Proceso: **objetivo, criterio de éxito, conocimiento de dominio necesario**.
- Si el owner no puede describir el éxito, el gate de la etapa 1 no se aprueba.

### AFF3.2 Conciencia de la plataforma
Conocer honestamente qué hace bien y mal cada sistema disponible.
- **Mapa de Plataformas MAGIA** (`packages/core/platforms.json`, publicado en el Registro): para cada modelo, superficie (Claude apps, Claude Code, API, Agent SDK) y conector aprobado: fortalezas, limitaciones conocidas, costo relativo, latencia, datos permitidos y casos recomendados.
- Lo mantiene `magia frontier` con evidencia de MAGIA Bench (FORGE F14); nunca con afirmaciones de marketing.
- El Plan de Delegación cita qué plataforma usa cada tarea y por qué.

### AFF3.3 Delegación de tareas
Dividir el trabajo y asignar cada parte a la persona o a la IA según sus fortalezas.

**Plan de Delegación** (`docs/magia/delegation.md`, plantilla `templates/plan-de-delegacion.md`):

| Tarea | Responsable | Modo | Plataforma | Por qué | Cómo se verifica |
|---|---|---|---|---|---|
| Definir criterios de éxito | Persona | — | — | Requiere conocimiento de negocio | Aprobación del owner |
| Generar golden set inicial | IA | Aumentación | Claude Code | La IA propone, la persona curó | Revisión de 20 casos |
| Implementar endpoints | IA | Agencia | Flota Forge | Contratos claros, verificable | Tests de aceptación |

- El agente `magia-architect` redacta el plan; la persona lo aprueba junto con el brief.
- `magia check` falla si una tarea en modo agencia no tiene método de verificación.
- El plan se actualiza al cerrar el proyecto con lo aprendido (qué convino delegar y qué no) y alimenta al Registro.

---

## AFF4. Descripción — Plantilla 3P

La descripción tiene tres dimensiones. La Plantilla de Descripción MAGIA (AF1.1) se reorganiza en ellas:

| Dimensión | Pregunta | Secciones de la plantilla |
|---|---|---|
| **Producto** | ¿Qué quiero obtener? | Objetivo, Formato, Ejemplos, Terminado si |
| **Proceso** | ¿Cómo quiero que lo haga? | Contexto, Pasos o enfoque, Restricciones |
| **Desempeño** | ¿Cómo quiero que se comporte durante la interacción? | Rol, tono, nivel de crítica, cuándo preguntar y cuándo decidir |

- La sección **Desempeño** es obligatoria en modo aumentación (p. ej. "Cuestiona mis supuestos; señala riesgos antes de proponer soluciones") y en agencia (p. ej. "Decide solo dentro del plan; escala por excepción según SPEC §27.1").
- Las Skills generadas por el agente instalador DEBEN incluir las tres dimensiones; `magia check` valida la presencia de las secciones.
- Ante una salida que no sirve, el primer paso es revisar cuál de las tres dimensiones faltó o fue ambigua (diagnóstico combinado con las 4 propiedades de AF2).

---

## AFF5. Discernimiento — evaluar en tres niveles

| Nivel | Pregunta | Mecanismo MAGIA |
|---|---|---|
| **Producto** | ¿El resultado es correcto, útil, completo y de calidad? | Evals de resultado (SPEC §15), `magia-verify`, prueba guiada Flow |
| **Proceso** | ¿El razonamiento y los pasos fueron sólidos? | Revisión de transcripciones y trayectorias (AF9); `magia-reviewer` revisa el plan y las decisiones, no solo el diff |
| **Desempeño** | ¿Se comportó como se pidió en la interacción? | Rúbrica de comportamiento: respetó límites, escaló cuando debía, evitó complacencia, verbosidad y exceso de cautela |

**Ciclo Descripción–Discernimiento formalizado:**
```
describir (3P) → obtener resultado → discernir (producto, proceso, desempeño)
   → ¿cumple? sí → aceptar
            no → identificar la dimensión de Descripción que falló → ajustar → repetir
```
- Automatizado en `magia-fixer`, `magia optimize` y en el patrón evaluador–optimizador.
- Manual en la prueba guiada Flow (L4): cada resultado marcado como incorrecto pide al dueño indicar si falló el qué (producto), el cómo (proceso) o el comportamiento (desempeño).
- Límite de iteraciones; al agotarse, escalar con diagnóstico (SPEC §27.1).

---

## AFF6. Diligencia — creación, transparencia y despliegue

| Tipo | Pregunta | Requisito MAGIA |
|---|---|---|
| **De creación** | ¿Elegí bien los sistemas y la forma de trabajar con ellos? | Solo plataformas del Mapa (AFF3.2) y modelos aprobados (R3); datos según clasificación (R2) |
| **De transparencia** | ¿Soy honesto sobre el papel de la IA con quienes corresponde? | **Declaración de Diligencia** en cada entregable; divulgación a clientes (R7) |
| **De despliegue** | ¿Me hago responsable de lo que uso o comparto? | Responsable humano nombrado; verificación antes de publicar; firma en el gate |

### AFF6.1 Declaración de Diligencia
Obligatoria en todo Paquete de Evidencia (SPEC §27.2), en todo producto Flow publicado y en documentos internos relevantes generados con IA (informes al Directorio, auditoría, decisiones de crédito o RRHH). Plantilla: `templates/declaracion-diligencia.md`. Contenido: qué hizo la IA, qué hicieron las personas, qué se verificó y cómo, limitaciones conocidas, responsable.

### AFF6.2 Áreas sensibles
En RRHH, Créditos y Cobros y Auditoría, la diligencia de despliegue exige además revisión de sesgo e impacto sobre personas antes de publicar, y que ninguna decisión que afecte a una persona se tome solo por IA (checkpoint humano obligatorio).

---

## AFF7. Prácticas de Descripción (técnicas de prompting)

El curso enseña técnicas fundamentales de prompting y cómo diagnosticar una salida que falla. MAGIA las fija en la plantilla 3P y en el manual de corrección:
- Dar contexto suficiente (sin saturar: AF5).
- Mostrar ejemplos de lo que se quiere.
- Especificar formato y restricciones.
- Dividir tareas complejas en pasos.
- Pedir que razone antes de responder en tareas de análisis.
- Definir rol, tono y nivel de crítica (dimensión Desempeño).

Diagnóstico: salida mala → ¿faltó contexto? ¿faltaron ejemplos? ¿formato ambiguo? ¿tarea demasiado grande? ¿no se pidió razonar? ¿comportamiento no especificado? → ajustar la dimensión correspondiente.

---

## AFF8. Fluidez de las personas

- **Formación:** el curso es obligatorio para **todos** los roles con acceso a MAGIA (base de la ruta AF4).
- **Autoevaluación 4D** al cierre de cada proyecto (5 minutos, en el Paquete de Evidencia o en la publicación Flow): ¿delegamos bien? ¿describimos bien? ¿discernimos a tiempo? ¿fuimos diligentes? Lo aprendido se agrega al Plan de Delegación y al Registro.
- **Indicador de fluidez por área** en `magia audit`: % de proyectos con Plan de Delegación completo, % de entregables con Declaración de Diligencia, iteraciones promedio del ciclo Descripción–Discernimiento, correcciones humanas por tarea automatizada.

---

## Hitos

| Hito | Entregable | Criterio de aceptación |
|---|---|---|
| AFFM1 | Campo `mode`, Plan de Delegación, Mapa de Plataformas | `check` falla sin plan de delegación o con tarea en agencia sin verificación |
| AFFM2 | Plantilla de Descripción 3P en todas las Skills y recetas | `check` valida las tres dimensiones |
| AFFM3 | Discernimiento en 3 niveles: rúbrica de proceso y de desempeño | Evals y prueba guiada etiquetan el nivel de la falla |
| AFFM4 | Declaración de Diligencia + revisión de sesgo en áreas sensibles | Ningún PR ni producto Flow se publica sin declaración |
| AFFM5 | Puntaje 4A, autoevaluación 4D e indicador de fluidez en `audit` | Reporte trimestral por área |
