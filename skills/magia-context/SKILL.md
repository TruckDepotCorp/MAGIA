---
name: magia-context
description: "Usar para crear o actualizar el MAGIA.md del repo (contexto de gobernanza: riesgo, autonomía, comandos, rutas críticas, datos sensibles) y para compactar una sesión larga sin perder lo importante. Disparar con frases como 'actualiza MAGIA.md', 'documenta el contexto de IA del repo', 'la sesión está muy larga', 'compacta', o cuando cambian el stack, los comandos o las rutas críticas."
owner: "José Alonso"
version: "0.1.0"
rules: [R8]
assumption: "El contexto de un agente se degrada si es largo, genérico o desactualizado"
reviewBy: "al cambiar de modelo aprobado"
---

# Contexto MAGIA del repo

`MAGIA.md` es el contexto de gobernanza del repo, importado desde
`CLAUDE.md` con `@MAGIA.md`. Es la fuente de verdad de comandos, riesgo y
rutas críticas para todas las demás Skills, agentes y hooks. Plantilla:
`templates/MAGIA.md`.

## Cuándo usar
- Instalación inicial (la invoca `/magia-instalar`).
- Cambió el stack, un comando de build/test/eval, una ruta crítica, el nivel
  de riesgo o el de autonomía.
- Una sesión larga se acerca al límite de contexto (sección "Compactar").

## Procedimiento — crear o actualizar `MAGIA.md`
1. Leer `magia.config.json`, `CLAUDE.md` y la estructura real del repo. No
   leer archivos de `.magia/local/restringido.txt` ni `.env*`.
2. Completar cada sección de la plantilla con datos **reales** (rutas,
   comandos que se ejecutaron y funcionan). Lo que no se pueda confirmar se
   deja como `[por definir: ...]`; nunca se inventa.
3. Mantener `MAGIA.md` ≤ 300 líneas y `CLAUDE.md` ≤ 150. El detalle de
   procedimientos de más de 5 pasos vive en Skills, no aquí.
4. Cada regla debe ser concreta y verificable ("ejecuta `X` antes de
   commitear"), nunca aspiracional ("escribe buen código"), y no duplicar
   Skills ni Reglas Core: enlazar.
5. Ejecutar `bash .magia/core/scripts/check.sh` y corregir lo que reporte.

## Compactar (compactación dirigida)
Antes de que la compactación automática decida por su cuenta, compactar con
esta instrucción y actualizar antes `docs/magia/runs/<id>/progress.md` si
existe:

```
Conserva: objetivo de la tarea, decisiones tomadas y su porqué, archivos
modificados, pruebas/evals que fallan y su causa, pendientes, Reglas en juego.
Descarta: salidas completas de comandos, exploraciones descartadas, código
ya commiteado.
```

## Criterios de éxito
- `check.sh` sin errores de contexto (tamaño, marcadores `{{` o
  `[por definir]` críticos sin resolver, comandos presentes).
- Un agente nuevo puede correr build, pruebas y evals leyendo solo `MAGIA.md`.

## Modo de falla
- Un comando no funciona → no documentarlo como válido; registrarlo en
  "Pendiente" de `MAGIA.md`.
- Falta un dato de la empresa → `[por definir: ...]` y avisar a la persona.
