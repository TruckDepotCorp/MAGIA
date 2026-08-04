#!/usr/bin/env bash
# Hook PostToolUse de referencia (Sprint 4, docs/01-plan-tecnico-fase1.md).
#
# [ADAPTAR] Placeholder: no existe todavía un framework de evals real ni
# un golden dataset en ningún repo (ver docs/08-estandares-desarrollo.md,
# pendiente). Este hook queda como estructura de referencia hasta que
# exista uno — no corre nada real todavía.

INPUT="$(cat)"
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if echo "$FILE_PATH" | grep -Eiq '(prompts?/|ai-features/|ai/prompts/)'; then
  echo "[MAGIA] '$FILE_PATH' toca una carpeta de prompts/features de IA. TODO - [ADAPTAR] correr el golden dataset de evals del repo (ver rules/example-ai-features.md)." >&2
fi

exit 0
