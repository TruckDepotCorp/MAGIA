<!--
Plantilla técnica del Sprint 3 (docs/01-plan-tecnico-fase1.md).
Usar para cualquier PR que agregue o modifique un prompt, cambie el
proveedor/modelo usado, o toque código dentro de una carpeta con Rule de
IA activa (ej. src/ai-features/**, ver rules/example-ai-features.md).
-->

## Qué cambia

<!-- Descripción breve del cambio. Si modifica un prompt existente, indicar
     cuál y por qué. -->

## Checklist de IA (obligatorio para este tipo de PR)

- [ ] El proveedor/modelo usado está en la lista de aprobados
      (`claude-md/base.md`) — o fue escalado al comité si no lo está.
- [ ] El prompt vive versionado en este repo (no en config externa sin
      versionar) — ver `docs/07-arquitectura-referencia.md` §4.
- [ ] Si se modificó un prompt existente: el golden dataset de evals fue
      actualizado y los evals corrieron en CI antes de este PR
      (`rules/example-ai-features.md`).
- [ ] Riesgo evaluado con la rúbrica de `docs/05-matriz-riesgo.md`:
      **Bajo / Medio / Alto** (borrar los que no aplican).
- [ ] Si el riesgo es Medio o Alto: la ficha de caso de uso
      (`templates/ficha-caso-de-uso.md`) está completa y aprobada por el
      comité de gobernanza.
- [ ] No hay credenciales, tokens, ni datos reales de clientes en el
      prompt, fixtures de prueba, o configuración versionada.
- [ ] Si el caso de uso toca PII: el log/observabilidad enmascara el dato
      crudo, no lo registra tal cual (`docs/07-arquitectura-referencia.md`
      §4).
- [ ] Revisor de dominio asignado (no solo revisor de código) — indicar
      quién:

## Revisor de dominio

<!-- Nombre de quien valida el criterio de negocio/riesgo, no solo la
     sintaxis del código. -->
