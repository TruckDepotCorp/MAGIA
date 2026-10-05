#!/usr/bin/env bash
# PostToolUse (Write|Edit) — recuerda correr los evals cuando se toca una ruta
# de prompts/IA (solo si aiInProduct=true). No los ejecuta (pueden ser lentos
# y costosos): lo hace magia-evals / /magia-eval.
# Rutas extra: .magia/local/prompt-paths.txt (grep -E, una por línea).
. "$(dirname "$0")/lib.sh"
grep -q '"aiInProduct"[[:space:]]*:[[:space:]]*true' "$CONFIG" 2>/dev/null || exit 0
P="$(file_path)"
[ -z "$P" ] && exit 0
PATS='(^|/)(prompts?|ai-features|ai/prompts)/'
EXTRA="$ROOT/.magia/local/prompt-paths.txt"
if [ -f "$EXTRA" ]; then
  X="$(grep -v '^[[:space:]]*#' "$EXTRA" | grep -v '^[[:space:]]*$' | paste -sd'|' -)"
  [ -n "$X" ] && PATS="$PATS|$X"
fi
if printf '%s' "$P" | grep -Eiq "$PATS"; then
  printf '{"systemMessage":"[MAGIA R1/R4] %s toca prompts o lógica de IA: actualiza evals/golden-set.jsonl y corre /magia-eval antes de dar el cambio por terminado."}\n' "$P"
fi
exit 0
