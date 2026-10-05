#!/usr/bin/env bash
# PreToolUse (Read|Grep|Glob) — R2 y R6. Bloquea lectura de .env*, secretos y
# rutas listadas en .magia/local/restringido.txt (un patrón grep -E por línea).
. "$(dirname "$0")/lib.sh"
P="$(file_path)"
[ -z "$P" ] && P="$(json_str path)"
[ -z "$P" ] && exit 0

if printf '%s' "$P" | grep -Eiq '(^|/)\.env($|\.)|(^|/)secrets?(/|$)|\.(pem|pfx|key)$'; then
  magia_violation R6 dura "Lectura de '$P' bloqueada: archivo de secretos. Las credenciales viven en el vault corporativo; pide a una persona el dato que necesitas."
fi
LIST="$ROOT/.magia/local/restringido.txt"
if [ -f "$LIST" ]; then
  while IFS= read -r pat; do
    case "$pat" in ''|\#*) continue;; esac
    if printf '%s' "$P" | grep -Eiq -- "$pat"; then
      magia_violation R2 dura "Lectura de '$P' bloqueada: ruta clasificada 'restringido' (patrón '$pat'). Usa datos sintéticos o escala al comité (skill magia-data-shield)."
    fi
  done < "$LIST"
fi
exit 0
