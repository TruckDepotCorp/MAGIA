#!/usr/bin/env bash
# PreToolUse (Bash) — R5 (despliegue sin gate) y R8 (no tocar el Core por shell).
# Patrones de despliegue extra: .magia/local/deploy-patterns.txt (grep -E).
. "$(dirname "$0")/lib.sh"
CMD="$(json_str command)"
[ -z "$CMD" ] && exit 0

if printf '%s' "$CMD" | grep -Eq '(>|>>|tee|sed -i|rm|mv|cp|chmod)[^|;&]*(\.magia/core|magia\.lock|\.magia/reports/gate\.json)'; then
  magia_violation R8 dura "Comando bloqueado: intenta modificar el Core de MAGIA o gate.json por shell."
fi

PATTERNS='az (webapp|functionapp|containerapp|aks) .*(deploy|up|update)|az deployment|kubectl (apply|rollout)|helm (upgrade|install)|terraform apply|docker push|git push .*(--force|-f)( |$)'
EXTRA="$ROOT/.magia/local/deploy-patterns.txt"
if [ -f "$EXTRA" ]; then
  X="$(grep -v '^[[:space:]]*#' "$EXTRA" | grep -v '^[[:space:]]*$' | paste -sd'|' -)"
  [ -n "$X" ] && PATTERNS="$PATTERNS|$X"
fi

if printf '%s' "$CMD" | grep -Eq "$PATTERNS"; then
  GATE="$ROOT/.magia/reports/gate.json"
  HEAD="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null)"
  if [ -f "$GATE" ] && [ -n "$HEAD" ] && grep -q "\"commit\"[[:space:]]*:[[:space:]]*\"$HEAD\"" "$GATE"; then
    exit 0
  fi
  SEV=dura; [ "$RISK" = "bajo" ] && SEV=blanda
  magia_violation R5 "$SEV" "Despliegue bloqueado: no hay gate aprobado para el commit actual. Ejecuta /magia-gate (o 'bash .magia/core/scripts/check.sh gate') y la skill checklist-pre-deploy; el visto bueno final es humano."
fi
exit 0
