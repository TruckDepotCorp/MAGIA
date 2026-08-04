# Plan de trabajo técnico — Fase 1 de MAGIA
### Semanas 1–8: construcción del marco + transformación IA en desarrollo

Este plan baja la Fase 1 (ver `plan-4d-magia.md` y la presentación gerencial) a
tareas técnicas ejecutables, en 4 sprints de 2 semanas. Cada sprint tiene:
objetivo, tareas técnicas, entregable verificable y criterio de aceptación.
Donde la tarea depende de datos específicos de tu organización que aún no
tengo, lo marco como `[por definir: …]` en vez de asumir.

**Supuesto de trabajo:** equipo con repos en Git, algún pipeline de CI/CD
existente y al menos un caso de uso de IA ya corriendo (aunque sea informal).
Ajusta el ritmo si tu punto de partida es distinto.

---

## Roles técnicos involucrados

| Rol | Responsabilidad en la Fase 1 |
|---|---|
| **Arquitecto/a de IA (lead técnico de MAGIA)** | Dueño de la arquitectura de referencia y del catálogo de capacidades; aprueba patrones |
| **Ingeniero/a de plataforma / DevOps** | CI/CD, hooks, estructura de repos, configuración de Claude Code |
| **Seguridad / Cumplimiento** | Valida niveles de riesgo, manejo de datos, aprobación de proveedores de IA |
| **Product owner / líder de equipo piloto** | Prioriza el caso de uso piloto, valida valor de negocio |
| **Equipo de desarrollo piloto** | Usa y retroalimenta las primeras Skills/Rules en su repo real |
| **Comité de gobernanza** (puede ser 2-3 de los roles anteriores) | Aprueba `CLAUDE.md`, matriz de riesgo y cada versión de MAGIA |

`[por definir: nombres/personas reales para cada rol — sin esto, el sprint 1 no puede cerrarse formalmente]`

---

## Sprint 1 — Semanas 1–2: Diagnóstico y Gobernanza

**Objetivo:** saber exactamente dónde está parada la empresa hoy y fijar las
reglas base antes de construir nada.

### Tareas técnicas
1. **Auditoría técnica de uso actual de IA**
   - Inventariar repos, servicios o features que ya invocan algún modelo/API de IA (aunque sea experimental).
   - Registrar por cada uno: proveedor, modelo, tipo de dato que procesa, si hay PII, dónde vive el prompt/config.
2. **Levantamiento de stack**
   - Lenguajes, frameworks, gestor de monorepo/repos, pipeline CI/CD actual, proveedores cloud aprobados.
3. **Matriz de niveles de riesgo (técnica, no solo conceptual)**
   - Criterios concretos: ¿toca PII?, ¿decide algo sobre un cliente sin revisión humana?, ¿es interno o expuesto a usuarios externos?, ¿es reversible un error?
   - 3 niveles (bajo/medio/alto) con ejemplos reales de la auditoría del punto 1.
4. **Estructura de repos para MAGIA**
   - Crear el repo (o carpeta central) `magia/` que versiona el marco: `magia/CLAUDE.md-base`, `magia/rules/`, `magia/skills/`, `magia/docs/`.
   - Definir cómo se distribuye a los repos de proyecto (submódulo, copia versionada, o paquete interno).
5. **Borrador de `CLAUDE.md` base (v0.1)**
   - Reglas globales no negociables: proveedores/modelos aprobados, prohibición de secretos en prompts/commits, cuándo es obligatorio pasar por la compuerta de diligencia.
6. **Constitución del comité de gobernanza**
   - RACI técnico: quién aprueba cambios a `CLAUDE.md`, quién aprueba un nuevo caso de uso, quién audita.

### Entregable verificable
- `magia/CLAUDE.md` v0.1 (borrador aprobado por el comité).
- Documento de diagnóstico con inventario real de casos de uso + matriz de riesgo.
- Estructura de carpetas del repo `magia/` creada y accesible al equipo.

### Criterio de aceptación
- [ ] El inventario cubre el 100% de los repos activos conocidos, no solo una muestra.
- [ ] Cada nivel de riesgo tiene al menos un ejemplo real de la propia empresa (no genérico).
- [ ] El comité de gobernanza tiene nombres, no solo roles.

---

## Sprint 2 — Semanas 3–4: Arquitectura de referencia

**Objetivo:** decidir, con evidencia técnica, cómo se integra la IA en el
software — no en abstracto, sino con un spike corriendo.

### Tareas técnicas
1. **Catálogo de patrones de integración**
   - Documentar 4-5 patrones candidatos: prompting directo vía API, RAG (retrieval + vector store), agente con herramientas (tool use / MCP), copiloto embebido en producto, orquestador multi-paso.
2. **Selección de 2-3 patrones prioritarios**
   - Cruzar contra los casos de uso reales del inventario del Sprint 1 (no elegir patrones "de moda" sin caso real detrás).
3. **Spike técnico por patrón elegido**
   - Implementar un mini-ejemplo funcional (no producción) de cada patrón, en un repo de pruebas.
   - Medir: latencia, costo aproximado por request, complejidad de mantenimiento, puntos de fallo.
4. **Definir estándar de MCP / conectores internos** (si aplica al stack)
   - Qué sistemas propios se expondrán como servidores MCP (ej. CRM interno, base de conocimiento, tracker de tickets) y con qué permisos.
5. **Convenciones técnicas**
   - Versionado de prompts (dónde viven, cómo se versionan — ¿como código, con su propio changelog?).
   - Formato estándar de logging/observabilidad para llamadas a modelos (qué se registra, qué se enmascara por PII).
6. **Diagrama de arquitectura de referencia**
   - Un diagrama por patrón elegido: componentes, flujo de datos, dónde se aplican las compuertas de diligencia.

### Entregable verificable
- `magia/docs/arquitectura-referencia.md` con los patrones elegidos, diagramas y resultados de los spikes (latencia/costo/complejidad).
- Repos de spike funcionando (aunque sea localmente o en ambiente de pruebas).

### Criterio de aceptación
- [ ] Cada patrón elegido tiene un spike ejecutado, no solo documentado en teoría.
- [ ] Existen métricas reales (aunque aproximadas) de costo y latencia por patrón.
- [ ] El estándar de logging/observabilidad contempla el enmascarado de PII.

---

## Sprint 3 — Semanas 5–6: Estándares de desarrollo y catálogo de capacidades

**Objetivo:** que cualquier equipo pueda construir con IA siguiendo el mismo
estándar de calidad, sin reinventar el proceso cada vez.

### Tareas técnicas
1. **Guía de prompting / context engineering interna**
   - Plantillas de Producto/Proceso/Desempeño (ver toolkit del 4D) adaptadas a casos técnicos: generación de código, revisión de PRs, generación de tests.
2. **Estándar de testing para features con IA**
   - Definir qué se prueba: exactitud del output, regresión de prompts (golden dataset de casos), comportamiento ante entradas adversarias/inyección.
   - Elegir o construir un framework de *evals* (aunque sea ligero) integrable al CI.
3. **Pipeline CI/CD para componentes de IA**
   - Paso de lint de prompts (formato, longitud, variables esperadas).
   - Paso de evals automáticos contra el golden dataset antes de mergear cambios en prompts/config de modelo.
   - Gate de seguridad: bloquear merge si se detectan credenciales o PII en prompts/fixtures.
4. **Matriz de decisión "tarea → modelo/herramienta" (catálogo de capacidades)**
   - Tabla accionable: tipo de tarea (clasificación simple, generación de código, análisis largo, agente autónomo) → modelo/herramienta recomendada → nivel de riesgo asociado → costo relativo.
5. **Plantillas técnicas**
   - Ficha de caso de uso (para levantar uno nuevo y pasarlo por diligencia).
   - Plantilla de PR para cambios que involucran IA (checklist embebido: evals corridos, riesgo evaluado, revisor de dominio asignado).

### Entregable verificable
- `magia/docs/estandares-desarrollo.md` + `magia/docs/catalogo-capacidades.md`.
- Pipeline CI de referencia (config real, ej. GitHub Actions/GitLab CI) con los pasos de lint/evals/gate de seguridad funcionando en al menos un repo de prueba.
- Plantillas de ficha de caso de uso y de PR listas para usar.

### Criterio de aceptación
- [ ] El pipeline CI corre de punta a punta contra un ejemplo real (no solo pseudocódigo).
- [ ] La matriz de decisión cubre al menos los casos de uso reales detectados en el Sprint 1.
- [ ] Existe al menos un golden dataset real (aunque pequeño) usado en los evals.

---

## Sprint 4 — Semanas 7–8: Ciclo de vida + Skills y Rules piloto en Claude Code

**Objetivo:** que todo lo anterior deje de ser documento y se convierta en
configuración viva dentro de un repo real, con un equipo usándola.

### Tareas técnicas
1. **`CLAUDE.md` final (no v0.1)**
   - Consolidar reglas de gobernanza + diligencia validadas en los sprints anteriores.
   - Mantenerlo corto: solo lo que debe cumplirse siempre en todo el repo (ver regla práctica de la sección 5 del plan 4D).
2. **`.claude/rules/` con alcance por carpeta**
   - Implementar reglas path-scoped para 2-3 áreas críticas identificadas en el Sprint 1 (ej. carpeta de pagos, carpeta de features con IA, carpeta de infraestructura).
3. **Primeras Skills reales (usar la skill `skill-creator`)**
   - Mínimo viable: 2-3 Skills que codifiquen procedimientos del propio MAGIA, por ejemplo:
     - `elegir-patron-ia`: aplica la matriz de decisión del Sprint 3.
     - `ficha-caso-de-uso`: genera y valida la ficha de diligencia antes de empezar a construir.
     - `checklist-pre-deploy`: corre las 3 compuertas (creación/transparencia/despliegue) antes de un release.
4. **Hooks básicos (`settings.json`)**
   - `PreToolUse`: bloquear ediciones a archivos sensibles (credenciales, `.env`, config de proveedores) sin pasar por la Skill de diligencia.
   - `PostToolUse`: correr linters/evals automáticamente tras cada edición relevante.
5. **Selección y preparación del repo piloto**
   - Elegir 1 repo real (no un repo de pruebas) con un equipo dispuesto a operar bajo el nuevo estándar.
   - Instalar toda la configuración: `CLAUDE.md`, `.claude/rules/`, `.claude/skills/`, hooks.
6. **Onboarding del equipo piloto**
   - Sesión práctica: qué cambia en su flujo diario, cómo invocar las Skills, qué hacer si un hook bloquea algo.
7. **Primer ciclo de uso real y recolección de feedback**
   - Al menos 3-5 días de uso real antes del cierre del sprint, con registro de fricciones.

### Entregable verificable
- Repo piloto con `CLAUDE.md`, `.claude/rules/`, `.claude/skills/` y hooks funcionando en producción de código real (no demo).
- Reporte corto de la primera semana de uso: qué funcionó, qué se bloqueó, qué hay que ajustar antes de la Fase 2.

### Criterio de aceptación
- [ ] Las Skills se activan correctamente cuando el equipo las necesita (no requieren invocación manual forzada).
- [ ] Al menos un hook de seguridad bloqueó correctamente un caso real (o se probó deliberadamente que lo haría).
- [ ] El equipo piloto puede describir en sus propias palabras qué reemplazó MAGIA en su flujo anterior.

---

## Vista resumida (Gantt simplificado)

| Semana | Sprint | Foco principal |
|---|---|---|
| 1–2 | Sprint 1 | Diagnóstico técnico + gobernanza + `CLAUDE.md` v0.1 |
| 3–4 | Sprint 2 | Arquitectura de referencia + spikes técnicos |
| 5–6 | Sprint 3 | Estándares, CI/CD para IA, catálogo de capacidades |
| 7–8 | Sprint 4 | `CLAUDE.md` final, Rules, Skills y piloto real en Claude Code |

**Dependencias críticas entre sprints:**
- El Sprint 2 depende del inventario real del Sprint 1 (no se eligen patrones sin casos de uso reales detrás).
- El Sprint 3 depende de los patrones ya validados en el Sprint 2 (el catálogo de capacidades no se redacta antes de tener spikes).
- El Sprint 4 depende de que `CLAUDE.md` v0.1, la matriz de riesgo y los estándares ya estén aprobados — es la fase de "poner en producción", no de definir de nuevo.

---

## Riesgos técnicos a vigilar durante la Fase 1

- **Elegir el repo piloto equivocado** (muy crítico o muy trivial) — sesga la validación de la Fase 2.
- **Saltarse los spikes del Sprint 2** por presión de tiempo — produce una arquitectura de referencia teórica que falla al implementarse.
- **Golden dataset de evals demasiado pequeño o irreal** — da falsa confianza en el pipeline de CI.
- **Hooks demasiado agresivos** desde el día uno — pueden frenar al equipo piloto y generar rechazo al marco completo; conviene empezar en modo "advertencia" antes de "bloqueo duro".
