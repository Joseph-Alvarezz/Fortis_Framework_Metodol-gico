# FC-LAB-007 · Burp Suite

| Campo | Descripción / dato requerido |
|---|---|
| Identificador | FC-LAB-007 |
| Nombre y versión | Burp Suite · v1.0 · noviembre de 2026 |
| Objetivo | Configurar Burp Suite como proxy de interceptación y analizar las solicitudes y respuestas de una aplicación web autorizada. |
| Dominio y fase | D03 Seguridad web / D04 Comunicaciones y APIs · fase 03 Identificación |
| Roles | Ejecutor: analista ofensivo · Defensor: analista defensivo · Revisor: evaluador |
| Entorno y autorización | Burp Suite Community Edition y la instancia local de OWASP Juice Shop (http://127.0.0.1:3000) con dos usuarios de prueba. Autorización escrita requerida antes de ejecutar. |
| Entradas | Dos cuentas sintéticas creadas en la aplicación local (usuario A y usuario B). |
| Procedimiento | Ver [procedimiento.md](procedimiento.md) |
| Evidencias | `evidencias/`, registradas en el anexo C con SHA-256 |
| Criterio de aceptación | Historial HTTP capturado; cabeceras de seguridad evaluadas; prueba de control de acceso documentada con resultado observable. |
| Análisis defensivo | Cabeceras de seguridad (CSP, HSTS, X-Content-Type-Options), validación de autorización en el servidor y registro de accesos denegados. |
| Resultado | Ver [resultados.md](resultados.md) |

Enfoque: Pruebas web

## Casos de prueba

| ID caso | Objetivo | Resultado esperado |
|---|---|---|
| CP-007-01 | Verificar el control de acceso a recursos de la API entre dos usuarios | Respuesta 403 o 404 |
| CP-007-02 | Evaluar las cabeceras de seguridad de las respuestas | Lista de cabeceras presentes / ausentes |
| CP-007-03 | Revisar cookies y tokens de sesión | Atributos Secure, HttpOnly, SameSite evaluados |
