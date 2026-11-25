# FC-LAB-002 · DNS Footprinting con nslookup y dig

| Campo | Descripción / dato requerido |
|---|---|
| Identificador | FC-LAB-002 |
| Nombre y versión | DNS Footprinting con nslookup y dig · v1.0 · noviembre de 2026 |
| Objetivo | Inventariar la información DNS pública de un dominio autorizado y verificar que la transferencia de zona está restringida. |
| Dominio y fase | D02 Reconocimiento y OSINT · fase 03 Identificación |
| Roles | Ejecutor: analista ofensivo · Defensor: analista defensivo · Revisor: evaluador |
| Entorno y autorización | Dominio propio o autorizado por escrito; para practicar la transferencia de zona se puede usar zonetransfer.me, dominio público creado con ese fin. Autorización escrita requerida antes de ejecutar. |
| Entradas | Nombre del dominio, servidor DNS autoritativo y resolvedor definido (por ejemplo 1.1.1.1). |
| Procedimiento | Ver [procedimiento.md](procedimiento.md) |
| Evidencias | `evidencias/`, registradas en el anexo C con SHA-256 |
| Criterio de aceptación | Inventario idéntico en dos ejecuciones; la transferencia de zona (AXFR) contra el dominio evaluado es rechazada. |
| Análisis defensivo | Restringir AXFR a servidores secundarios autorizados, retirar registros TXT o CNAME innecesarios y revisar qué revela cada registro. |
| Resultado | Ver [resultados.md](resultados.md) |

Enfoque: Ofensivo controlado

## Casos de prueba

| ID caso | Objetivo | Resultado esperado |
|---|---|---|
| CP-002-01 | Enumerar registros A, AAAA, MX, NS, TXT y SOA | Inventario documentado |
| CP-002-02 | Comprobar la restricción de transferencia de zona | AXFR denegada |
| CP-002-03 | Identificar información sensible en registros públicos | Lista de exposiciones con severidad |
