# Estándares de desarrollo (Sprint 3)

Entregable del Sprint 3 (`docs/01-plan-tecnico-fase1.md`): guía de
prompting interna, estándar de testing/evals, pipeline CI/CD de
referencia, y plantillas técnicas.

> **Nota de dependencia (4D):** el plan técnico marca que el Sprint 3
> depende de patrones ya *validados con spike* en el Sprint 2
> (`docs/07-arquitectura-referencia.md`). El spike sigue pendiente — no
> existe todavía un caso de uso de producto real. Este documento avanza
> igual, apoyado en los patrones **propuestos** (no validados) del
> Sprint 2; se revisa en cuanto el spike se ejecute.

## 1. Guía de prompting / context engineering interna

Adapta el toolkit de Producto/Proceso/Desempeño del método 4D
(`docs/00-plan-metodologico-4D.md`) a las tareas técnicas más comunes de
un equipo que usa Claude Code/Cursor como copiloto embebido (patrón ya en
uso, ver `docs/04-diagnostico-inventario-ia.md`).

### Generación de código
- **Producto:** especificar el resultado esperado (función, endpoint,
  componente), el stack (.NET/C#, ver `docs/06-stack-tecnico.md`), y las
  convenciones del repo a seguir.
- **Proceso:** pedir que primero explique el enfoque antes de escribir
  código, cuando el cambio toque una carpeta con Rule de IA activa (ver
  `rules/example-ai-features.md`) o un caso Medio/Alto.
- **Desempeño:** revisar que el código generado no introduzca un
  proveedor/modelo no aprobado, ni credenciales o datos reales en
  fixtures.

### Revisión de PRs asistida por IA
- **Producto:** la IA señala riesgos (seguridad, PII, proveedor no
  aprobado, ausencia de evals) — no aprueba el PR por sí sola.
- **Proceso:** usar el checklist de `templates/pr-template-ia.md` como
  guía de qué debe revisar.
- **Desempeño:** un humano (revisor de dominio) da la aprobación final,
  nunca la IA.

### Generación de tests
- **Producto:** tests que cubran el caso feliz y al menos un caso límite
  o adversario (entrada inválida, inyección de prompt si aplica).
- **Proceso:** para features de IA, generar también el golden dataset de
  evals correspondiente (no solo tests de código tradicional).
- **Desempeño:** un humano valida que los casos de prueba generados sean
  reales, no solo plausibles.

## 2. Estándar de testing para features con IA

Qué se prueba, por cada feature de IA:

1. **Exactitud del output** — el resultado es correcto para el caso de uso.
2. **Regresión de prompts** — un golden dataset de casos reales (entrada
   esperada → salida esperada) que se corre en cada cambio de prompt.
3. **Comportamiento ante entradas adversarias** — inyección de prompt,
   entradas malformadas o fuera de dominio.

**Framework de evals:** `[por definir — a elegir en el primer caso de uso
real; puede ser tan simple como un script que compara outputs contra el
golden dataset, no requiere una herramienta específica desde el día uno]`.

## 3. Pipeline CI/CD para componentes de IA

Ver `templates/ci-pipeline-referencia.yml` — plantilla de GitHub Actions
(coherente con el CI/CD real de la empresa, `docs/06-stack-tecnico.md`)
con 3 pasos:

1. **Lint de prompts** — formato, longitud, variables esperadas presentes.
2. **Gate de seguridad** — bloquea el merge si hay credenciales o PII en
   prompts/fixtures versionados.
3. **Evals** — corre el golden dataset antes de permitir el merge.

**Pendiente explícito:** esta plantilla no se ha ejecutado punta a punta
contra un repo real todavía — los tres pasos son estructura de referencia,
no un pipeline ya validado. Se valida con el primer caso de uso real.

## 4. Plantillas técnicas

- **Ficha de caso de uso:** `templates/ficha-caso-de-uso.md` — se
  completa antes de implementar cualquier caso clasificado Medio o Alto
  (`docs/05-matriz-riesgo.md`).
- **Plantilla de PR:** `templates/pr-template-ia.md` — checklist embebido
  de evals corridos, riesgo evaluado, y revisor de dominio asignado.

## Pendiente

- Elegir/construir el framework de evals concreto (sección 2) en cuanto
  exista un primer caso de uso real.
- Ejecutar el pipeline de referencia (sección 3) contra un repo real y
  documentar los ajustes necesarios.
- Generar el primer golden dataset real (aunque pequeño) — condición
  explícita del criterio de aceptación del Sprint 3.
