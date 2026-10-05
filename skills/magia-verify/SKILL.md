---
name: magia-verify
description: "Usar SIEMPRE antes de declarar terminada una tarea, un cambio o un PR. Ejecuta las pruebas del repo, lee el diff y reporta con evidencia qué se verificó y qué no. Disparar con frases como 'ya está', 'termina esto', 'prepara el PR', '¿está listo?', 'verifica el cambio', o al cerrar cualquier trabajo hecho de forma autónoma."
owner: "José Alonso"
version: "0.1.0"
rules: [R5, R8]
assumption: "El agente puede declarar terminado un trabajo sin haber ejecutado las pruebas"
reviewBy: "al cambiar de modelo aprobado"
---

# Verificación con evidencia

El agente **no declara terminado** un trabajo sin ejecutar esta Skill. Cuanto
menos se supervisó el trabajo, más estricta la verificación (tabla al final).

## Cuándo usar
- Antes de marcar como hecha una tarea o una funcionalidad de la spec.
- Antes del commit final, del PR o de cerrar el turno.
- Siempre después de trabajo autónomo, en paralelo o en bucle.

## Procedimiento
1. **Cambios:** `git diff <rama-base>...HEAD --stat` y el diff completo de los
   archivos clave. Resumir qué cambió y por qué (una línea por archivo).
2. **Ejecutar** los comandos de `MAGIA.md` § Comandos: pruebas
   (`commands.test`), lint/build si existen, evals si el cambio toca lógica o
   prompts de IA (`commands.eval`) y `bash .magia/core/scripts/check.sh`.
   Copiar la salida relevante, no resumirla de memoria.
3. **Criterios:** por cada criterio de aceptación de la spec o de la tarea,
   anotar la evidencia concreta: prueba que lo cubre y su resultado (captura
   de navegador si hay UI).
4. **Revisar el diff** con este checklist de código generado por IA:
   contrato respetado, casos borde, manejo de errores, seguridad (secretos,
   PII, entradas externas), dependencias nuevas, complejidad innecesaria,
   y pruebas que realmente prueban algo (no solo ejecutan líneas).
5. **Escribir** `.magia/reports/verify-<id>.md` con el formato de abajo.

## Formato de salida
```
## Cambios      — resumen
## Evidencia    — criterio → prueba → resultado
## Calidad      — pruebas, check, evals vs. umbrales
## No verificado — qué no se pudo probar y por qué
## Veredicto    — LISTO | NO LISTO (motivo)
```

## Criterios de éxito
- Ningún criterio sin evidencia.
- Veredicto LISTO solo con pruebas, `check.sh` y evals (si aplican) en verde.

## Modo de falla
- Algo falla → veredicto **NO LISTO** y corregir la causa raíz (agente
  `magia-fixer`). Nunca relajar, borrar ni saltar una prueba para que pase.
- Tras 2 correcciones fallidas sobre el mismo enfoque: **rebobinar** al
  último punto bueno y replantear desde el plan, no seguir parchando.
- Algo no se puede verificar → declararlo en "No verificado"; si es una ruta
  crítica o riesgo alto, pedir revisión humana.
- Nunca "continuar igual".

## Verificación proporcional
| Cómo se hizo el trabajo | Verificación mínima |
|---|---|
| Dirigido, paso a paso | Esta Skill |
| Por objetivo, supervisión parcial | + agente `magia-reviewer` + leer el reporte antes de aprobar |
| Autónomo, en bucle o en paralelo | + revisión de las rutas críticas por una persona + muestra de lo que hizo el agente |

## Ejemplos del repo
`[por definir: el instalador agrega aquí un ejemplo con una prueba y un criterio reales del repo destino]`
