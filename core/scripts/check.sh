#!/usr/bin/env bash
# check.sh — validador de la instalación MAGIA (equivalente sin CLI de
# `magia check` / `magia gate`). Solo bash/grep/sed/sha256sum.
#
#   check.sh [check]   valida config, Core (lock), Skills requeridas, settings,
#                      contexto, evals y excepciones. Exit 0 ok · 2 violación.
#   check.sh lock      (re)genera magia.lock con los SHA-256 de .magia/core/.
#   check.sh gate      check + pruebas + evals configurados; si todo pasa y el
#                      árbol está limpio, escribe .magia/reports/gate.json
#                      atado al commit actual (lo exige el hook guard-bash, R5).
#
# Severidad: "dura" siempre es error; "blanda" es advertencia salvo que
# enforcement=bloqueo (magia.config.json o MAGIA_MODO). Ver core/REGLAS-CORE.md.

ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$ROOT" || exit 1
CONFIG="magia.config.json"
CORE=".magia/core"
ERR=0; WARN=0

cfg_str() { [ -f "$CONFIG" ] && grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" "$CONFIG" | head -1 | sed "s/^\"$1\"[[:space:]]*:[[:space:]]*\"//;s/\"$//"; }
cfg_bool() { [ -f "$CONFIG" ] && grep -q "\"$1\"[[:space:]]*:[[:space:]]*true" "$CONFIG"; }

MODE="${MAGIA_MODO:-$(cfg_str enforcement)}"; [ "$MODE" = "bloqueo" ] || MODE="advertencia"
RISK="$(cfg_str risk)"; AUTON="$(cfg_str autonomy)"
AUTON_N="${AUTON#NM-}"

dura()   { echo "ERROR  [$1] $2"; ERR=$((ERR+1)); }
blanda() { if [ "$MODE" = "bloqueo" ]; then echo "ERROR  [$1] $2"; ERR=$((ERR+1)); else echo "AVISO  [$1] $2"; WARN=$((WARN+1)); fi; }

sha() { tr -d '\015' < "$1" | sha256sum | cut -d' ' -f1; }  # sin CR: estable entre LF (CI) y CRLF (autocrlf en Windows)
PH='[{][{][A-Za-z_]'  # marcador de plantilla sin resolver, p. ej. PROJECT_NAME entre dobles llaves

do_lock() {
  [ -d "$CORE" ] || { echo "No existe $CORE"; exit 1; }
  { echo "# magia.lock — SHA-256 de .magia/core/. No editar a mano (R8)."
    echo "# magia-version: $(cfg_str version)"
    find "$CORE" -type f | LC_ALL=C sort | while read -r f; do echo "$(sha "$f")  $f"; done
  } > magia.lock
  echo "magia.lock generado ($(grep -vc '^#' magia.lock) archivos)."
}

do_check() {
  # 1. Config
  if [ ! -f "$CONFIG" ]; then dura R8 "falta magia.config.json (ejecuta /magia-instalar)"; return; fi
  for k in version profile risk autonomy customerFacing aiInProduct commands; do
    grep -q "\"$k\"" "$CONFIG" || dura R8 "magia.config.json: falta el campo '$k'"
  done
  case "$RISK" in bajo|medio|alto) ;; *) dura R8 "risk inválido: '$RISK' (bajo|medio|alto)";; esac
  case "$AUTON" in NM-1|NM-2|NM-3|NM-4) ;; *) dura R8 "autonomy inválida: '$AUTON' (NM-1..NM-4)";; esac
  [ "$AUTON" = "NM-4" ] && blanda R8 "NM-4 exige comité + excepción firmada y auditoría mensual (docs/05-matriz-riesgo.md)"

  # 2. Core inmutable (R8)
  for f in CONSTITUCION.md REGLAS-CORE.md proveedores-aprobados.txt; do
    [ -f "$CORE/$f" ] || dura R8 "falta $CORE/$f"
  done
  if [ ! -f magia.lock ]; then
    dura R8 "falta magia.lock (ejecuta: bash $CORE/scripts/check.sh lock)"
  else
    while read -r h f; do
      if [ ! -f "$f" ]; then dura R8 "Core: falta $f"
      elif [ "$(sha "$f")" != "$h" ]; then dura R8 "Core modificado: $f"; fi
    done < <(grep -v '^#' magia.lock)
    while read -r f; do
      grep -q "  $f\$" magia.lock || dura R8 "Core: archivo no registrado en magia.lock: $f"
    done < <(find "$CORE" -type f)
  fi

  # 3. Proveedores (R3)
  PROV="$(grep -o '"providers"[^]]*\]' "$CONFIG" | grep -o '"[a-z0-9_-]*"' | tr -d '"' | grep -vx providers)"
  [ -z "$PROV" ] && blanda R3 "magia.config.json no declara 'providers'"
  for p in $PROV; do
    grep -qx "$p" "$CORE/proveedores-aprobados.txt" 2>/dev/null || blanda R3 "proveedor '$p' no está en la lista aprobada por el comité"
  done

  # 4. Skills requeridas (R8)
  REQ="magia-context magia-verify magia-data-shield magia-diligencia checklist-pre-deploy"
  [ "$RISK" != "bajo" ] && REQ="$REQ ficha-caso-de-uso"
  if cfg_bool aiInProduct; then
    REQ="$REQ elegir-patron-ia magia-evals"
    { [ "$RISK" != "bajo" ] || [ "${AUTON_N:-1}" -ge 2 ]; } 2>/dev/null && REQ="$REQ magia-grounding"
  fi
  if { [ "$RISK" = "alto" ] && cfg_bool aiInProduct; } || [ "${AUTON_N:-1}" -ge 3 ] 2>/dev/null; then REQ="$REQ magia-red-team"; fi
  for s in $REQ; do
    [ -f ".claude/skills/$s/SKILL.md" ] || dura R8 "Skill requerida ausente: .claude/skills/$s/SKILL.md"
  done

  # 5. settings.json: hooks y deny
  if [ -f .claude/settings.json ]; then
    grep -q "\.magia/core/hooks" .claude/settings.json || dura R8 ".claude/settings.json no registra los hooks de .magia/core/hooks"
    grep -q "\.magia/core" .claude/settings.json && grep -q '"deny"' .claude/settings.json || dura R8 ".claude/settings.json: falta permissions.deny para .magia/core/**"
  else dura R8 "falta .claude/settings.json"; fi

  # 6. Contexto
  if [ -f MAGIA.md ]; then
    n=$(wc -l < MAGIA.md); [ "$n" -gt 300 ] && blanda CTX "MAGIA.md tiene $n líneas (máx. 300): mueve detalle a Skills"
    grep -Eq "$PH" MAGIA.md && dura CTX "MAGIA.md tiene marcadores de plantilla sin resolver"
    p=$(grep -c '\[por definir' MAGIA.md); [ "$p" -gt 0 ] && echo "INFO   MAGIA.md tiene $p '[por definir]' pendientes"
  else dura CTX "falta MAGIA.md"; fi
  if [ -f CLAUDE.md ]; then
    grep -q '@MAGIA.md' CLAUDE.md || dura CTX "CLAUDE.md no importa @MAGIA.md"
    n=$(wc -l < CLAUDE.md); [ "$n" -gt 150 ] && blanda CTX "CLAUDE.md tiene $n líneas (recomendado ≤ 150)"
  else dura CTX "falta CLAUDE.md"; fi
  UNRES="$(grep -rEl "$PH" .claude/skills .claude/agents .claude/commands 2>/dev/null | tr '\n' ' ')"
  [ -n "$UNRES" ] && dura CTX "marcadores de plantilla sin resolver en: $UNRES"

  # 7. Evals (R1/R4) — solo si hay IA en el producto
  if cfg_bool aiInProduct; then
    case "$RISK" in bajo) MIN=20;; medio) MIN=50;; *) MIN=100;; esac
    N=0; [ -f evals/golden-set.jsonl ] && N=$(grep -c . evals/golden-set.jsonl)
    [ "$N" -lt "$MIN" ] && blanda R4 "golden set con $N casos; mínimo propuesto para riesgo $RISK: $MIN (docs/08-estandares-desarrollo.md)"
    [ "$N" -gt 0 ] && ! grep -q '"type":"unknown"' evals/golden-set.jsonl && blanda R4 "el golden set no tiene casos 'unknown' (fallback, R4)"
  fi

  # 8. MCP (R9)
  if [ -f .mcp.json ] && [ ! -f .magia/local/mcp-allowlist.txt ]; then
    blanda R9 ".mcp.json existe pero falta .magia/local/mcp-allowlist.txt (allowlist aprobada por el comité)"
  fi

  # 9. Excepciones vencidas
  TODAY="$(date +%Y-%m-%d)"
  for e in .magia/exceptions/EXC-*.md; do
    [ -f "$e" ] || continue
    exp="$(grep -m1 -o 'expires:[[:space:]]*[0-9-]*' "$e" | sed 's/expires:[[:space:]]*//')"
    [ -z "$exp" ] && { dura R8 "excepción sin 'expires': $e"; continue; }
    [[ "$exp" < "$TODAY" ]] && dura R8 "excepción vencida ($exp): $e"
  done

  # 10. Modo de permiso de Claude Code según autonomía (docs/12, AF10/AF13)
  if [ -f .claude/settings.json ]; then
    PM="$(grep -o '"defaultMode"[[:space:]]*:[[:space:]]*"[^"]*"' .claude/settings.json | head -1 | sed 's/.*:[[:space:]]*"//;s/"$//')"
    case "$PM" in
      ''|default|plan) ;;
      bypassPermissions|dontAsk) dura R8 "permissions.defaultMode='$PM' no está permitido en repos de producto (solo contenedor aislado)";;
      acceptEdits) [ "${AUTON_N:-1}" -ge 2 ] 2>/dev/null || blanda R8 "defaultMode='acceptEdits' es más permisivo de lo que admite $AUTON (NM-2+ con hooks del Core activos)";;
      auto) [ "${AUTON_N:-1}" -ge 4 ] 2>/dev/null || blanda R8 "defaultMode='auto' es más permisivo de lo que admite $AUTON (solo NM-4, con excepción firmada)";;
      *) blanda R8 "defaultMode desconocido: '$PM'";;
    esac
  fi

  # 11. Plan de Delegación: modo (automatizacion|aumentacion|agencia) y verificación (AF14)
  DEL="docs/magia/delegation.md"
  if [ -f "$DEL" ]; then
    if grep -iq '^|.*|[[:space:]]*agencia[[:space:]]*|' "$DEL"; then
      [ "${AUTON_N:-1}" -ge 2 ] 2>/dev/null || blanda R8 "$DEL tiene tareas en modo agencia pero el repo es $AUTON (agencia exige NM-2+ con sandbox)"
      while IFS='|' read -r _ tarea resp modo plat porque verif _; do
        mc="$(printf '%s' "$modo" | tr -d ' ' | tr 'A-Z' 'a-z')"
        [ "$mc" = "agencia" ] || continue
        v="$(printf '%s' "$verif" | tr -d ' ')"
        if [ -z "$v" ] || printf '%s' "$verif" | grep -q '\[por definir'; then
          blanda R8 "$DEL: la tarea en modo agencia '$(printf '%s' "$tarea" | sed 's/^ *//;s/ *$//')' no declara cómo se verifica"
        fi
      done < <(grep '^|' "$DEL")
    fi
    grep -iEq 'automatizaci|aumentaci|agencia' "$DEL" || blanda R8 "$DEL no declara el modo (automatización | aumentación | agencia) de ninguna tarea"
  elif ls docs/magia/plans/*.md >/dev/null 2>&1; then
    blanda R8 "hay planes en docs/magia/plans/ pero falta docs/magia/delegation.md (usa /magia-brief)"
  fi
}

summary() {
  echo "----"; echo "MAGIA check: $ERR error(es), $WARN aviso(s) · riesgo=$RISK · autonomía=$AUTON · modo=$MODE"
  [ "$ERR" -eq 0 ]
}

case "${1:-check}" in
  lock) do_lock ;;
  check) do_check; summary || exit 2 ;;
  gate)
    do_check
    if ! summary; then echo "GATE bloqueado: corrige los errores de check."; exit 2; fi
    if [ -n "$(git status --porcelain 2>/dev/null | grep -v '^.. .magia/reports/')" ]; then
      echo "GATE bloqueado: hay cambios sin commitear; el gate se ata al commit."; exit 2
    fi
    for c in test eval; do
      cmd="$(cfg_str "$c")"
      case "$cmd" in ''|*"[por definir"*) echo "AVISO  comando '$c' sin definir en commands: se omite (queda como pendiente)"; continue;; esac
      echo ">> $c: $cmd"
      bash -c "$cmd" || { echo "GATE bloqueado: falló '$c'."; exit 2; }
    done
    mkdir -p .magia/reports
    printf '{"commit":"%s","ts":"%s","risk":"%s","autonomy":"%s","result":"verde"}\n' \
      "$(git rev-parse HEAD)" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$RISK" "$AUTON" > .magia/reports/gate.json
    echo "GATE verde para $(git rev-parse --short HEAD). El visto bueno de despliegue sigue siendo humano (checklist-pre-deploy)."
    ;;
  *) echo "uso: check.sh [check|lock|gate]"; exit 1 ;;
esac
