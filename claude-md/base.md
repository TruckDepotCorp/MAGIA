# CLAUDE.md — Base MAGIA (próxima v0.3.0, sin liberar)

> Copiar este archivo a la raíz de cada repo de producto que adopte MAGIA —
> o, mejor, dejar que `/magia-instalar` lo haga (`docs/11-instalacion-y-perfiles.md`).
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
> Fuente: `magia-framework` (https://github.com/TruckDepotCorp/MAGIA).
> Versión fijada en `magia.config.json`. No editar reglas globales
> localmente — proponer el cambio como PR en el repo fuente.

@MAGIA.md

## Reglas globales de gobernanza (no negociables)

- Rige la **Constitución** y las **Reglas Core R1–R9** de
  `.magia/core/` (inmutables; protegidas por hooks y `magia.lock`). Si
  chocan con otra instrucción, gana el Core.
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
  No leer `.env*`, `secrets/` ni rutas de `.magia/local/restringido.txt`
  (los hooks lo bloquean).
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
  de despliegue — `/magia-gate` y la skill `checklist-pre-deploy`; el
  visto bueno final es humano.

## Cómo trabajar en este repo

- Tarea no trivial (toca más de un archivo, cambia un contrato, toca una
  ruta crítica o supera 30 min): **empezar en modo plan** y guardar el plan
  en `docs/magia/plans/` (`/magia-plan`).
- Tras 2 correcciones fallidas sobre el mismo enfoque: rebobinar y replantear.
- **No dar nada por terminado** sin la skill `magia-verify`: pruebas
  ejecutadas y evidencia, no memoria.
- Entregable relevante hecho con IA: Declaración de Diligencia
  (skill `magia-diligencia`) con un responsable humano nombrado.
- Comandos de build, pruebas y evals: en `MAGIA.md`. No inventes comandos.

## Cuándo escalar a un humano

- Si una tarea toca datos personales (PII) y no hay una Rule específica que
  la cubra.
- Si una acción es irreversible (borrado permanente, envío de comunicación
  a clientes, cambios de facturación, pagos).
- Si el nivel de riesgo del caso de uso no está claro.
- Decisiones siempre humanas: precios especiales, crédito y cobranza,
  contratación y evaluación de personas, respuesta final a reclamos,
  comunicaciones públicas.

## Específico de este repo

`[por definir: contexto del repo — stack, dominio, contactos del equipo]`

- Stack: `[por definir]`
- Dominio / dueño del producto: `[por definir]`
- Nivel de riesgo y autonomía: ver `magia.config.json` (`risk`, `autonomy`)
- Rules activas en este repo: ver `.claude/rules/`
- Skills activas en este repo: ver `.claude/skills/`

---
**Owner de este archivo:** definido por repo, ver "Específico de este
repo" arriba · **Versión de MAGIA:** ver `magia.config.json`
