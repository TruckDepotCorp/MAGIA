#!/usr/bin/env bash
# PostToolUse (Write|Edit|MultiEdit) — R6. Escanea el archivo recién escrito
# en busca de patrones de llaves conocidas. exit 2 devuelve el error al agente.
. "$(dirname "$0")/lib.sh"
P="$(file_path)"
[ -z "$P" ] && exit 0
F="$ROOT/$P"
[ -f "$F" ] || exit 0

PATTERNS="(AKIA[0-9A-Z]{16}|sk-ant-[A-Za-z0-9_-]{20,}|gh[pousr]_[A-Za-z0-9]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|AccountKey=[A-Za-z0-9+/=]{20,}|(password|passwd|pwd|secret|api[_-]?key|token)[\"' ]*[:=][\"' ]*[A-Za-z0-9/+_.-]{12,})"
HIT="$(grep -Eio -m1 "$PATTERNS" "$F" 2>/dev/null | head -1)"
if [ -n "$HIT" ]; then
  magia_violation R6 dura "Posible secreto en '$P' (coincide con '${HIT:0:12}...'). Elimínalo, usa el vault/variables de entorno y rota la credencial si ya se expuso."
fi
exit 0
