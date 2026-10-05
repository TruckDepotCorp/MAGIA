---
name: magia-diligencia
description: "Usar al cerrar un entregable relevante hecho con ayuda de IA (PR, informe, documento para terceros, análisis para una decisión) para generar su Declaración de Diligencia y el Paquete de Evidencia. Disparar con frases como 'declaración de diligencia', 'paquete de evidencia', 'documenta el uso de IA en este PR', 'prepara el PR para revisión'. No sustituye a checklist-pre-deploy ni a ficha-caso-de-uso."
owner: "José Alonso"
version: "0.1.0"
rules: [R5]
assumption: "Sin un responsable nombrado y evidencia a la vista, el uso de IA no es auditable"
reviewBy: "al cambiar de modelo aprobado"
---

# Declaración de Diligencia y Paquete de Evidencia

Implementa la Diligencia del 4D (`docs/00-plan-metodologico-4D.md` §4):
creación, transparencia y despliegue. La persona que firma responde por el
entregable como si lo hubiera hecho sola.

## Cuándo usar
- Al abrir un PR con trabajo asistido por IA (obligatorio en riesgo medio/alto).
- Al entregar un informe, análisis o documento para terceros o para una
  decisión, generado o asistido por IA.

## Procedimiento
1. Ejecutar `magia-verify` primero: sin su reporte no hay evidencia. El agente `magia-documenter` puede redactar el Paquete a partir de ese reporte; la firma sigue siendo humana.
2. Completar `templates/declaracion-diligencia.md`: papel de la IA (modelo y
   herramienta), papel de las personas, verificación realizada y su
   resultado, limitaciones conocidas, responsable nombrado.
3. Armar el **Paquete de Evidencia** como descripción del PR
   (`templates/pr-template-ia.md`): intención y resultado, resumen del
   cambio y patrón elegido, calidad (pruebas/evals), seguridad (Reglas Core
   y datos tocados), riesgos y supuestos, cómo probarlo en 5 minutos y la
   Declaración de Diligencia.
4. En riesgo medio/alto, enlazar la ficha de diligencia aprobada
   (`ficha-caso-de-uso`). Sin aprobación registrada del comité, no se
   afirma que existe.
5. La revisión línea por línea es obligatoria solo en rutas críticas
   (`MAGIA.md` § Rutas críticas) y en riesgo alto; el resto se aprueba
   leyendo la evidencia.

## Criterios de éxito
- El revisor puede decidir leyendo el Paquete, sin reconstruir qué pasó.
- Hay un responsable humano nombrado y sus limitaciones están declaradas.

## Modo de falla
- Falta evidencia de una afirmación → escribirlo en "Limitaciones", no
  omitirlo ni asumirlo cumplido.
- El agente no firma por la persona: la firma es humana.

## Ejemplos del repo
`[por definir: ejemplo de Paquete de Evidencia del primer PR real del piloto]`
