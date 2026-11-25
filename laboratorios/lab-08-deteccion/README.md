# FC-LAB-008 · Detección y análisis de registros

| Campo | Descripción / dato requerido |
|---|---|
| Identificador | FC-LAB-008 |
| Nombre y versión | Detección y análisis de registros · v1.0 · noviembre de 2026 |
| Objetivo | Implementar registro de acceso y límite de tasa delante de una aplicación web, y comprobar con reglas de detección que una actividad automatizada (la clonación de FC-LAB-003) se detecta sin generar falsos positivos en la navegación normal |
| Dominio y fase | D07 Detección y respuesta · fases 05 Mitigación y 06 Verificación |
| Roles | Defensor: analista defensivo · Ejecutor del re-test: analista ofensivo · Revisor: coordinador Purple Team |
| Entorno y autorización | Kali Linux propio; OWASP Juice Shop y proxy nginx en contenedores, ambos solo en 127.0.0.1. Autorización escrita requerida antes de ejecutar |
| Entradas | Configuración `nginx.conf` del laboratorio; navegación de línea base; clonación HTTrack con el agente `FORTIS-LAB03` |
| Procedimiento | Ver [procedimiento.md](procedimiento.md) · script `scripts/kali/lab08.sh` |
| Evidencias | `evidencias/`, registradas en el anexo C con SHA-256 |
| Criterio de aceptación | La clonación genera al menos una alerta (R1 o R2), la navegación normal no genera ninguna y el límite de tasa queda registrado |
| Análisis defensivo | Registro centralizado de acceso HTTP, reglas por agente y por volumen, límite de tasa por IP |
| Resultado | Ver [resultados.md](resultados.md) |

Enfoque: Defensivo / Purple Team. Este laboratorio es el **re-test de CP-003-03** y verifica la acción **M-003-03**.

> Nota: el catálogo del documento proponía Sysmon/Wazuh para este laboratorio. La versión 1.0 usa registros de nginx
> analizados con reglas propias porque corre completa en la VM de Kali; integrar Wazuh queda como mejora para la v2.0.

## Casos de prueba

| ID caso | Objetivo | Resultado esperado |
|---|---|---|
| CP-008-01 | Registrar la navegación normal (línea base) | Solicitudes visibles en el registro, sin alertas |
| CP-008-02 | Detectar la clonación automatizada con reglas R1 (agente) y R2 (volumen) | Al menos una regla alerta |
| CP-008-03 | Verificar el límite de tasa | Respuestas 429 registradas durante la clonación |
