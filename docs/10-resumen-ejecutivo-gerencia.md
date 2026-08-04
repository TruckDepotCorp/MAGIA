# MAGIA — Qué significa para el negocio

> Resumen ejecutivo. La versión completa y técnica del framework vive en
> el resto de este repositorio (`magia-framework`); este documento es para
> comunicar impacto, no detalle de implementación.

## En una frase

MAGIA convierte las reglas de gobernanza de IA de la empresa —qué se puede
usar, con qué datos, y bajo qué nivel de riesgo— en algo que vive dentro
del trabajo diario de desarrollo, no en un documento que se firma una vez
y se archiva.

## El problema que resuelve

Hoy la IA se incorpora al desarrollo de software de forma ágil pero
informal: cada equipo elige herramientas, modelos y patrones a su
criterio, sin un registro centralizado de qué se usa, dónde, y qué riesgo
implica. Eso funciona sin sobresaltos hasta que algo sale mal — y en ese
momento nadie puede responder con certeza "¿qué proveedor de IA tocó qué
dato, y quién lo aprobó?".

## Qué pasó al instalarlo en un proyecto real de la empresa

Al aplicar el proceso de auditoría de MAGIA en un sistema crítico interno,
apareció algo que no estaba documentado en ningún lado: el equipo llevaba
cerca de un año usando **varios proveedores de IA en paralelo** —algunos
sin ninguna evaluación formal— sobre datos sensibles (de clientes/terceros
y de empleados), sin que existiera una clasificación de riesgo ni una
regla clara de qué estaba permitido.

En una sola sesión de trabajo, MAGIA permitió:

- **Auditar y dejar por escrito**, con evidencia real (no supuestos), qué
  proveedores de IA se usan hoy y en qué parte del sistema.
- **Clasificar el riesgo real** —no una percepción— con criterios
  objetivos: ¿toca datos personales?, ¿decide algo sin revisión humana?,
  ¿es visible a terceros externos?, ¿es reversible un error?
- **Definir con claridad** qué proveedores quedan aprobados y cuáles
  necesitan pasar por el comité de gobernanza antes de usarse.
- **Instalar esas reglas directamente en el flujo de trabajo del
  desarrollador**: hoy, si alguien toca un archivo sensible en ese
  proyecto, recibe una advertencia automática — sin que nadie tenga que
  acordarse de revisarlo manualmente cada vez.

Todo esto **sin frenar el desarrollo**: el modo elegido a propósito es de
**advertencia**, no de bloqueo. El objetivo es visibilidad y trazabilidad,
no burocracia que el equipo termine evitando.

## El verdadero potencial: no es lo que resolvió, es que se repite

Lo valioso de MAGIA no es haber ordenado un proyecto puntual — es que **el
mismo proceso ya queda listo para aplicarse a cualquier otro proyecto**,
sin reinventarlo cada vez:

- Un **catálogo de patrones de integración de IA** ya evaluado (cuándo un
  asistente de código, cuándo un agente que actúa sobre un sistema propio,
  cuándo un buscador sobre documentación interna) — decisiones de
  arquitectura que ya no hay que discutir desde cero en cada iniciativa
  nueva.
- **Plantillas listas para usar**: una ficha de diligencia para cualquier
  caso de uso de IA nuevo, un checklist de revisión de código, y un
  checklist de 3 compuertas antes de cualquier despliegue a producción.
- Una **matriz de decisión** de qué herramienta/proveedor usar para cada
  tipo de tarea, con su nivel de riesgo y costo relativo ya pensado de
  antemano.
- Un **modelo de gobernanza vivo** (comité, niveles de riesgo, cuándo
  escalar a una persona) que no depende de la memoria de nadie en
  particular — está escrito, versionado, y se actualiza con el tiempo.

## Por qué importa para la empresa

- **Reduce el riesgo reputacional y de cumplimiento** de usar IA sin
  control, sin frenar la velocidad de adopción.
- **Convierte la gobernanza en algo vivo**, integrado al trabajo real, no
  un PDF que se aprueba una vez y se olvida.
- **No requiere inversión nueva en herramientas** — aprovecha lo que la
  empresa ya usa y ya paga.
- **Acelera cada adopción futura de IA**: el próximo proyecto no empieza
  de cero — parte de un estándar ya validado en un caso real.
