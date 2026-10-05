# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

`magia-framework` is **not a software codebase** — there is no app, no build, no
lint, no test suite, and no dependency manifest. It is the versioned source of
truth for **MAGIA** (*Marco de Arquitectura y Gobernanza de Inteligencia
Artificial*), an internal AI governance/architecture framework for the
company's software development. The repo's "product" is a set of Markdown
documents plus a `CLAUDE.md` template and Claude Code Skills/Rules that other
product repos copy and adopt.

Because there are no commands to build/run/test, do not invent them. The only
"verification" that applies here is editorial: does a change match the
existing structure, does it update `CHANGELOG.md`/`VERSION`, and does it avoid
inventing company-specific facts (see below).

## Required reading before making changes

Read `CONTEXTO-PARA-CLAUDE-CODE.md` first, in full — it is the project's own
continuity briefing and takes precedence over inferring intent from file
contents alone. It defines the current sprint, what is deliberately still
open, and how Claude Code is expected to behave in this repo. Key points
carried forward from it:

- The project follows the **4D methodology** (Delegation → Description →
  Discernment → Diligence), detailed in `docs/00-plan-metodologico-4D.md`.
  Any new MAGIA content should follow that collaboration mode, not generic
  "industry best practices" prose presented as fact.
- **Never invent company-specific facts.** Real names, approved
  models/providers, risk criteria, and use-case inventories are still
  `[por definir: ...]` in the existing docs (see "Pendiente" section of
  `CONTEXTO-PARA-CLAUDE-CODE.md` §6). When a document needs one of these and
  it hasn't been provided, use the same `[por definir: ...]` marker instead of
  filling it in — this convention is used consistently across every doc in
  the repo.
- **Fase 1 (weeks 1–8) is sprint-gated** and currently in Sprint 1 — see
  `docs/01-plan-tecnico-fase1.md`. Sprint 4 content (Skills/Rules/hooks piloto
  real) deliberately depends on Sprints 1–3 being closed first; don't
  front-run later-sprint deliverables while earlier ones are still open.
  Do not draft Fase 2 (weeks 9–10) content while Sprint 1 is open.
- When scope or organizational ambiguity comes up, ask before producing a long
  document — this repo explicitly prioritizes asking over redoing.

## Repository structure

```
magia-framework/
├── README.md                       ← adoption instructions for product repos
├── CONTEXTO-PARA-CLAUDE-CODE.md    ← continuity briefing, read first
├── CHANGELOG.md                    ← Keep a Changelog format, mandatory per change
├── VERSION                         ← semantic version, single line
├── docs/                           ← the 5 pillars, plans, governance policy
│   ├── 00-plan-metodologico-4D.md  ← HOW MAGIA itself is built with AI (4D)
│   ├── 01-plan-tecnico-fase1.md    ← 8-week technical plan, 4 sprints
│   ├── 02-valor-y-adopcion.md      ← business value/adoption layer (parallel, not a 6th pillar)
│   └── 03-gobernanza-repositorio.md← how this repo is versioned/distributed
├── claude-md/base.md               ← CLAUDE.md TEMPLATE for product repos (not this repo's own CLAUDE.md)
├── core/                           ← Core inmutable que se instala en .magia/core/ (Constitución, R1–R9, hooks, scripts)
├── rules/                          ← example/canonical path-scoped Rules (copied to a product repo's .claude/rules/)
├── skills/                         ← canonical Skills (copied to a product repo's .claude/skills/)
│   └── elegir-patron-ia/SKILL.md
├── agents/  commands/  templates/  ← subagentes, comandos /magia-* (incl. /magia-instalar) y plantillas instalables
```

## Architecture / mental model

MAGIA's five pillars each map to a distinct Claude Code layer — this mapping
is the organizing idea of the whole repo (full table in
`docs/00-plan-metodologico-4D.md` §5):

| MAGIA pillar | Claude Code layer | Loaded |
|---|---|---|
| Gobernanza + Diligencia | `CLAUDE.md` (root, global rules) | Always, every session |
| Estándares de desarrollo | `.claude/rules/` (path-scoped) | Only when that path is touched |
| Arquitectura de referencia + Catálogo de capacidades | `.claude/skills/` | Only when the task matches |
| Ciclo de vida y diligencia | hooks in `settings.json` | At fixed lifecycle points |

Decision rule used throughout the repo for "where does this new piece of
MAGIA go": always-true-everywhere → `CLAUDE.md`; scoped to a folder/filetype →
a Rule; an invokable repeatable procedure → a Skill; must run automatically as
an enforcement gate → a hook.

**Distribution model:** this GitHub repo is the single source of truth (a
future dashboard would only *read* from it, never replace it). Product repos
**copy**, not link, `claude-md/base.md` → their own `CLAUDE.md` and the
relevant `rules/`/`skills/` → their own `.claude/`, pinning a specific MAGIA
release tag. Changes here never auto-propagate to product repos — each one
decides when to re-copy a newer version (see `docs/03-gobernanza-repositorio.md`).

## Conventions for editing this repo

- **Bash scripts in `core/` are the one exception to "no code here":** they
  ship to product repos. After editing `core/hooks/*.sh` or
  `core/scripts/check.sh`, run `bash -n` and re-test with simulated hook
  JSON before changelog. Keep them LF (`.gitattributes`). Hook syntax was
  verified against the official docs on 2026-10-05; re-verify if it changes.
- `docs/referencia-spec/` is the imported handoff (target design). Do not
  edit it; adapted decisions live in `docs/11` §4.

- **Every change to `docs/`, `claude-md/`, `rules/`, or `skills/` needs a
  `CHANGELOG.md` entry** (Keep a Changelog format) and, where warranted, a
  `VERSION` bump (semver: MAJOR = breaking change to already-deployed
  `CLAUDE.md`/Rules, MINOR = new Skill/Rule/pillar section, PATCH = wording
  fix with no behavior change). Per repo policy this normally goes through a
  PR reviewed by the governance committee, not a direct commit to main — but
  since this working copy has no git remote configured yet, treat the
  PR/review step as a note for when it does.
- **Skills** follow the `skills/<name>/SKILL.md` layout with YAML front-matter
  (`name`, `description`, `owner`, `version`) — see
  `skills/elegir-patron-ia/SKILL.md` as the canonical example. The
  `description` field is what triggers the skill, so phrase it around
  concrete trigger phrases, not a generic summary.
- **Rules** follow `rules/<name>.md` with YAML front-matter (`scope`, `owner`,
  `version`) where `scope` is the glob path the rule applies to — see
  `rules/example-ai-features.md`.
- `claude-md/base.md` is a **template**, not this repo's own configuration —
  edits to it change what product repos receive when they adopt MAGIA, so
  treat it with the same weight as a public API change.
