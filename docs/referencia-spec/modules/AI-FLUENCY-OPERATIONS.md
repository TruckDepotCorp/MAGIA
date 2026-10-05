# MAGIA — AI Fluency for Small Businesses aplicado

**Módulo de referencia (AF16)** · Extiende `FLOW.md`, `AI-FLUENCY.md` (AF14) y `SPEC.md` · v1.0 · Confidencial — Truck Depot Corporation

> El curso **AI Fluency for Small Businesses** de Anthropic Academy lleva el marco 4D al trabajo diario de equipos con recursos limitados, responsabilidad directa sobre el negocio y contacto con clientes: atención, back-office, abastecimiento y liderazgo. En Truck Depot ese es el día a día de **sucursales, mostrador, SAC, ventas, administración, compras y logística**. Este módulo crea el nivel **MAGIA Diario**: uso cotidiano de IA por cualquier colaborador, sin construir un producto, pero dentro del estándar.

## Mapa

| Concepto del curso | En MAGIA | Artefacto |
|---|---|---|
| Valores, objetivos y restricciones como contexto de partida | Contexto Corporativo y Contexto de Área cargados en todo espacio de trabajo | `templates/diario/contexto-area.md` |
| Capacidades y limitaciones (alucinación, fecha de corte) | Inducción práctica y señales de alerta | SB2 |
| Ciclo Descripción–Discernimiento en investigación | Protocolo de investigación verificada | SB3 |
| Ciclo Delegación–Diligencia con datos de clientes | Matriz de datos de clientes y pasos obligatorios | SB4 |
| Uso transparente de la IA | Reglas de transparencia interna y hacia clientes | SB4.3 |
| Workflow aumentado repetible | Ficha de Workflow de una página + Biblioteca de Workflows | `templates/diario/ficha-workflow.md` |
| Política de uso de IA breve y honesta | Política de Uso de IA Truck Depot (una página) | `templates/diario/politica-uso-ia.md` |
| Humano en el circuito | Lista de decisiones siempre humanas | SB7 |

---

## SB0. Niveles de uso de IA en la corporación

| Nivel | Qué es | Quién | Perfil MAGIA |
|---|---|---|---|
| **Diario** | Un colaborador usa Claude para su trabajo cotidiano (redactar, investigar, resumir, analizar) | Todos | `diario` (este módulo) |
| **Workflow** | Una tarea recurrente se convierte en workflow escrito y compartido | Equipos, sucursales | `diario` → Biblioteca de Workflows |
| **Producto Flow** | El workflow se vuelve producto con conectores, golden set y gate | Áreas administrativas | `flow` |
| **Software** | Producto de software estándar o a gran escala | Ingeniería | `estandar` / `forge` |

**Escalera de graduación:** un workflow que usan más de 10 personas, que toca sistemas o que se ejecuta más de una vez por semana DEBE evaluarse para convertirse en receta Flow (FLOW L3). `magia scout` detecta candidatos en la Biblioteca.

---

## SB1. Contexto de partida: valores, objetivos y restricciones

Toda interacción empieza desde el contexto correcto, no desde cero.

| Capa | Contenido | Dónde vive |
|---|---|---|
| **Contexto Corporativo** | Quiénes somos (repuestos para camiones y buses), clientes, valores, voz de marca, Constitución resumida, lo que nunca se hace | Instrucciones globales de todos los espacios de trabajo Claude de la corporación |
| **Contexto de Área** | Objetivos del área, procesos clave, términos propios, sistemas, restricciones, a quién escalar | Proyecto Claude del área (`templates/diario/contexto-area.md`) |
| **Contexto Personal** (opcional) | Rol, tareas frecuentes, preferencias de formato | Preferencias del usuario |

- El Contexto Corporativo lo mantiene el Arquitecto de IA; el de Área, el AI Champion.
- Revisión trimestral; versión y fecha visibles.

---

## SB2. Expectativas realistas para todos

Inducción obligatoria de 30 minutos (antes de habilitar el acceso), basada en AF2:
- La IA genera texto que **suena** correcto; eso no lo hace correcto.
- Su conocimiento tiene fecha de corte: precios, stock, normativa o noticias recientes se verifican en la fuente.
- Puede inventar con seguridad: números de parte, cifras, nombres, citas.
- Más contexto y ejemplos dan mejores respuestas.

**Señales de alerta** (tarjeta de bolsillo):
| Señal | Acción |
|---|---|
| Cifras, códigos o fechas que no aportaste | Verifica en el sistema o la fuente |
| Citas o enlaces que no abres | No los uses hasta abrirlos |
| Respuesta muy segura sobre algo reciente | Verifica con fuente actual |
| Te da la razón en todo | Pídele que critique tu planteamiento |

---

## SB3. Ciclo Descripción–Discernimiento: investigación verificada

Para investigación de mercado, proveedores, competidores, precios de referencia o normativa.

```
1. Pregunta clara: qué decisión apoya y qué nivel de certeza necesita
2. Descripción con contexto: Contexto de Área + objetivo + formato + fuentes preferidas
3. Resultado con fuentes citadas
4. Discernimiento: ¿las fuentes existen y dicen eso? ¿falta algo? ¿hay sesgo?
5. Refinar: pedir lo que faltó, contrastar, pedir la opinión contraria
6. Decisión humana, con la fuente principal anotada
```

Reglas:
- Una decisión de negocio (precio, proveedor, inversión) requiere **al menos dos fuentes verificadas** por la persona.
- La investigación nunca incluye datos de clientes ni información confidencial de la corporación en herramientas no aprobadas.

---

## SB4. Ciclo Delegación–Diligencia con datos de clientes

### SB4.1 Matriz de datos de clientes

| Tarea | ¿Se delega a la IA? | Condición |
|---|---|---|
| Segmentar una lista de clientes | Sí | Datos minimizados y sin identificadores directos cuando no son necesarios; espacio de trabajo aprobado |
| Redactar seguimientos, cotizaciones o recordatorios | Sí, como borrador | La persona revisa y envía |
| Resumir historial de un cliente para atenderlo mejor | Sí | Solo en espacio de trabajo aprobado con conector oficial |
| Enviar comunicaciones al cliente | No de forma autónoma | La persona envía, o checkpoint humano (NM-3) |
| Decidir crédito, cobranza, descuentos o reclamos | No | Decide la persona; la IA puede preparar el análisis |
| Usar datos restringidos (identificación, financieros sensibles) | No | Prohibido salvo producto aprobado por el Comité (R2) |
| Pegar datos de clientes en herramientas no aprobadas | Nunca | Violación de R2/R3 |

### SB4.2 Pasos obligatorios
1. **Minimizar:** solo los datos necesarios para la tarea.
2. **Anonimizar** cuando sea posible (reemplazar nombre por ID).
3. **Delegar** en el espacio de trabajo aprobado.
4. **Revisar** el resultado antes de usarlo (discernimiento).
5. **Actuar** la persona: enviar, registrar, decidir.
6. **Transparencia** según SB4.3.

### SB4.3 Uso transparente
- **Hacia el cliente:** si un mensaje fue generado o asistido de forma sustancial por IA en un canal automatizado, se identifica (R7). En comunicaciones redactadas con ayuda y enviadas por la persona, rige la política de cada canal definida en la Política de Uso.
- **Interno:** informes, análisis y propuestas relevantes indican el papel de la IA (Declaración de Diligencia breve, AF14).

---

## SB5. Workflow aumentado repetible

Una tarea que se repite (correo semanal a clientes, reporte mensual de ventas de sucursal, publicación de vacantes, cotización estándar, resumen de reclamos) se convierte en un **workflow escrito de una página** con pasos explícitos de Descripción y Diligencia.

**Ficha de Workflow** (`templates/diario/ficha-workflow.md`): tarea, frecuencia, responsable, entradas, prompt guardado (Plantilla 3P), pasos, checklist de revisión, quién aprueba, tiempo antes/después.

**Biblioteca de Workflows MAGIA**
- Cada área publica sus fichas en su espacio de trabajo y en el Registro MAGIA (sección "workflows").
- Las fichas con mejores resultados se convierten en Skills del espacio de trabajo del área.
- Métrica: horas ahorradas por ficha (autodeclaradas al inicio, medidas al graduar a Flow).

---

## SB6. Política de Uso de IA Truck Depot

Una página, en lenguaje simple, derivada de la Constitución y de las Rules R1–R9. Todo colaborador la lee y la acepta antes de recibir acceso. Plantilla: `templates/diario/politica-uso-ia.md`.

Contenido mínimo:
- Para qué sí usamos IA y para qué no.
- Herramientas aprobadas (y que las demás no se usan con información de la empresa).
- Datos que nunca se ingresan.
- Siempre verificamos antes de usar o enviar.
- Somos transparentes sobre su uso.
- La persona es responsable del resultado.
- A quién preguntar y cómo reportar un problema.

Cada área PUEDE agregar un anexo de media página con casos propios; nunca puede relajar la política corporativa.

---

## SB7. Humano en el circuito — siempre humano

| Decisión | Por qué |
|---|---|
| Precios especiales, descuentos y condiciones comerciales | Impacto económico y relación con el cliente |
| Aprobación o rechazo de crédito y acciones de cobranza | Impacto sobre personas; regulación |
| Contratación, evaluación o desvinculación de personas | Impacto sobre personas; sesgo |
| Respuesta final a reclamos y garantías | Relación con el cliente |
| Confirmación de compatibilidad crítica de un repuesto ante duda | Seguridad del vehículo |
| Pagos, transferencias y registros contables | Irreversibilidad |
| Comunicaciones públicas en nombre de la empresa | Reputación |

La IA puede preparar, analizar y redactar para todas ellas; la decisión y la acción son humanas.

---

## SB8. Roles y formación

| Rol en Truck Depot | Equivalente en el curso | Ruta |
|---|---|---|
| Mostrador, ventas de sucursal, SAC | Interacción con clientes | AI Fluency for Small Businesses → Claude 101 |
| Administración, contabilidad, RRHH | Back-office | AI Fluency for Small Businesses → AI Fluency: Framework & Foundations |
| Compras, logística, operaciones | Cadena de abastecimiento | AI Fluency for Small Businesses → Claude 101 → Cowork |
| Jefes de sucursal, gerentes de área | Liderazgo | AI Fluency for Small Businesses → AI Fluency: Framework & Foundations → AI Capabilities and Limitations |

**Campeones de sucursal:** en cada sucursal, una persona formada que mantiene las fichas de workflow locales, ayuda al resto y reporta al AI Champion del área.

Integración con AF4: estas rutas se agregan a la tabla de formación por rol; el curso es requisito para recibir acceso a los espacios de trabajo Claude de la corporación.

---

## Métricas

| Métrica | Qué mide |
|---|---|
| % de colaboradores con política aceptada e inducción completa | Base de adopción segura |
| Fichas de workflow publicadas y en uso por área | Adopción práctica |
| Horas ahorradas autodeclaradas y medidas | Valor |
| Workflows graduados a Flow | Escalamiento |
| Incidentes de datos de clientes | Seguridad (objetivo: cero) |

## Hitos

| Hito | Entregable | Criterio de aceptación |
|---|---|---|
| SBM1 | Contexto Corporativo + Contextos de Área + Política de Uso de IA | Publicados en todos los espacios de trabajo; aceptación registrada |
| SBM2 | Inducción de 30 minutos + tarjeta de señales de alerta | 100% de usuarios con inducción antes del acceso |
| SBM3 | Matriz de datos de clientes y protocolo de investigación | Incluidos en el espacio de trabajo de SAC, ventas y marketing |
| SBM4 | Ficha de Workflow + Biblioteca en el Registro | ≥ 3 fichas por área piloto en 30 días |
| SBM5 | Detección de candidatos a Flow (`magia scout`) | Al menos 1 workflow graduado a receta Flow por trimestre |
