#!/usr/bin/env bash
# Utilidades comunes de los hooks MAGIA (se instala en .magia/core/hooks/).
# Lee el JSON del hook por stdin (formato verificado contra la documentación
# oficial de Claude Code, 2026-10-05: tool_name, tool_input.{file_path,command}).
# Sin dependencias: solo bash, grep, sed (funciona en Git Bash de Windows).
#
# Modo de enforcement (decisión híbrida, core/REGLAS-CORE.md):
#   advertencia (defecto) -> bloquea solo violaciones "duras"
#   bloqueo               -> bloquea también las "blandas"
# Orden: variable MAGIA_MODO > "enforcement" de magia.config.json > advertencia.

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
CONFIG="$ROOT/magia.config.json"
ROOT_N="$(printf '%s' "$ROOT" | sed 's#\\#/#g')"
INPUT="$(cat)"

# Primer valor string de la clave $1 en el JSON de stdin (soporta \" escapadas).
json_str() {
  printf '%s' "$INPUT" | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"\\\\]\|\\\\.\)*\"" | head -1 \
    | sed "s/^\"$1\"[[:space:]]*:[[:space:]]*\"//;s/\"$//"
}

# Primer valor string de la clave $1 en magia.config.json.
cfg_str() {
  [ -f "$CONFIG" ] || return 0
  grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" "$CONFIG" | head -1 \
    | sed "s/^\"$1\"[[:space:]]*:[[:space:]]*\"//;s/\"$//"
}

MODE="${MAGIA_MODO:-$(cfg_str enforcement)}"
[ "$MODE" = "bloqueo" ] || MODE="advertencia"
RISK="$(cfg_str risk)"

# Ruta del archivo de la herramienta, normalizada a / y relativa al proyecto.
file_path() {
  local p
  p="$(json_str file_path)"
  p="$(printf '%s' "$p" | sed 's#\\\\#/#g;s#\\#/#g')"
  p="${p#"$ROOT_N"/}"
  printf '%s' "${p#./}"
}

# magia_violation <regla> <dura|blanda> <mensaje>
# Dura -> exit 2 siempre. Blanda -> exit 2 solo en modo bloqueo; si no, avisa.
magia_violation() {
  local msg="[MAGIA $1] $3"
  if [ "$2" = "dura" ] || [ "$MODE" = "bloqueo" ]; then
    printf '%s\n' "$msg" >&2
    exit 2
  fi
  printf '{"systemMessage":"%s (modo advertencia: no bloquea)"}\n' \
    "$(printf '%s' "$msg" | sed 's/\\/\\\\/g;s/"/\\"/g')"
  exit 0
}
