---
description: Revisa el diff actual contra la Constitución y las Reglas Core R1–R9 (agentes magia-reviewer y magia-security)
argument-hint: [rama base opcional]
---
Revisa los cambios actuales (contra `$ARGUMENTS` si se indicó, o contra la rama base del repo). Invoca en paralelo los agentes `magia-reviewer` y `magia-security`; consolida sus hallazgos en un solo informe sin duplicados, ordenado por severidad, con el veredicto de cada uno. Si algún cambio toca una ruta crítica de `MAGIA.md`, indica que requiere revisión humana línea por línea. No modifiques archivos.
