# Arquitectura de referencia (Sprint 2)

Entregable del Sprint 2 (`docs/01-plan-tecnico-fase1.md`): el estándar de
MAGIA para cómo se integra la IA **dentro del software que construye la
empresa** (features de producto) — distinto del uso de herramientas de IA
para programar, ya cubierto en el Sprint 1
(`docs/04-diagnostico-inventario-ia.md`).

Este documento es el **estándar en sí**, no un análisis de un proyecto
puntual. WMS e HIPERSAP se usan como contexto real conocido (stack, riesgo,
integración con SAP B1), no como requisito para poder avanzar — el estándar
debe servir para cualquier proyecto que adopte MAGIA, exista o no todavía
un caso de uso de producto concreto.

> Nota de método (4D): las definiciones de patrones son terminología
> estándar de la industria. La priorización y las convenciones de este
> documento sí son una decisión de arquitectura de MAGIA — quedan sujetas a
> ajuste cuando aparezca el primer caso de uso de producto real, pero no se
> bloquea el estándar a la espera de eso.

## 1. Catálogo de patrones candidatos

| Patrón | Qué es | Cuándo tiene sentido | Cuándo NO |
|---|---|---|---|
| **Prompting directo vía API** | Llamada directa a un modelo con un prompt, sin retrieval ni herramientas externas | Clasificación, extracción o generación simple, con todo el contexto necesario cabiendo en el prompt | Cuando la respuesta depende de datos propios extensos que no caben en el contexto |
| **RAG (Retrieval-Augmented Generation)** | El modelo recupera contexto relevante de una base de conocimiento/vector store antes de responder | Preguntas sobre documentación o datos propios extensos y cambiantes (ej. manuales operativos, políticas internas) | Cuando el caso de uso no depende de conocimiento propio |
| **Agente con herramientas (tool use / MCP)** | El modelo decide qué acciones tomar, invocando herramientas/APIs propias en varios pasos | Tareas que requieren acción sobre sistemas propios (ej. consultar SAP B1), con supervisión humana en los pasos de riesgo | Decisiones irreversibles o sobre datos de cliente sin revisión humana |
| **Copiloto embebido en producto** | La IA vive dentro de la UI de un producto propio, asistiendo a un usuario humano que mantiene el control final | Asistir a un usuario final sin automatizar la decisión completa | Cuando se busca automatización de punta a punta sin intervención humana |
| **Orquestador multi-paso** | Un flujo determinista (no un agente autónomo) que encadena llamadas a modelos/herramientas en un pipeline fijo | Procesos repetibles con pasos conocidos de antemano (ej. extraer datos de un documento → validar → cargar a SAP) | Cuando el flujo no se puede predefinir y requiere que el modelo decida el camino |

## 2. Patrones priorizados por MAGIA

Dado el contexto real conocido (equipo reducido, stack .NET/C#, Azure, ya
usando **copiloto embebido** en la práctica vía Cursor/Claude Code como
herramienta de desarrollo, y un sistema — HIPERSAP — cuya razón de ser es
integrar con un sistema propio, SAP B1), MAGIA prioriza estos 3 patrones
como los que el catálogo de capacidades (Sprint 3) debe cubrir primero:

1. **Copiloto embebido** — patrón de menor riesgo y mayor madurez de
   adopción hoy; ya validado en la práctica (aunque como herramienta de
   desarrollo, no aún como feature de producto).
2. **Agente con herramientas / MCP** — encaja naturalmente con conectar
   productos propios a sistemas internos (ej. SAP B1) sin exponer acceso
   irrestricto; requiere el estándar de conectores de la sección 3.
3. **RAG** — para cualquier caso donde el conocimiento propio (manuales,
   políticas, documentación operativa) no quepa en un prompt directo.

**Prompting directo** queda disponible en el catálogo pero no prioritario
por separado (suele ser un caso particular de los tres anteriores).
**Orquestador multi-paso** se revisita si aparece un proceso repetible de
varios pasos bien definido (ej. un pipeline documento → validación → SAP).

Esta priorización es una decisión de arquitectura de MAGIA, sujeta a
ajuste — no un hecho ya validado con un spike real (ver sección 5,
pendiente).

## 3. Estándar de MCP / conectores internos

Cualquier sistema propio (ERP/SAP B1, WMS, una base de conocimiento
interna) que se exponga como servidor MCP para que un agente lo use debe
cumplir, antes de habilitarse:

1. **Owner nombrado** — mismo modelo que Skills/Rules (ver
   `docs/03-gobernanza-repositorio.md`).
2. **Nivel de permiso explícito** — solo lectura, o lectura+escritura. Por
   defecto, solo lectura salvo justificación explícita.
3. **Confirmación humana en toda operación de escritura irreversible** —
   alineado con "cuándo escalar a un humano" de `claude-md/base.md`.
4. **Clasificación de riesgo previa** (`docs/05-matriz-riesgo.md`) — si
   toca PII o tiene exposición externa, requiere la ficha de diligencia
   (Sprint 3) antes de habilitarse, no después.

Ningún conector MCP pasa a producción sin que las 4 condiciones estén
documentadas en el repo que lo implementa.

## 4. Convenciones técnicas

### Versionado de prompts
- Los prompts viven **versionados como código**, en el propio repo del
  feature que los usa (ej. `<repo>/ai/prompts/`) — no en configuración
  externa sin versionar.
- Todo cambio de prompt sigue el mismo flujo de PR que el código: revisión
  + historial en el propio control de versiones (no un changelog aparte).
- Coherente con la Rule ya existente (`rules/example-ai-features.md`):
  todo prompt nuevo o modificado necesita su golden dataset de evals
  asociado antes de mergear.

### Logging / observabilidad
- Registrar, por cada llamada a un modelo: patrón de arquitectura usado
  (tabla de la sección 1), proveedor/modelo, timestamp, resultado
  (éxito/error), latencia.
- **Nunca registrar el contenido crudo** del prompt/respuesta cuando el
  caso de uso esté clasificado Medio/Alto o toque PII
  (`docs/05-matriz-riesgo.md`) — registrar solo metadata, no el dato en sí.
- Esto formaliza y amplía la Rule ya existente
  (`rules/example-ai-features.md`, punto 4).

## 5. Spikes técnicos (tarea 3 del Sprint 2)

**Pendiente, y así se deja explícito:** un spike con métricas reales de
latencia/costo/complejidad no se puede simular — necesita un caso de uso
de producto concreto implementado en un repo de pruebas. En cuanto exista
un candidato real (WMS, HIPERSAP, o cualquier otro), se ejecuta el spike
del patrón correspondiente de la sección 2 y se documentan los resultados
aquí. Esto no bloquea el resto del estándar de este documento.

## 6. Diagramas de referencia

**Copiloto embebido**
```
Usuario humano → UI del producto → [Copiloto IA] → sugerencia/acción
                                         ↓
                              Usuario aprueba o descarta
                              (el usuario mantiene el control final)
```

**Agente con herramientas / MCP**
```
Usuario/trigger → [Agente IA] → decide qué herramienta invocar
                        ↓
              Servidor MCP (ej. SAP B1, solo lectura por defecto)
                        ↓
        Si la acción es de escritura irreversible → confirmación humana
                        ↓
                  Resultado devuelto al agente → respuesta final
```

**RAG**
```
Consulta del usuario → [Retrieval] → base de conocimiento / vector store
                              ↓
                  Contexto recuperado + consulta → [Modelo]
                              ↓
                         Respuesta con contexto propio
```

## Pendiente

- Ejecutar el spike técnico (sección 5) en cuanto exista un caso de uso de
  producto real — ningún proyecto lo tiene todavía.
- Revisar la priorización de la sección 2 cuando aparezca ese caso real.
