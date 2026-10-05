---
id: magia-reglas-core
version: 1.0.0
owner: Comité de gobernanza de MAGIA
immutable: true
origen: adaptadas de las Rules R1–R9 de la SPEC del handoff (docs/referencia-spec/SPEC.md §10)
---

# Reglas Core R1–R9

Restricciones corporativas que se instalan en `.magia/core/` de todo repo y
no se debilitan localmente. No confundir con las **Rules por ruta** de
`rules/` (`.claude/rules/`), que son específicas de un repo y solo pueden
**agregar** restricciones, nunca quitar una Regla Core.

**Precedencia:** Core > Local (`.magia/local/`, `.claude/rules/`) > Generada
(`MAGIA.md`, Skills adaptadas). Lo local solo agrega.

## Postura de enforcement (decisión híbrida)

Cada regla declara su **severidad** y qué mecanismo la hace cumplir **hoy**
con el kit (sin CLI ni runtime), y cuál sería el mecanismo objetivo cuando
exista (`docs/13-roadmap-motor-de-valor.md`).

| Severidad | Comportamiento | Cuándo |
|---|---|---|
| **dura** | El hook bloquea siempre (exit 2), sin importar el modo | Violación inequívoca y verificable por patrón: secretos, `.env`, editar el Core, desplegar sin gate |
| **blanda** | Advierte en `advertencia`; bloquea en `bloqueo` | Requiere criterio: PII a un modelo, patrón de arquitectura, grounding |

El modo se fija por repo con `enforcement` en `magia.config.json` (o la
variable `MAGIA_MODO`). Se arranca en `advertencia` y se endurece con el
equipo, no antes (`docs/01-plan-tecnico-fase1.md`, riesgos técnicos).
Cualquier desviación de una regla dura o blanda exige una **excepción
firmada** (sección final).

Las reglas R1, R4 y R7 aplican a repos con **IA dentro del producto**
(`aiInProduct: true`: el software llama a un modelo en producción). Las
demás aplican a todo repo, incluido el uso de IA solo como asistente de
desarrollo.

---

## R1 — Nada generativo sin fuente verificable
Ningún output generativo se muestra a un usuario en riesgo medio/alto sin
fuente verificable y citada. · **Severidad:** blanda
- **Hoy:** Skill `magia-grounding`; criterio `grounded` en la rúbrica de
  evals; revisión por el agente `magia-reviewer`.
- **Objetivo:** guarda `grounding.require()` en el runtime + citas nativas.

## R2 — Datos personales protegidos
Prohibido enviar datos personales a un modelo sin anonimizar o sin
consentimiento; prohibido leer rutas clasificadas `restringido`.
· **Severidad:** dura para lectura de rutas restringidas; blanda para el resto
- **Hoy:** hook `guard-read` (lista `.magia/local/restringido.txt`); Skill
  `magia-data-shield`; Rules por ruta del repo (ej.
  `rules/example-pii-terceros-rrhh.md`); criterio `no_leak` en evals.
- **Objetivo:** `dataShield.redact()` obligatorio antes de cada llamada.

## R3 — Solo proveedores y modelos aprobados
Todo modelo o proveedor requiere aprobación del comité. Aplica al **modelo
invocado por debajo**, no solo al nombre de la herramienta (ej. Cursor).
Lista vigente: `.magia/core/proveedores-aprobados.txt`. · **Severidad:** blanda
- **Hoy:** `check.sh` valida `providers` de `magia.config.json` contra la
  lista; el agente `magia-reviewer` revisa dependencias e IDs de modelo del
  diff.
- **Objetivo:** escaneo automático de dependencias LLM en CI.

## R4 — Fallback humano o mensaje de incertidumbre
Toda funcionalidad de IA tiene fallback humano o responde "no sé".
· **Severidad:** blanda
- **Hoy:** casos `unknown` obligatorios en el golden set (`magia-evals`);
  revisión por `magia-reviewer`.
- **Objetivo:** `hallucinationGuard.check()` en el runtime.

## R5 — Ningún despliegue sin gate aprobado
· **Severidad:** dura en riesgo medio/alto; blanda en riesgo bajo
- **Hoy:** el hook `guard-bash` bloquea comandos de despliegue sin
  `.magia/reports/gate.json` vigente para el commit actual
  (`/magia-gate` o `check.sh gate`); job `magia-gate` requerido en la rama
  protegida; Skill `checklist-pre-deploy`.
- **Objetivo:** gate completo con evals, red-team y aprobación firmada.

## R6 — Credenciales solo desde el vault corporativo
Ningún secreto en el repo, en `magia.config.json`, ni en prompts.
· **Severidad:** dura
- **Hoy:** hooks `guard-read` (`.env*`, `secrets/`) y `scan-secrets` (patrones
  de llaves tras cada Write/Edit); `permissions.deny`; secret scanning en CI.
  Vault concreto: `[por definir: vault corporativo vigente]`.
- **Objetivo:** escaneo por entropía y rotación auditada.

## R7 — Divulgación de IA ante clientes
Toda interacción generativa con un cliente externo se identifica como
asistida por IA. · **Severidad:** blanda
- **Hoy:** criterio `disclosure` en evals; revisión por `magia-reviewer`.
- **Objetivo:** `brandVoice.disclose()` en el runtime.

## R8 — El Core no se desactiva ni se edita
Ninguna Skill, Regla ni hook Core se desactiva sin aprobación del comité.
· **Severidad:** dura
- **Hoy:** `permissions.deny` y hook `guard-write` sobre `.magia/core/**`,
  `magia.lock` y `gate.json`; `check.sh` verifica los hashes SHA-256 de
  `magia.lock` y que las Skills requeridas estén presentes.
- **Objetivo:** `magia check` como job requerido en CI.

## R9 — Conectores aprobados con permisos mínimos
Los agentes acceden a sistemas corporativos solo vía conectores (MCP)
aprobados, con lectura por defecto. · **Severidad:** blanda
- **Hoy:** `check.sh` compara `.mcp.json` con `.magia/local/mcp-allowlist.txt`;
  estándar de MCP en `docs/07-arquitectura-referencia.md`. Allowlist inicial:
  `[por definir: servidores MCP aprobados por el comité]`.
- **Objetivo:** validación de scopes máximos por servidor.

---

## Excepciones

Una desviación solo es válida si hay un archivo
`.magia/exceptions/EXC-<aaaa>-<nnn>.md` con: `rule`, `scope`, `reason`,
`mitigations`, `expires` (máximo 90 días), `approvedBy` (consenso del comité)
y el commit firmado que la introduce. `check.sh` rechaza excepciones
vencidas. La firma criptográfica estricta queda como mejora
(`[por definir: mecanismo de firma — decisión D8 de la SPEC]`).
