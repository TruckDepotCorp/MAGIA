#!/usr/bin/env bash
# Hook PreToolUse de referencia (Sprint 4, docs/01-plan-tecnico-fase1.md).
#
# Modo ADVERTENCIA por defecto, no bloqueo duro — a propósito (ver docs/01,
# "hooks demasiado agresivos desde el día uno pueden generar rechazo al
# marco"). Cambiar MODE=block solo después de validar con el equipo piloto.
#
# [ADAPTAR] Este script asume que Claude Code pasa el input del hook como
# JSON por stdin con un campo de ruta de archivo — confirmar el formato
# exacto contra la documentación oficial vigente antes de usar en un repo
# real; la mecánica de hooks puede haber cambiado desde que se escribió
# esta plantilla.

MODE="${MAGIA_HOOK_MODE:-warn}"

INPUT="$(cat)"
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Patrones de archivos sensibles: credenciales, .env, config de proveedores.
if echo "$FILE_PATH" | grep -Eiq '(\.env($|\.)|secret|credential|apikey|api_key|appsettings.*\.json$|\.pem$|\.pfx$)'; then
  MSG="[MAGIA] Advertencia: '$FILE_PATH' coincide con un patrón de archivo sensible (credenciales/config de proveedores). Verificar que no se agreguen secretos ni datos reales de clientes. Si este caso de uso es Medio/Alto, completar templates/ficha-caso-de-uso.md antes de continuar."
  if [ "$MODE" = "block" ]; then
    echo "$MSG" >&2
    exit 2
  else
    echo "$MSG" >&2
    exit 0
  fi
fi

exit 0
