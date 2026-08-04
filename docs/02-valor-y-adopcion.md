# MAGIA — Valor y Adopción
### Complemento paralelo al framework técnico (no un sexto pilar de gobernanza)

## Por qué existe este documento

Un marco de arquitectura y gobernanza (los 5 pilares de MAGIA) resuelve
"¿cómo construimos IA de forma segura y estandarizada?". No resuelve
"¿qué vale la pena construir primero, y cómo sabemos si generó valor real?".
Sin esta capa, MAGIA puede terminar siendo un marco excelente para construir
cosas que a nadie le importa que existan.

Este documento corre **en paralelo** a los Sprints técnicos (ver
`01-plan-tecnico-fase1.md`), con dueño de negocio, no solo técnico.

---

## 1. Motor de valor (priorización de casos de uso)

- **Criterio de priorización** por impacto de negocio, no solo por
  factibilidad técnica: horas ahorradas, aumento de conversión, reducción de
  errores/incidentes, no solo "es técnicamente posible".
- **Portafolio con mentalidad de apuestas**: varios experimentos pequeños en
  paralelo, con criterio explícito para descontinuar los que no rinden — no
  un solo rollout secuencial y ya.
- **Métricas de negocio por caso de uso**, no solo métricas técnicas de
  adopción. "Se usó la Skill 40 veces" no es lo mismo que "ahorró 12
  horas/semana al equipo de soporte".

`[por definir: criterio de priorización real — depende de los objetivos de negocio de la empresa]`

## 2. Capa humana (adopción real, no cumplimiento formal)

- **Adopción vs. cumplimiento**: si `CLAUDE.md`/Rules se sienten como
  burocracia impuesta, el equipo encuentra cómo evitarlas (shadow AI). Se
  necesitan incentivos, no solo reglas.
- **Capacitación continua**: tratar la fluidez con IA como una habilidad que
  se entrena de forma constante, no un onboarding de una sola vez en la
  semana 8.
- **Patrocinio ejecutivo real**: presupuesto, tiempo protegido para los
  equipos piloto, y alguien con autoridad que defienda el marco cuando
  choque con la presión de entregar rápido.

## 3. Fundamento de datos e infraestructura

- Gobierno de la calidad del dato de origen (no solo del uso de IA sobre
  ese dato).
- Observabilidad en producción real: drift de modelos, degradación de
  calidad con el tiempo — más allá del checklist de pre-deploy.
- Estrategia de proveedores/modelos a mediano plazo (multi-modelo, costo,
  dependencia de un solo proveedor).

---

## Cómo se mide (a definir junto al equipo de negocio)

| Caso de uso | Métrica de negocio | Línea base | Meta | Dueño |
|---|---|---|---|---|
| `[por definir]` | `[por definir]` | `[por definir]` | `[por definir]` | `[por definir]` |

Esta tabla debe llenarse **antes** del piloto de la Fase 2 (semanas 9-10),
para que exista evidencia real de valor al cierre de las 10 semanas — no
solo evidencia de que "el marco funciona técnicamente".
