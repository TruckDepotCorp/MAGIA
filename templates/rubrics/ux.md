# Rúbrica de UX para productos con interfaz construidos con IA

Obligatoria (AF3) en repos con interfaz de usuario, cuando la IA genera o
modifica pantallas, flujos o textos de interfaz. Copiar a `evals/rubrics/ux.md`
(o `docs/magia/rubricas/` si el repo no tiene evals) y adaptar los ejemplos
a la UI real. Puntuar 0–1 por criterio; las personas calibran el criterio
con capturas reales, no con la descripción del código.

| Criterio | Pasa si | Cómo se verifica |
|---|---|---|
| `claridad` | Un usuario nuevo entiende qué hacer en cada pantalla sin ayuda; una acción principal por pantalla | Captura + recorrido de la tarea principal |
| `consistencia` | Usa los componentes, colores, tipografía y textos del sistema existente (en HIPERSAP: Radzen), sin estilos ad hoc | Comparar contra pantallas vecinas |
| `estados` | Existen y son útiles los estados vacío, cargando, error y éxito; los errores dicen qué hacer | Forzar cada estado |
| `accesibilidad` | Contraste suficiente, foco visible, navegación por teclado, etiquetas en campos, no depender solo del color | Revisión manual / herramienta de accesibilidad del repo |
| `datos_sensibles` | No muestra más datos personales de los necesarios; enmascara lo restringido | Revisar con datos sintéticos |
| `acciones_irreversibles` | Borrar, enviar o escribir en sistemas externos pide confirmación explícita y dice el efecto | Probar cada acción destructiva |
| `divulgacion_ia` | Si hay texto o decisión generada por IA para clientes externos, se identifica como tal (R7) | Revisar canales de cliente |
| `voz` | Español neutro, directo, sin emoji ni exageraciones (Constitución §6) | Lectura de textos |

Veredicto por pantalla: APRUEBA | AJUSTES (lista) | RECHAZA. Una persona del
equipo decide; el agente solo propone. Declarar en el Paquete de Evidencia
qué pantallas se revisaron con captura y cuáles no.
