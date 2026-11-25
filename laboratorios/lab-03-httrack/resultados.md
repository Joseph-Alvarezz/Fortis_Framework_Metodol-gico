# Resultados · FC-LAB-003

**Ejecución:** 2026-11-25 18:35:00–18:36:57 UTC · Kali 2026.2 · HTTrack 3.51 · objetivo OWASP Juice Shop 20.4.0 en
`http://127.0.0.1:3000` (contenedor local, imagen `sha256:9eed3be3…`, registrada como EV-JS-00-02).
Integridad de los archivos generados comprobada con `lab03.sha256` (todos `OK`).

## Resumen

| Caso | Resultado observado | Evidencia (ID) | Hallazgo | Severidad | Estado |
|---|---|---|---|---|---|
| CP-003-01 | Copia parcial: 148 archivos, 5.9 MB en 1 min 57 s (profundidad 3, 2 conexiones, 50 KB/s). La clonación se detuvo manualmente con Ctrl + C | EV-003-01-01, 02 | — | — | Cumplido parcialmente |
| CP-003-02 | 40 rutas de API visibles en el código del cliente, incluidas rutas administrativas y de usuarios; `robots.txt` revela `/ftp` | EV-003-02-01 a 03 | H-003-01, H-003-02 | 6 · Medio | Cumplido |
| CP-003-03 | 0 solicitudes del agente `FORTIS-LAB03` en los registros del servidor: la clonación no fue detectable | EV-003-03-01, 02 | H-003-03 | 8 · Alto | No cumple el control |

## CP-003-01 · Clonación

| Dato | Valor |
|---|---|
| Comando | `httrack http://127.0.0.1:3000/ -O ./copia -r3 -c2 -%c2 -A50000 -F FORTIS-LAB03` |
| Archivos / tamaño | 148 / 5.9 MB |
| Estructura | `127.0.0.1_3000/`, `assets/`, `assets/public/`, `media/` |
| Límite | Ejecución detenida a los 2 minutos; los paquetes JavaScript de Juice Shop pesan varios MB y a 50 KB/s la copia completa tardaba más de 5 minutos |

**Mejora aplicada al instrumento:** `lab03.sh` ahora usa 500 KB/s (el objetivo es local), un máximo de 4 minutos
(`-E240`) y muestra el progreso en vivo.

## CP-003-02 · Información expuesta

**Rutas de API en el código del cliente (`main.js`).** Una aplicación de página única entrega al navegador el mapa de su
API. Entre las 40 rutas encontradas:

| Tipo | Rutas |
|---|---|
| Administración | `/rest/admin` |
| Usuarios y credenciales | `/api/Users`, `/rest/user/login`, `/rest/user/reset-password`, `/rest/user/change-password`, `/rest/user/security-question`, `/api/SecurityQuestions`, `/api/SecurityAnswers`, `/rest/user/authentication-details/` |
| Segundo factor | `/rest/2fa/setup`, `/rest/2fa/verify`, `/rest/2fa/status`, `/rest/2fa/disable` |
| Pagos y pedidos | `/rest/wallet/balance`, `/rest/basket/`, `/rest/order-history`, `/rest/track-order`, `/rest/deluxe-membership` |

Conocer estas rutas no es una vulnerabilidad por sí mismo; el riesgo depende de que el servidor valide la autorización
en cada una. Se verifica en FC-LAB-007 (CP-007-01).

**robots.txt.** Contiene `Disallow: /ftp`. `robots.txt` es una indicación para buscadores, no un control de acceso: anuncia
la existencia de un directorio que el propietario no quiere indexar. HTTrack respetó la indicación y no se accedió a `/ftp`.

**Falsos positivos descartados.** Los comentarios HTML (`Added by HTTrack`, `Mirror and index made by HTTrack`) y los
archivos `hts-cache/doit.log` y `hts-cache/new.zip` son de HTTrack, no de la aplicación. Las coincidencias de «password»
o «token» en `main.js` son nombres de variables del código minificado, sin credenciales. El script se corrigió para
excluir estos casos.

## CP-003-03 · Detección

```text
Solicitudes con el agente FORTIS-LAB03 visibles en los registros: 0
```

La aplicación no registra las solicitudes HTTP, así que una descarga masiva del sitio (148 solicitudes en 2 minutos con un
agente de usuario identificable) pasa inadvertida para el equipo defensivo. Tasa de detección del caso: **0 %**.

## Hallazgos

| ID | Descripción | Referencia | P | I | S | Recomendación |
|---|---|---|---|---|---|---|
| H-003-01 | El código del cliente expone 40 rutas de API, entre ellas administración, usuarios, respuestas de seguridad y 2FA | OWASP A05:2021 · CWE-200 · ATT&CK T1594 | 3 | 2 | 6 · Medio | Validar la autorización en el servidor para cada ruta (FC-LAB-007) y no exponer rutas administrativas en el paquete público |
| H-003-02 | `robots.txt` anuncia el directorio `/ftp` | OWASP A05:2021 · CWE-200 | 3 | 2 | 6 · Medio | Proteger `/ftp` con autenticación o retirarlo; no usar `robots.txt` para ocultar recursos |
| H-003-03 | La clonación masiva no deja rastro en los registros de la aplicación | OWASP A09:2021 · CWE-778 | 4 | 2 | 8 · Alto | Registrar acceso HTTP (proxy inverso o middleware), alertar por volumen de solicitudes por IP o agente y limitar la tasa |

## Conclusión

La clonación controlada mostró que la superficie de la API es visible sin autenticarse y que el monitoreo de la
aplicación no detecta un rastreo masivo. Para un ciclo completo: repetir CP-003-01 con el script corregido y, tras activar
el registro de acceso, volver a medir la detección en CP-003-03.
