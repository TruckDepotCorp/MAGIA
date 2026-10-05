---
description: Corre el gate completo (check, pruebas, evals), explica cada bloqueo y emite gate.json para el commit actual
---
1. Verifica que no haya cambios sin commitear; si los hay, pide a la persona que los commitee (el gate se ata al commit).
2. Ejecuta `bash .magia/core/scripts/check.sh gate`. Si falla, explica cada error con su Regla, archivo y acción correctiva exacta.
3. Si pasó, aplica la skill `checklist-pre-deploy` (3 compuertas) y la skill `magia-diligencia` si el entregable lo requiere.
4. Reporta el veredicto: "gate en verde para <commit>" solo si `gate.json` se generó. Recuerda que el visto bueno final de despliegue es **humano** y que en riesgo Medio/Alto requiere la aprobación del comité registrada. No escribas `gate.json` a mano: lo bloquean los hooks.
