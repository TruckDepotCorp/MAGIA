# Estructura de referencia de plugins MAGIA

Confirmar el formato exacto contra la documentación vigente de plugins de Claude Code al implementar.

```
magia-marketplace/                      # repo privado truckdepot/magia-marketplace
├─ .claude-plugin/marketplace.json      # catálogo: magia-core, magia-forge, magia-flow, capacidades del Registro
└─ plugins/
   ├─ magia-core/
   │  ├─ .claude-plugin/plugin.json
   │  ├─ commands/        magia-brief, magia-spec, magia-plan, magia-review, magia-eval, magia-gate, magia-ship, magia-scout, magia-improve
   │  ├─ agents/          magia-planner, magia-reviewer, magia-evaluator, magia-red-teamer, magia-security, magia-architect, magia-builder, magia-worker, magia-fixer, magia-documenter, magia-scout
   │  ├─ skills/          magia-context, magia-quality-gate, magia-evals, magia-verify, magia-data-shield, magia-perf-optimizer, magia-grounding, magia-hallucination-guard, magia-brand-voice, magia-human-checkpoint, magia-red-team
   │  ├─ hooks/hooks.json  SessionStart, PreToolUse (guard-read, guard-write, guard-bash), PostToolUse (scan-secrets), Stop (gate sobre resultados reales)
   │  ├─ .mcp.json        servidores de la allowlist
   │  └─ CONSTITUCION.md
   ├─ magia-forge/        agentes forge-*, comandos /forge-*, magia-codegraph
   └─ magia-flow/         Skills flow-*, recetas L3.x
```

- Versionado semver; `magia.lock` del proyecto registra la versión instalada.
- Las Skills del plugin son plantillas Core; `magia generate` crea las variantes específicas del proyecto en `.claude/skills/`.
- Un cambio de versión del plugin en el marketplace actualiza MAGIA en toda la corporación; `magia upgrade` regenera la capa del proyecto si cambiaron plantillas.
