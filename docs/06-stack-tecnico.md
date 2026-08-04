# Levantamiento de stack técnico (Sprint 1)

Entregable de la tarea 2 del Sprint 1 (`docs/01-plan-tecnico-fase1.md`):
"Levantamiento de stack — lenguajes, frameworks, gestor de monorepo/repos,
pipeline CI/CD actual, proveedores cloud aprobados."

## Resumen general

| Aspecto | Valor |
|---|---|
| Hosting de repositorios | GitHub |
| Estructura de repos | Multi-repo — cada sistema tiene su propio repositorio (ej. WMS, HIPERSAP separados) |
| Pipeline CI/CD actual | GitHub Actions |
| Proveedor cloud aprobado | Microsoft Azure |

## Stack por sistema

| Sistema | Lenguaje / Framework | Notas |
|---|---|---|
| **WMS** — Core de Operaciones Internas | .NET / C# | Ver `docs/04-diagnostico-inventario-ia.md` para su caso de uso de IA (riesgo: Medio) |
| **HIPERSAP** — procesos administrativos, integra con SAP B1 | .NET / C# | Integración vía SDK/DI-API de SAP Business One; ver `docs/04` (riesgo: Alto) |

## Implicaciones para el resto de MAGIA

- El pipeline CI/CD de referencia que exige el Sprint 3 (gate de evals,
  lint de prompts, bloqueo por PII/credenciales) debe construirse sobre
  **GitHub Actions**, no como ejemplo genérico.
- Cualquier Rule/Skill orientada a código que se cree para estos repos debe
  asumir **.NET / C#** como el stack dominante hoy, no un lenguaje
  arbitrario.
- El cloud aprobado (**Azure**) es el contexto para cualquier decisión de
  infraestructura de IA (ej. Azure OpenAI si en el futuro se evalúa como
  proveedor adicional — hoy no está en la lista de aprobados, ver
  `claude-md/base.md`).

## Pendiente

- Confirmar si existen otros repos/sistemas con stack distinto (ej.
  frontend separado, microservicios en otro lenguaje) que no estén
  cubiertos aún por WMS/HIPERSAP.
- Confirmar versión específica de .NET (Framework vs. .NET 6/8+) si resulta
  relevante para los estándares técnicos del Sprint 3.
