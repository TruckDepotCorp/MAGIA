---
scope: "src/ai-features/**"
paths: "src/ai-features/**"  # campo que Claude Code usa para cargar la Rule por ruta (scope se conserva por compatibilidad)
owner: "José Alonso"
version: "0.1.0"
---

# Rule — Features con IA

Aplica solo a código dentro de `src/ai-features/`.

## Reglas

1. Todo prompt nuevo o modificado debe tener un golden dataset asociado en
   `src/ai-features/**/evals/` antes de mergear.
2. Todo cambio en esta carpeta corre el pipeline de evals en CI antes de
   poder mergear a `main` (ver `magia-framework/docs/01-plan-tecnico-fase1.md`,
   Sprint 3).
3. No hardcodear el nombre de modelo/proveedor directamente en el código de
   negocio — usar la capa de configuración central definida en
   `[por definir: ruta del config de modelos]`.
4. Toda llamada a un modelo debe registrar (log) el patrón de arquitectura
   usado (RAG / agente / prompting directo / copiloto) para trazabilidad,
   sin registrar el contenido crudo si incluye PII.
5. Cambios que agreguen un nuevo patrón de integración no listado en
   `magia-framework/docs/` requieren aprobación del arquitecto de IA antes
   de mergear.

## Ejemplo de qué SÍ y qué NO

- ✅ Agregar un nuevo caso de prueba al golden dataset existente.
- ✅ Ajustar el prompt de un caso ya aprobado, con evals actualizados.
- ❌ Agregar un proveedor de modelo nuevo sin pasar por el catálogo de
  capacidades.
- ❌ Mergear un cambio de prompt sin correr el pipeline de evals.
