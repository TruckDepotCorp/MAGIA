# magia-framework

**M**arco de **A**rquitectura y **G**obernanza de **I**nteligencia **A**rtificial.

Fuente de verdad del marco de gobernanza y arquitectura de IA para
desarrollo de software de la empresa. Este repo versiona los documentos,
el `CLAUDE.md` base y las Skills/Rules que los equipos de producto adoptan
en sus propios repos.

## Empezar aquí

1. **`CONTEXTO-PARA-CLAUDE-CODE.md`** — si vas a seguir este proyecto con
   Claude Code, empieza por ese archivo. Resume todo lo trabajado hasta
   ahora y qué falta.
2. **`docs/00-plan-metodologico-4D.md`** — cómo se está construyendo MAGIA
   (metodología de colaboración con IA, roles, checklist de calidad).
3. **`docs/01-plan-tecnico-fase1.md`** — plan técnico detallado de las
   8 semanas de construcción (4 sprints de 2 semanas).
4. **`docs/02-valor-y-adopcion.md`** — la capa de negocio/adopción que
   corre en paralelo al framework técnico.
5. **`docs/03-gobernanza-repositorio.md`** — cómo se versiona y distribuye
   este repo a los repos de producto.
6. **`docs/04-diagnostico-inventario-ia.md`** — inventario real de casos de
   uso de IA (Sprint 1).
7. **`docs/05-matriz-riesgo.md`** — matriz de niveles de riesgo (Sprint 1),
   con WMS e HIPERSAP como primeros ejemplos reales clasificados.

## Estructura

```
magia-framework/
├── README.md
├── CONTEXTO-PARA-CLAUDE-CODE.md
├── CHANGELOG.md
├── VERSION
├── docs/
├── claude-md/base.md
├── rules/
└── skills/
```

## Estado actual

Versión `0.1.0` — esqueleto inicial. Sprint 1 (semanas 1-2) en curso.
Ver `CHANGELOG.md` para el detalle de cambios.

## Cómo adoptar MAGIA en un repo de producto

1. Copiar `claude-md/base.md` → `CLAUDE.md` en la raíz del repo, completando
   la sección "Específico de este repo".
2. Copiar las Rules que apliquen de `rules/` → `.claude/rules/` del repo.
3. Copiar las Skills que apliquen de `skills/` → `.claude/skills/` del repo.
4. Registrar en el `CLAUDE.md` copiado qué versión de `magia-framework` se
   está usando (tag/release).
