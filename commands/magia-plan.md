---
description: Genera el plan técnico de una iniciativa con el agente magia-planner y se detiene a pedir aprobación
argument-hint: <iniciativa o ruta de la spec>
---
Iniciativa: $ARGUMENTS

Entra en modo plan (solo lectura salvo el archivo del plan). Invoca el agente `magia-planner` con la spec (`docs/magia/spec.md`) y el brief. El plan queda en `docs/magia/plans/<id>.md` con `status: draft`.

Presenta a la persona un resumen de una pantalla: objetivo, tareas y dependencias, patrón de IA elegido y por qué, riesgos y rutas críticas, y qué decide ella. **Detente y espera aprobación**; al aprobarse, cambia el plan a `status: approved` registrando quién aprobó. No implementes nada antes.
