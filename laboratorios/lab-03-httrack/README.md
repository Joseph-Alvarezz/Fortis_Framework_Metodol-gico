# FC-LAB-003 · Clonación controlada con HTTrack

| Campo | Descripción / dato requerido |
|---|---|
| Identificador | FC-LAB-003 |
| Nombre y versión | Clonación controlada con HTTrack · v1.0 · noviembre de 2026 |
| Objetivo | Obtener una copia local de un sitio autorizado para identificar recursos expuestos (comentarios, rutas, archivos) sin interactuar repetidamente con el servidor. |
| Dominio y fase | D03 Seguridad web · fase 03 Identificación |
| Roles | Ejecutor: analista ofensivo · Defensor: analista defensivo |
| Entorno y autorización | Sitio propio, sitio de entrenamiento o la instancia local de OWASP Juice Shop (http://127.0.0.1:3000). Autorización escrita requerida antes de ejecutar. |
| Entradas | URL autorizada, profundidad máxima y límite de velocidad acordados en las reglas de compromiso. |
| Procedimiento | Ver [procedimiento.md](procedimiento.md) |
| Evidencias | `evidencias/`, registradas en el anexo C con SHA-256 |
| Criterio de aceptación | Copia local generada dentro de los límites acordados y lista de recursos expuestos clasificada. |
| Análisis defensivo | Eliminar comentarios y archivos de respaldo del servidor, revisar robots.txt (no es un control de acceso) y limitar la tasa de solicitudes. |
| Resultado | Ver [resultados.md](resultados.md) |

Enfoque: Ofensivo / defensivo

## Casos de prueba

| ID caso | Objetivo | Resultado esperado |
|---|---|---|
| CP-003-01 | Clonar el sitio respetando límites de profundidad y velocidad | Copia local completa |
| CP-003-02 | Buscar comentarios, rutas y archivos sensibles en la copia | Lista de recursos expuestos |
| CP-003-03 | Verificar si el servidor registró la clonación | Evidencia en registros (detección) |
