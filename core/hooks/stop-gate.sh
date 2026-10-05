#!/usr/bin/env bash
# Stop — impide cerrar el turno con trabajo sin verificar (verificación
# proporcional). En modo bloqueo bloquea (máx. 2 veces por sesión: guarda
# anti-bucle propia, porque stop_hook_active no está confirmado en la doc);
# en advertencia solo avisa. "Sin verificar" = hay cambios de código sin
# commitear más nuevos que el último .magia/reports/verify-*.md.
. "$(dirname "$0")/lib.sh"
printf '%s' "$INPUT" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0

CHANGED="$(git -C "$ROOT" status --porcelain 2>/dev/null | sed 's/^...//' \
  | grep -Ev '^(docs/|\.magia/reports/|.*\.md$)' | head -20)"
[ -z "$CHANGED" ] && exit 0

NEWEST_VERIFY="$(ls -t "$ROOT"/.magia/reports/verify-*.md 2>/dev/null | head -1)"
if [ -n "$NEWEST_VERIFY" ]; then
  STALE=0
  while IFS= read -r f; do
    [ -f "$ROOT/$f" ] && [ "$ROOT/$f" -nt "$NEWEST_VERIFY" ] && STALE=1
  done <<< "$CHANGED"
  [ "$STALE" = 0 ] && exit 0
fi

SID="$(json_str session_id)"
CNT="$ROOT/.magia/reports/.stop-$SID"
N=$(cat "$CNT" 2>/dev/null || echo 0)
MSG="Hay cambios de código sin verificar. Ejecuta la skill magia-verify (pruebas, check.sh, evals si aplican) y escribe .magia/reports/verify-<id>.md antes de terminar."
if [ "$MODE" = "bloqueo" ] && [ "$N" -lt 2 ]; then
  mkdir -p "$ROOT/.magia/reports" && echo $((N+1)) > "$CNT"
  printf '[MAGIA R5] %s\n' "$MSG" >&2
  exit 2
fi
printf '{"systemMessage":"[MAGIA] %s"}\n' "$MSG"
exit 0
