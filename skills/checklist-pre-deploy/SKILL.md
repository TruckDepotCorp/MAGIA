---
name: checklist-pre-deploy
description: "Usar esta skill antes de desplegar a producción cualquier componente de IA (o un cambio que lo afecte). Corre las 3 compuertas de diligencia de MAGIA — creación, transparencia, despliegue — y da un veredicto explícito de qué falta. Disparar con frases como '¿puedo desplegar esto?', 'revisa el checklist de despliegue', o antes de un release que toque prompts/config de modelo."
owner: "José Alonso"
version: "0.1.0"
---

# Checklist pre-despliegue (3 compuertas de diligencia)

## Cuándo usar

Antes de cualquier despliegue a producción de un componente de IA, o un
cambio que modifique un prompt, proveedor/modelo, o configuración
relacionada. Ver `magia-framework/docs/00-plan-metodologico-4D.md` §4
(Diligencia) para el detalle completo de las 3 compuertas.

## Proceso

Verificar, en orden, las 3 compuertas — si alguna falla, el despliegue
**no** procede hasta corregirla:

1. **Compuerta de Creación**
   - ¿Se usó un proveedor/modelo de la lista de aprobados (`CLAUDE.md` del
     repo)?
   - ¿Se evitó compartir datos reales de clientes, credenciales, o
     información confidencial al construir este componente?

2. **Compuerta de Transparencia**
   - Si el resultado es un documento o comunicación que verán terceros:
     ¿tiene la nota de atribución de IA y quién lo revisó? (ver plantilla
     en `magia-framework/docs/00-plan-metodologico-4D.md` §4).
   - ¿Está claro quién es el responsable humano de este componente?

3. **Compuerta de Despliegue**
   - ¿El caso de uso tiene su nivel de riesgo clasificado (rúbrica de
     `magia-framework/docs/05-matriz-riesgo.md`)?
   - Si el riesgo es Medio o Alto: ¿la ficha de diligencia
     (`skills/ficha-caso-de-uso`) está completa **y aprobada** por el
     comité de gobernanza? Sin aprobación registrada, esta compuerta no
     pasa.
   - ¿El pipeline de evals corrió y pasó antes de este cambio (si aplica)?
   - ¿No hay credenciales ni PII cruda en logs, prompts, o fixtures
     versionados?

## Qué NO hacer

- No marcar la compuerta de Despliegue como superada si la ficha de
  diligencia de un caso Medio/Alto no tiene una aprobación explícita
  registrada (nombre + fecha) — "probablemente está bien" no cuenta.
- No aprobar el despliegue por cuenta propia — esta skill **reporta** el
  estado de las 3 compuertas; el visto bueno final para desplegar sigue
  siendo humano.
- No inventar que un paso se cumplió si no hay evidencia (evals corridos,
  aprobación registrada) — marcarlo como pendiente en su lugar.

## Salida esperada

Un veredicto por compuerta (✅ pasa / ❌ falta algo, y qué exactamente), y
un veredicto final: "listo para desplegar" solo si las 3 compuertas pasan.
