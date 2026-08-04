# CLAUDE.md — Base MAGIA v0.1

> Copiar este archivo a la raíz de cada repo de producto que adopte MAGIA.
> Editar solo la sección "Específico de este repo" — el resto son reglas
> globales de gobernanza que no deben modificarse sin pasar por el comité
> (ver `magia-framework/docs/03-gobernanza-repositorio.md`).
>
> Fuente: `magia-framework` versión `[VERSION]`. No editar reglas globales
> localmente — proponer el cambio como PR en el repo fuente.

## Reglas globales de gobernanza (no negociables)

- Nunca usar un modelo o proveedor de IA que no esté en la lista de
  aprobados: **Anthropic (Claude Code)**. Ningún otro proveedor/modelo está
  aprobado por ahora — si un caso de uso lo requiere, escalar al comité de
  gobernanza antes de usarlo (ver `magia-framework/docs/01-plan-tecnico-fase1.md`,
  sección de roles).
- Nunca incluir secretos, credenciales, tokens ni datos de clientes reales
  en prompts, fixtures de prueba, o archivos de configuración versionados.
- Todo caso de uso clasificado como **riesgo medio o alto** (ver matriz de
  riesgo en `magia-framework/docs/00-plan-metodologico-4D.md`) debe pasar
  por la ficha de diligencia (`skills/ficha-caso-de-uso`) antes de
  implementarse.
- Todo cambio en prompts o configuración de modelo que afecte producción
  debe pasar por el pipeline de evals antes de mergear.
- Ningún componente de IA se despliega a producción sin pasar la compuerta
  de despliegue (ver checklist de diligencia).

## Cuándo escalar a un humano

- Si una tarea toca datos personales (PII) y no hay una Rule específica que
  la cubra.
- Si una acción es irreversible (borrado permanente, envío de comunicación
  a clientes, cambios de facturación).
- Si el nivel de riesgo del caso de uso no está claro.

## Específico de este repo

`[por definir: contexto del repo — stack, dominio, contactos del equipo]`

- Stack: `[por definir]`
- Dominio / dueño del producto: `[por definir]`
- Nivel de riesgo general del repo: `[por definir: bajo / medio / alto]`
- Rules activas en este repo: ver `.claude/rules/`
- Skills activas en este repo: ver `.claude/skills/`

---
**Owner de este archivo:** `[por definir]` · **Versión de MAGIA:** `0.1.0`
