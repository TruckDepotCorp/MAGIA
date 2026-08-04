# CLAUDE.md — Base MAGIA v0.2.0

> Copiar este archivo a la raíz de cada repo de producto que adopte MAGIA.
> Editar solo la sección "Específico de este repo" — el resto son reglas
> globales de gobernanza que no deben modificarse sin pasar por el comité
> (ver `magia-framework/docs/03-gobernanza-repositorio.md`).
>
> Si el repo ya tiene un `CLAUDE.md` con documentación técnica propia (ej.
> arquitectura, convenciones de código): **fusionar, no reemplazar** —
> agregar esta sección de gobernanza junto al contenido técnico existente
> (ver el `CLAUDE.md` de HIPERSAP, primer repo piloto real, como ejemplo
> de cómo se hizo — `docs/04-diagnostico-inventario-ia.md` en este repo).
>
> Fuente: `magia-framework` versión `0.2.0`
> (https://github.com/TruckDepotCorp/MAGIA). No editar reglas globales
> localmente — proponer el cambio como PR en el repo fuente.

## Reglas globales de gobernanza (no negociables)

- Nunca usar un modelo o proveedor de IA que no esté en la lista de
  aprobados. **Proveedores/modelos aprobados (actualizado 2026-08-04):**
  Anthropic (Claude Code y vía Cursor), xAI (Grok), OpenAI (GPT), y el
  modelo propio de Cursor ("Composer") — los cuatro aprobados dado el
  historial real de uso: Cursor es la herramienta formal de IA de la
  empresa desde hace ~1 año, previa a adoptar Claude Code (ver
  `magia-framework/docs/04-diagnostico-inventario-ia.md`). Si un caso de
  uso necesita un proveedor fuera de esta lista, escalar al comité de
  gobernanza antes de usarlo.
- Esta regla aplica al **modelo invocado por debajo**, no solo al nombre de
  la herramienta: herramientas multi-modelo (ej. Cursor) deben
  restringirse a modelos de la lista de aprobados — usar la herramienta no
  exime de la regla.
- **Que un proveedor esté aprobado no clasifica el nivel de riesgo de un
  caso de uso.** Un caso de uso que toca PII en un sistema core sigue
  necesitando su propia clasificación de riesgo (bajo/medio/alto) y, si es
  medio/alto, la ficha de diligencia — independientemente de si el
  proveedor usado ya está aprobado.
- Nunca incluir secretos, credenciales, tokens ni datos de clientes reales
  en prompts, fixtures de prueba, o archivos de configuración versionados.
- Todo caso de uso clasificado como **riesgo medio o alto** — clasificar
  con la rúbrica de `magia-framework/docs/05-matriz-riesgo.md` — debe
  completar la ficha de diligencia (`templates/ficha-caso-de-uso.md`, o la
  skill `ficha-caso-de-uso` si ya está copiada a `.claude/skills/`) y
  obtener aprobación del comité antes de implementarse.
- Todo cambio en prompts o configuración de modelo que afecte producción
  debe pasar por el pipeline de evals antes de mergear (ver
  `magia-framework/templates/ci-pipeline-referencia.yml` y
  `magia-framework/docs/08-estandares-desarrollo.md`).
- Ningún componente de IA se despliega a producción sin pasar la compuerta
  de despliegue — usar `skills/checklist-pre-deploy` si está disponible en
  el repo, o el checklist de Diligencia de
  `magia-framework/docs/00-plan-metodologico-4D.md` §4.

## Cuándo escalar a un humano

- Si una tarea toca datos personales (PII) y no hay una Rule específica que
  la cubra.
- Si una acción es irreversible (borrado permanente, envío de comunicación
  a clientes, cambios de facturación).
- Si el nivel de riesgo del caso de uso no está claro.

## Específico de este repo

`[por definir: contexto del repo — stack, dominio, contactos del equipo]`

- Stack: `[por definir]`
- Dominio / dueño del producto: `[por definir]`
- Nivel de riesgo general del repo: `[por definir: bajo / medio / alto]`
- Rules activas en este repo: ver `.claude/rules/`
- Skills activas en este repo: ver `.claude/skills/`

---
**Owner de este archivo:** definido por repo, ver "Específico de este
repo" arriba · **Versión de MAGIA:** `0.2.0`
