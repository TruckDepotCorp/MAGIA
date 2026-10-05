#!/usr/bin/env bash
# SessionStart — su stdout se agrega al contexto de la sesión.
. "$(dirname "$0")/lib.sh"
if [ ! -f "$CONFIG" ]; then
  echo "[MAGIA] magia.config.json no encontrado: ejecuta /magia-instalar."
  exit 0
fi
echo "[MAGIA] Riesgo: $(cfg_str risk) · Autonomía: $(cfg_str autonomy) · Enforcement: $MODE."
echo "Reglas Core R1-R9 y Constitución en .magia/core/. Tarea no trivial (más de un archivo, cambia un contrato o toca una ruta crítica): empieza en modo plan. Antes de dar algo por terminado, ejecuta la skill magia-verify. Datos restringidos y secretos: no leer ni enviar a un modelo."
exit 0
