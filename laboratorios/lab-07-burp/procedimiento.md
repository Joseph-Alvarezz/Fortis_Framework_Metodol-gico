# Procedimiento · FC-LAB-007 Burp Suite

> **Uso autorizado.** Ejecuta este laboratorio solo en equipos, dominios, archivos o aplicaciones propios o con autorización escrita (ver `framework/protocolos/reglas-de-compromiso.md`).

**Objetivo:** Configurar Burp Suite como proxy de interceptación y analizar las solicitudes y respuestas de una aplicación web autorizada.

**Entorno:** Burp Suite Community Edition y la instancia local de OWASP Juice Shop (http://127.0.0.1:3000) con dos usuarios de prueba.

## 1. Configuración
1. Inicia Juice Shop en local (ver `laboratorios/lab-13-juice-shop/procedimiento.md`).
2. Abre Burp Suite Community → *Temporary project* → *Use Burp defaults*.
3. Pestaña **Proxy → Intercept → Open browser**: usa el navegador integrado de Burp, que ya confía en su certificado.
4. En **Target → Scope** agrega solo `http://127.0.0.1:3000` y activa *Show only in-scope items* en el historial.
   Así ninguna solicitud ajena entra en la evaluación.

## 2. Mapear la aplicación
Con *Intercept off*, navega por la aplicación como usuario A: inicio, búsqueda, cesta, perfil. Revisa
**Proxy → HTTP history** y **Target → Site map** para identificar las rutas de la API (`/rest/...`, `/api/...`).

## 3. Cabeceras de seguridad (CP-007-02)
Selecciona varias respuestas y anota si incluyen:

| Cabecera | Propósito | ¿Presente? |
|---|---|---|
| Content-Security-Policy | Limita orígenes de scripts | |
| Strict-Transport-Security | Obliga HTTPS | |
| X-Content-Type-Options: nosniff | Evita interpretación de tipos | |
| X-Frame-Options / frame-ancestors | Evita clickjacking | |
| Referrer-Policy | Controla la información de referencia | |

## 4. Cookies y tokens (CP-007-03)
En la respuesta de inicio de sesión revisa los atributos de las cookies (`Secure`, `HttpOnly`, `SameSite`) y dónde se
guarda el token. Si es un JWT, decodifica solo su carga útil (sección central, Base64) en **Decoder** y anota qué datos
contiene. Un token no debería incluir información sensible.

## 5. Control de acceso (CP-007-01)
1. Como usuario A, abre un recurso propio (por ejemplo su cesta) y envía esa solicitud a **Repeater** (Ctrl + R).
2. Inicia sesión como usuario B en otra ventana y copia su cabecera `Authorization` o su cookie de sesión.
3. En Repeater, sustituye la credencial de A por la de B y envía la solicitud **una vez**.
4. Resultado esperado de una aplicación segura: `403 Forbidden` o `404`. Si la respuesta devuelve datos de A, es un
   hallazgo OWASP **A01 Control de acceso deficiente** (CWE-639); calcula su severidad con `scripts/severidad.py`.

## 6. Detección
El analista defensivo revisa la consola del servidor de Juice Shop y anota si la solicitud del paso 5 quedó registrada.

## 7. Evidencias
Exporta las solicitudes y respuestas relevantes (*clic derecho → Save item*) y captura de pantalla de cada caso.
Antes de subirlas, elimina tokens y cookies de los archivos.

## Registro de evidencias
Registra cada evidencia con:

```bash
python scripts/registrar_evidencia.py laboratorios/lab-07-burp/evidencias/<archivo> --caso <ID caso> --desc "<descripción>" --por "<rol>"
```

## Cierre
Completa [resultados.md](resultados.md), el anexo A (casos) y, si hubo hallazgos, los anexos B y D.
