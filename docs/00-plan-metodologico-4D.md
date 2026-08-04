# Plan de colaboración con IA — Creación de MAGIA
### Marco de Arquitectura y Gobernanza de Inteligencia Artificial (enfocado en Desarrollo de Software)

---

## 0. Resumen ejecutivo

MAGIA busca llevar al equipo del nivel "usamos IA de forma suelta y ad-hoc" al
nivel "empresa avanzada": herramientas de IA estandarizadas, reutilizables,
gobernadas y con valor de negocio medible. Este plan no te da MAGIA ya escrito
(eso depende de tu dominio, stack y madurez real), sino **cómo construirlo bien
usando IA como acelerador**, sin que el resultado sea una carpeta bonita que
nadie sigue. Lo que queda 100% en manos humanas: las decisiones de gobierno
(quién aprueba qué, qué riesgo se tolera) y la validación final de cada pieza.
Lo que acelera la IA: investigación, primeros borradores, plantillas, checklists,
comparación de patrones de arquitectura. Riesgo principal: construir un marco
"de cartón" —documentado pero no adoptado— por saltarse la Diligencia y el
Discernimiento en el camino.

---

## 1. Delegation — qué hace la IA

### Problema y objetivo

**Objetivo de negocio:** que el desarrollo de software de la empresa incorpore
IA de forma **ágil** (rápido de adoptar), **estandarizada** (mismos patrones,
mismo vocabulario, mismas plantillas entre equipos) y **gobernada** (con control
de riesgo, cumplimiento y trazabilidad), al nivel de una empresa que ya crea
herramientas corporativas de valor agregado con IA (no solo "usa Copilot").

**MAGIA, para que sea un marco real y no un PDF decorativo, necesita cubrir
al menos estos cinco pilares.** Cada uno es una pieza independiente que se
puede construir en paralelo:

| Pilar | Qué resuelve | Ejemplo de contenido |
|---|---|---|
| **1. Arquitectura de referencia** | Cómo se integra la IA en el software (patrones aprobados) | Cuándo usar RAG vs. fine-tuning vs. prompting simple; cuándo un agente con herramientas vs. un flujo determinista; catálogo de patrones de integración (API directa, MCP, orquestador, copiloto embebido) |
| **2. Gobernanza y roles** | Quién decide, quién aprueba, quién responde | Comité de gobernanza de IA, matriz RACI, niveles de riesgo por caso de uso, proceso de aprobación de un nuevo caso de uso |
| **3. Estándares de desarrollo** | Cómo se construye con calidad y consistencia | Guía de prompting/context engineering interna, estándares de testing y evaluación de features con IA, versionado de prompts, CI/CD para componentes de IA |
| **4. Catálogo de capacidades** | Qué herramienta/modelo usar para qué caso | Matriz de decisión (tarea → modelo/herramienta recomendada), lista de proveedores aprobados, costos de referencia |
| **5. Ciclo de vida y diligencia** | Cómo pasa una idea de propuesta a producción sin generar riesgo | Compuertas de creación/transparencia/despliegue (ver sección 4), checklist de salida a producción, plan de auditoría periódica |

**Restricciones que debes responder tú antes de delegar nada a la IA**
(preguntas de dominio, no de IA — respóndelas primero, aunque sea en borrador):

- ¿Qué tipo de datos maneja el software (PII, datos financieros, secretos
  comerciales)? → define el techo de riesgo de MAGIA.
- ¿Hay regulación aplicable (protección de datos, sector financiero/salud,
  etc.) en los países donde operan?
- ¿Qué tolerancia a error existe por tipo de caso de uso (un chatbot interno
  no es lo mismo que un sistema que decide algo sobre un cliente)?
- ¿Qué infraestructura y proveedores de IA ya están aprobados o en uso hoy?
- ¿Cuál es el criterio de éxito de MAGIA en 6 meses? (adopción, tiempo de
  entrega, incidentes evitados, número de herramientas estandarizadas, etc.)

`[por definir: respuestas concretas de tu organización a lo anterior — sin
esto, cualquier versión de MAGIA que se escriba será genérica]`

### Modo de colaboración

**Augmentation** como modo dominante: MAGIA es una decisión estratégica y de
arquitectura, no una tarea repetible. La IA debe cuestionar, comparar
alternativas y ayudarte a pensar, no ejecutar un molde fijo.

Dentro de MAGIA, con **Automation** para tareas puntuales una vez el marco esté
definido: generar plantillas de documentación, generar el primer borrador de una
política a partir de un esqueleto aprobado, resumir investigación de mercado.

**Agency** solo para partes operativas *después* de que MAGIA exista: por
ejemplo, un asistente que evalúa automáticamente si un nuevo caso de uso cumple
el checklist de diligencia y escala a un humano si no está claro — nunca para
decidir gobernanza por sí mismo.

### Reparto de tareas

| Subtarea | Dueño | Razón |
|----------|-------|-------|
| Definir los 5 pilares y su alcance real para tu empresa | Humano | Requiere conocer el negocio, el riesgo y la cultura interna |
| Investigar cómo estructuran esto empresas de referencia (bancos, tech, consultoras) | IA + Humano | IA busca y sintetiza; humano filtra qué aplica a tu contexto |
| Redactar la matriz de decisión "tarea → modelo/herramienta" | IA + Humano | IA propone estructura y contenido inicial; humano valida con casos reales |
| Diseñar el comité de gobernanza y matriz RACI | Humano | Depende de la estructura organizacional real, no es delegable |
| Redactar plantillas (política, checklist, ficha de caso de uso) | IA + Humano | IA acelera el primer borrador; humano ajusta lenguaje y umbrales de riesgo |
| Definir niveles de riesgo por caso de uso | Humano (con apoyo de IA para investigar marcos existentes) | Es una decisión de tolerancia al riesgo de la empresa |
| Escribir estándares técnicos (prompting, testing, CI/CD de IA) | IA + Humano | IA redacta desde mejores prácticas; humano adapta al stack real |
| Aprobar y publicar la versión 1.0 de MAGIA | Humano | La rendición de cuentas no se delega |
| Mantener y auditar MAGIA en el tiempo | Humano, con IA como asistente de monitoreo | Requiere criterio continuo, no solo ejecución |

---

## 2. Description — cómo abordarla

### Producto (qué salida)

- **Audiencia:** liderazgo de ingeniería, arquitectos, equipos de desarrollo,
  y —para las secciones de gobernanza— legal/cumplimiento y liderazgo ejecutivo.
- **Formato sugerido:** un documento maestro (visión y pilares) + documentos
  satélite por pilar (arquitectura, gobernanza, estándares, catálogo, ciclo de
  vida), para que cada equipo consulte solo lo que necesita.
- **Prioridades:** que sea *usable* antes que *exhaustivo*. Mejor una v1.0 con
  3 pilares sólidos y adoptados que 5 pilares completos y engavetados.
- **Exclusiones:** MAGIA no es un curso de IA ni un manual de prompting genérico;
  es un marco de decisión y control para tu organización específica.

### Proceso (cómo razonar)

Secuencia recomendada para construir MAGIA con IA como copiloto, pilar por
pilar:

1. Si algo del contexto de tu empresa no está claro, haz una pregunta antes de
   redactar (no asumas madurez, presupuesto ni stack).
2. Investiga cómo resuelven este pilar organizaciones de referencia.
3. Propón 2–3 estructuras alternativas para el pilar, con pros/contras.
4. Redacta un primer borrador solo del pilar acordado, con marcadores
   `[por definir: …]` donde falte información real de la empresa.
5. Antes de dar el borrador por bueno, explicita los supuestos que usaste.

### Desempeño (cómo colaborar)

- Cuestiona si un pilar propuesto realmente aplica a tu tamaño de empresa (no
  todo negocio necesita un comité de gobernanza formal desde el día uno).
- Marca como incierto cualquier benchmark o "así lo hacen las empresas
  avanzadas" que no esté verificado con fuente real.
- No valides automáticamente cada versión; señala si un pilar se ve bien en el
  papel pero es poco realista de adoptar.
- Si detectas que se está construyendo burocracia sin gobierno real detrás,
  dilo explícitamente.

### Prompts listos para usar

**Para arrancar un pilar de MAGIA (Augmentation):**
```
Vamos a construir el pilar "<nombre del pilar>" de MAGIA, nuestro marco de
arquitectura y gobernanza de IA para desarrollo de software.
Contexto de la empresa: <tamaño de equipo, stack, sector, nivel de madurez
actual con IA, restricciones regulatorias>.
Objetivo de este pilar: <qué debe resolver>.
Antes de redactar nada, dame 2-3 estructuras alternativas para este pilar,
con sus pros y contras para nuestro contexto. Pregúntame si algo es ambiguo.
```

**Para pasar de estructura a borrador (Automation controlado):**
```
Usa la estructura <X> que acordamos. Redacta el borrador del pilar
"<nombre>" en Markdown, con secciones claras. Donde no tengas información
real de la empresa, usa el marcador [por definir: ...] en vez de inventar.
No incluyas ejemplos genéricos de "mejores prácticas de la industria" sin
marcarlos como referencia externa a validar.
```

**Para revisar un borrador antes de aprobarlo (Discernment de proceso):**
```
Antes de darlo por bueno, explica: (1) qué supuestos hiciste sobre nuestra
empresa para escribir esto, (2) qué partes son prácticas genéricas de la
industria vs. decisiones específicas nuestras, (3) qué riesgos ves si
publicamos esto tal cual.
```

---

## 3. Discernment — cómo evaluar

### Producto (checklist de 5 criterios)
- [ ] **Exactitud factual** — lo que se cita sobre "cómo lo hacen empresas
  avanzadas" está verificado, no inventado con tono confiado.
- [ ] **Completitud** — el pilar cubre lo que definiste en el objetivo, sin
  huecos que obliguen a improvisar en producción.
- [ ] **Coherencia interna** — los niveles de riesgo, roles y checklists no se
  contradicen entre pilares (p. ej. gobernanza vs. ciclo de vida).
- [ ] **Validez de dominio** — un arquitecto senior o el área legal lo
  encontraría creíble y aplicable, no genérico.
- [ ] **¿Pondrías tu nombre?** — ¿firmarías esto como responsable si algo sale
  mal por seguirlo?

### Proceso
Antes de aprobar un pilar, pide que se expliciten los supuestos usados (tamaño
de empresa, tolerancia a riesgo, stack). Verifica que no haya "saltos" —por
ejemplo, un checklist de diligencia que suena bien pero que nadie en la
organización tiene autoridad real para exigir.

### Desempeño
Revisa cada 2-3 semanas: ¿la IA se está ajustando cuando le corriges el nivel
de formalidad o el tamaño de empresa? ¿te hace las preguntas correctas antes de
redactar, o solo produce texto plausible? ¿el resultado conjunto (MAGIA) es
mejor que lo que el equipo habría escrito solo, o solo es más rápido pero
igual de genérico?

---

## 4. Diligence — uso responsable

- **Creación:** No compartas datos reales de clientes, credenciales,
  contratos o información confidencial de la empresa al pedir ayuda para
  redactar MAGIA — usa descripciones abstractas del contexto. Verifica que la
  herramienta de IA usada esté aprobada por tu organización para este tipo de
  trabajo.
- **Transparencia:** MAGIA es un documento de gobernanza que otros seguirán;
  debe quedar explícito qué partes fueron redactadas con asistencia de IA y
  revisadas por quién. Sugerencia de nota de atribución:
  ```
  Documento preparado con asistencia de IA (borrador inicial y síntesis de
  investigación). Estructura, decisiones de riesgo y aprobación final:
  <responsable/comité>.
  ```
- **Despliegue (compuerta final antes de publicar cada pilar):** verificar que
  los roles y niveles de riesgo sean reales y accionables, que no haya
  afirmaciones de "mejores prácticas" sin respaldo, y que el pilar tenga un
  responsable humano nombrado. Responsable de la compuerta final: comité de
  gobernanza por consenso — José Alonso, Pablo Breganza, Josué Gamarro (ver
  `docs/01-plan-tecnico-fase1.md`, sección de roles técnicos).

---

## 5. Objetivo final: de MAGIA a Skills y Rules de Claude Code

Esto es lo importante: **MAGIA no es el destino, es la fuente de verdad.**
El objetivo final es que su gobernanza se convierta en artefactos ejecutables
de Claude Code que aceleren el día a día del equipo, no solo un documento que
se lee una vez. Claude Code tiene varias capas donde vive esto, y cada pilar de
MAGIA mapea a una capa distinta:

| Capa de Claude Code | Se carga | Viene del pilar de MAGIA | Ejemplo concreto |
|---|---|---|---|
| **`CLAUDE.md`** (raíz del proyecto) | Siempre, en cada sesión | Gobernanza + Diligencia | "Nunca uses un modelo/proveedor no aprobado", "todo caso de uso con PII pasa por la compuerta de diligencia antes de mergear" |
| **`.claude/rules/`** (con alcance por carpeta/ruta) | Solo cuando se toca esa ruta | Estándares de desarrollo | Reglas de testing/seguridad específicas para `/src/payments`, convenciones de prompting para `/src/ai-features` |
| **`.claude/skills/`** (paquetes con `SKILL.md`) | Solo cuando la tarea calza | Arquitectura de referencia + Catálogo de capacidades | Skill "elegir-patron-ia" que aplica tu matriz de decisión (RAG vs. agente vs. prompting simple); skill "generar-componente-ia" que sigue tu patrón aprobado |
| **Hooks (`settings.json`)** | En puntos fijos del ciclo (pre/post tool-use) | Ciclo de vida y diligencia | Hook que bloquea un commit si no pasó el checklist de diligencia; hook que corre linters/tests tras cada edición |

**Regla práctica para decidir dónde va cada regla de MAGIA:**
- ¿Debe cumplirse siempre, sin excepción, en todo el repo? → `CLAUDE.md`.
- ¿Solo aplica a cierta carpeta o tipo de archivo? → `.claude/rules/`.
- ¿Es un procedimiento repetible que alguien invoca cuando lo necesita (elegir
  un patrón, redactar una ficha de caso de uso, correr el checklist de
  compuertas)? → una **Skill**.
- ¿Debe ejecutarse automáticamente sin que nadie lo pida, como control de
  seguridad? → un **hook**.

Para la construcción técnica de cada Skill (estructura de carpeta, `SKILL.md`,
scripts de apoyo, evaluación de qué tan bien "dispara"), cuando lleguemos a esa
fase puedo usar la skill `skill-creator` que ya tienes disponible — está
pensada exactamente para crear y optimizar Skills de Claude Code a partir de
un objetivo como este.

`[nota: la mecánica exacta de rules/hooks puede evolucionar — antes de
implementar en tu repo real, vale la pena confirmar la sintaxis vigente en la
documentación oficial de Claude Code: https://docs.claude.com/en/docs/claude-code/overview]`

---

## 6. Próximos pasos (con el objetivo final en mente)

1. **Esta semana:** responde las preguntas de la sección 1 (datos, regulación,
   tolerancia a riesgo, proveedores aprobados, criterio de éxito). Sin esto,
   cualquier pilar que se redacte será genérico — y cualquier regla de Claude
   Code derivada de él también.
2. **Elige un pilar piloto** (recomendado: *Estándares de desarrollo* o
   *Arquitectura de referencia* — son los que más directamente se traducen en
   Rules y Skills, y dan valor visible pronto).
3. Redacta ese pilar con los prompts de la sección 2, con un arquitecto o
   líder técnico como dueño del contenido.
4. Pasa el borrador por el checklist de Discernment (sección 3).
5. **Traduce el pilar aprobado a artefactos de Claude Code**: identifica qué
   reglas van a `CLAUDE.md`, cuáles a `.claude/rules/` con su alcance, y qué
   procedimientos merecen convertirse en Skills (usa la tabla de la sección 5).
6. Pilotea esos artefactos en un solo repo/equipo antes de escalar; mide
   adopción y tiempo ahorrado.
7. Repite el ciclo con el siguiente pilar. Define quién compone el
   comité/responsable de gobernanza antes de escalar a todos los pilares —
   esto no se delega en la IA.
