---
scope: "**/Integration*/**,**/SAP*/**,**/*ServiceLayer*/**"
owner: "[por definir]"
version: "0.1.0"
---

# Rule — Integración con sistemas externos propios

Aplica a código que integra con un sistema propio externo al repo (ERP,
SAP Business One, u otro sistema de negocio) — no a features de IA en sí
(ver `rules/example-ai-features.md` para eso). Este es el tipo de área
crítica identificada en el Sprint 1 (`docs/04-diagnostico-inventario-ia.md`):
HIPERSAP es un ejemplo real, clasificado en riesgo Alto por su exposición
externa vía SAP B1.

> **Nota de adaptación:** el `scope` de arriba es un patrón genérico de
> ejemplo. Al copiar esta Rule a un repo real, ajustar el glob a la
> carpeta real donde vive esa integración (ej. en HIPERSAP, la integración
> con SAP B1 vive dentro de `Core/` junto con el resto de la lógica de
> negocio — no en una carpeta aislada; confirmar el patrón exacto antes de
> activarla).

## Reglas

1. Ninguna operación de **escritura** hacia el sistema externo se ejecuta
   sin confirmación humana si es irreversible (ver estándar de MCP en
   `magia-framework/docs/07-arquitectura-referencia.md` §3, aunque esta
   Rule aplica igual si la integración no usa IA/MCP — es el mismo
   principio de "escritura irreversible requiere humano").
2. Si un caso de uso de IA nuevo se apoya en esta integración (ej. un
   agente que consulta o escribe en el sistema externo): pasa primero por
   la skill `elegir-patron-ia` y, si el riesgo resulta Medio/Alto, por
   `templates/ficha-caso-de-uso.md` — no se conecta un modelo directamente
   a este sistema sin ese paso.
3. No hardcodear credenciales de conexión al sistema externo en el código;
   deben vivir en la capa de configuración/secretos del repo, nunca en un
   prompt ni en un fixture de prueba.
4. Cambios que agreguen un nuevo punto de integración de IA con este
   sistema (no solo código tradicional) requieren aprobación del comité de
   gobernanza, dado que este tipo de área ya se clasificó en riesgo
   Alto/Medio en al menos un caso real (`docs/05-matriz-riesgo.md`).

## Ejemplo de qué SÍ y qué NO

- ✅ Agregar un nuevo endpoint de solo lectura hacia el sistema externo,
  sin componente de IA.
- ✅ Un agente que **consulta** (no escribe) el sistema externo, con la
  ficha de diligencia ya aprobada.
- ❌ Un agente que **escribe** en el sistema externo de forma autónoma,
  sin confirmación humana en el paso de escritura.
- ❌ Conectar un modelo a este sistema sin haber pasado por
  `elegir-patron-ia` primero.
