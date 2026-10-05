#!/usr/bin/env bash
# PreToolUse (Write|Edit|MultiEdit) — R8, R5 y R6.
. "$(dirname "$0")/lib.sh"
P="$(file_path)"
[ -z "$P" ] && exit 0

if printf '%s' "$P" | grep -Eq '(^|/)(\.magia/core/|magia\.lock$)'; then
  magia_violation R8 dura "Escritura en '$P' bloqueada: el Core de MAGIA es inmutable. Para cambiarlo, propone un PR en el repo fuente de MAGIA o una excepción firmada (.magia/exceptions/)."
fi
if printf '%s' "$P" | grep -Eq '(^|/)\.magia/reports/gate\.json$'; then
  magia_violation R5 dura "No se puede escribir gate.json a mano: lo genera 'bash .magia/core/scripts/check.sh gate' cuando todo está en verde."
fi
if printf '%s' "$P" | grep -Eiq '(^|/)\.env($|\.)|(^|/)secrets?(/|$)|credential|apikey|api_key|appsettings.*\.json$|\.(pem|pfx)$'; then
  magia_violation R6 blanda "'$P' coincide con un patrón de archivo sensible (credenciales/config de proveedores). Verifica que no se agreguen secretos ni datos reales; si el caso es Medio/Alto completa la ficha de diligencia."
fi
exit 0
