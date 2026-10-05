---
name: magia-verify
description: Verifica con evidencia real que el trabajo de {{PROJECT_NAME}} está terminado antes de declararlo listo. Úsala siempre al cerrar una tarea, una funcionalidad de features.json o un PR.
magia:
  version: 1.0.0
  template: magia-verify@1.0.0
  rules: [R1, R4, R5]
  plane: [dev]
  assumption: "El agente puede declarar terminado sin haber ejecutado pruebas"
  reviewBy: "próximo modelo aprobado"
---
# Verificación con evidencia

## Cuándo usar
- Antes de marcar `passes: true` en `docs/magia/runs/<id>/features.json`.
- Antes de commit final, PR o cierre de turno.
- Siempre después de trabajo autónomo, en rutina o en flota.

## Procedimiento
1. `git diff {{BASE_BRANCH}}...HEAD --stat` y diff completo de archivos clave. Resume qué cambió y por qué.
2. Ejecuta: `{{TEST_CMD}}` (impactados si hay índice), `npx magia check --json`, `npx magia eval --json` (si hay lógica IA).
3. Para cada criterio de la spec o de `features.json`: anota la evidencia concreta (test que lo cubre y su resultado; captura de navegador automatizado si hay UI).
4. Revisa el diff con el checklist de código IA (AF3): contrato, casos borde, errores, seguridad, dependencias nuevas, complejidad innecesaria, tests que realmente prueban.
5. Escribe `.magia/reports/verify-<id>.md`.

## Contratos
Salida `.magia/reports/verify-<id>.md`:
```
## Cambios           — resumen
## Evidencia         — criterio → prueba → resultado
## Calidad           — tests, check, evals vs. umbrales
## No verificado     — qué no se pudo probar y por qué
## Veredicto         — LISTO | NO LISTO (motivo)
```

## Criterios de éxito
- Ningún criterio sin evidencia.
- Veredicto LISTO solo con tests, check y evals en verde.

## Modo de falla
- Algo falla → veredicto NO LISTO, devolver a `magia-fixer`. Nunca relajar la prueba.
- Algo no se puede verificar → declararlo en "No verificado"; en ruta crítica, escalar a revisión humana.

## Ejemplos del proyecto
{{PROJECT_EXAMPLE — el agente instalador agrega un ejemplo con un test y un criterio reales del repo}}
