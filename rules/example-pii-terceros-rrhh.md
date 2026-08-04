---
scope: "[por definir: carpeta real de modelos/servicios de RRHH del repo — ej. Core/RHModels/**,Core/Services/*Humand*.cs]"
owner: "[por definir]"
version: "0.1.0"
source: "generalizado a partir de HIPERSAP (.claude/rules/rrhh-datos-empleados.md), primer caso real de este patrón"
---

# Rule — PII de empleados vía proveedor externo de RRHH

Tercer patrón de Rule de MAGIA, distinto de los otros dos:
- `example-ai-features.md` — features de IA embebidas en el producto.
- `example-external-integration.md` — integración con un sistema propio
  externo (ERP/SAP), riesgo típico: PII de **clientes/proveedores**.
- **Este:** integración con un proveedor **SaaS externo de RRHH** (ej.
  BioTime, Humand, o equivalente), riesgo típico: PII de **empleados**
  (asistencia, horarios, ubicación, relación laboral) — un tipo de dato
  sensible distinto, con su propia consideración de minimización de datos.

## Reglas

1. Ningún dato individual de un empleado (nombre, ubicación, horario,
   ausencias) se envía a un modelo de IA como parte de un prompt sin
   evaluar primero si un **agregado** cubre el caso de uso (ej. conteos,
   promedios) — preferir el agregado sobre el registro individual.
2. Si se agrega un caso de uso de IA nuevo sobre estos datos: pasa por
   `elegir-patron-ia` y, según el nivel de riesgo resultante
   (`docs/05-matriz-riesgo.md`), completa `templates/ficha-caso-de-uso.md`
   antes de implementarse.
3. No hardcodear credenciales del proveedor de RRHH en el código — deben
   vivir en configuración, nunca en un prompt o fixture de prueba.
4. **Logging:** ninguna llamada a un modelo que procese datos de RRHH
   registra el dato crudo del empleado — solo metadata (tipo de consulta,
   cantidad de registros, resultado), igual que la convención general de
   `docs/07-arquitectura-referencia.md` §4.
5. Cambios que agreguen un nuevo punto de integración de IA sobre datos de
   empleados requieren aprobación del comité de gobernanza.

## Ejemplo de qué SÍ y qué NO

- ✅ Un resumen agregado ("N empleados con más de X tardanzas este mes")
  generado por IA.
- ❌ Pegar el registro completo de asistencia de un empleado (nombre +
  horarios + ubicación) en un prompt sin necesidad real de ese detalle.
- ❌ Automatizar una decisión sobre un empleado (ej. marcar una ausencia
  como injustificada) sin revisión humana.

## Origen

Este patrón se identificó auditando HIPERSAP (`Core/RHModels/` + servicios
BioTime/Humand) — no fue anticipado en el catálogo original de Rules del
Sprint 1. Queda como evidencia de que el catálogo de patrones de Rules se
amplía con la auditoría real de cada repo piloto, no solo con lo previsto
en el plan inicial.
