# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).
Este proyecto usa versionado semántico (ver `docs/03-gobernanza-repositorio.md`).

## [Unreleased] - Avance Sprint 1 (diagnóstico y gobernanza)

### Agregado
- Comité de gobernanza constituido con nombres reales: José Alonso, Pablo
  Breganza, Josué Gamarro. Modelo de decisión: consenso del comité.
- Asignación de rol técnico por persona en `docs/01-plan-tecnico-fase1.md`
  (roles solapados — equipo reducido).
- Owner nombrado para `skills/elegir-patron-ia/SKILL.md` y
  `rules/example-ai-features.md` (José Alonso).
- Responsable de la compuerta final de Diligencia asignado en
  `docs/00-plan-metodologico-4D.md` §4 (comité, por consenso).
- `CLAUDE.md` en la raíz del repo (guía para Claude Code en este propio
  repositorio, distinta de la plantilla `claude-md/base.md`).
- Repo inicializado en git, primer commit (`chore: esqueleto inicial de
  MAGIA v0.1.0`).
- Proveedor/modelo de IA aprobado definido: Anthropic (Claude Code), único
  para desarrollo. Regla global agregada a `claude-md/base.md`.
- Registrado que ChatGPT y Grok están en evaluación/prueba (sin aprobación
  de producción); detalle completo queda pendiente para el inventario de
  casos de uso.
- `docs/04-diagnostico-inventario-ia.md`: inventario técnico de casos de uso
  de IA (Sprint 1). Registra Claude Code (este repo) y Cursor probado en
  WMS e HIPERSAP con Composer 2.5 fast, Grok 4.5 high fast, Opus 5, Sonnet 5
  y GPT-5.6. Incluye hallazgo abierto: ambos repos ya tocaron PII con
  proveedores no aprobados, pendiente de clasificación de riesgo por el
  comité.
- Regla global de `claude-md/base.md` ampliada: la lista de aprobados aplica
  al modelo invocado por debajo, no solo al nombre de la herramienta
  (relevante para herramientas multi-modelo como Cursor).

### Pendiente (sigue bloqueando el cierre del Sprint 1)
- Que el comité clasifique el riesgo de WMS e HIPERSAP y decida sobre
  Cursor como herramienta aprobada.
- Completar el inventario con cualquier otro repo/feature pendiente.
- Levantamiento de stack técnico real.
- Matriz de niveles de riesgo con ejemplos reales de la propia empresa.
- Criterio de priorización de casos de uso por impacto de negocio.

## [0.1.0] - Esqueleto inicial

### Agregado
- Estructura inicial del repo `magia-framework`.
- `docs/00-plan-metodologico-4D.md`: plan metodológico 4D para construir MAGIA.
- `docs/01-plan-tecnico-fase1.md`: plan técnico detallado de la Fase 1 (semanas 1-8).
- `docs/02-valor-y-adopcion.md`: capa de valor y adopción de negocio.
- `docs/03-gobernanza-repositorio.md`: estrategia de versionado y distribución.
- `claude-md/base.md`: plantilla de `CLAUDE.md` v0.1 para repos de producto.
- `rules/example-ai-features.md`: Rule de ejemplo, alcance `src/ai-features/**`.
- `skills/elegir-patron-ia/SKILL.md`: primera Skill canónica de MAGIA.

### Pendiente (bloquea cierre del Sprint 1)
- Completar los `[por definir]` de gobernanza: comité, dueños, proveedores
  aprobados, matriz de riesgo con ejemplos reales.
- Auditoría técnica real de casos de uso existentes.
