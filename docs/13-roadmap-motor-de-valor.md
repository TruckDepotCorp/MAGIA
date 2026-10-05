# Roadmap: lo que el handoff define y el kit aún no instala

El handoff (`referencia-spec/SPEC.md`) tiene dos motores. El **Motor de
Gobierno** (Constitución, R1–R9, Skills, hooks, gate) ya está en el kit
(`docs/11`). El **Motor de Valor** y los perfiles `flow`/`forge` quedan aquí
como roadmap, **sin contenido operativo** y sin adelantar sprints: el
`CLAUDE.md` del repo prohíbe front-run de la Fase 2 mientras el piloto del
Sprint 4 no cierre su primer ciclo.

| Capacidad | Origen | Qué falta | Prerrequisito para abrirlo |
|---|---|---|---|
| Pipeline autónomo `/magia-ship` (architect → builder → workers → fixer → PR con Paquete de Evidencia) | SPEC §27, hitos M7 | Agentes `architect`, `builder`, `worker` (`documenter` ya existe); `features.json`/`progress.md` por run | Primer ciclo real del piloto con `magia-verify` y gate; datos de fricción |
| Registro MAGIA (capacidades reutilizables) y `learn` | SPEC §28, M8 | Repo `magia-registry` `[por definir: D9]`; criterio de promoción | ≥ 2 repos instalados |
| `scout` / `improve` / `optimize` / enrutamiento de modelos | SPEC §29–31, M9 | Telemetría, golden sets reales | Producto con `aiInProduct` en producción |
| Runtime SDK (`dataShield`, `grounding`, `hallucinationGuard`, `humanCheckpoint`, `telemetry`) | SPEC §4.2, §11.3, M5/M17 | Paquete de código (TS/.NET), decisión de lenguaje (D1) — la empresa corre .NET/C# | Primer caso de uso de IA en producto |
| CLI `magia` | SPEC §9, M1 | Sustituido hoy por `check.sh` y `/magia-instalar` | Decisión del comité |
| Plugins `magia-core/forge/flow` + marketplace corporativo | SPEC §35, M15 | Esquema de `marketplace.json` sin confirmar | Verificar contra la documentación oficial vigente |
| Perfil `flow` (recetas L3.1–L3.8, ficha de proceso, gates ligeros) | `referencia-spec/modules/FLOW.md` | Áreas administrativas piloto; `[por definir: áreas]` | `docs/02-valor-y-adopcion.md` priorizado |
| Perfil `forge` (cartografía, contratos, flota, verificación diferencial, MAGIA Bench) | `referencia-spec/modules/FORGE.md` | `magia-codegraph`, índice, flota | Repo grande y crítico con línea base medida antes |
| Telemetría, `audit` trimestral, kill-switch, excepciones con firma criptográfica | SPEC §19, §21, M6 | Endpoint `[por definir: D4]`, mecanismo de firma `[por definir: D8]` | Decisión del comité |

## Decisiones abiertas del handoff (SPEC §25) que siguen sin responder

D1 lenguaje del CLI · D4 backend de telemetría · D5 vault de secretos ·
D6 servidores MCP iniciales · D7 umbrales de evals (propuestos en
`docs/08`) · D8 firma de excepciones · D9 alojamiento del Registro ·
D10 presupuesto por run · D11 auto-merge de mejoras. Se registran, no se
inventan: cada una exige decisión del comité por consenso.

## Nota de método

Los efectos esperados del Motor de Valor (tiempo, costo, esfuerzo humano) no
se publican como cifras hasta medirlos en el piloto, igual que el resto de
MAGIA (`docs/10-resumen-ejecutivo-gerencia.md`: sin métricas inventadas).
