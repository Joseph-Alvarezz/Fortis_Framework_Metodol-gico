# Procedimiento · FC-LAB-008 Detección y análisis de registros

> **Uso autorizado.** Ejecuta este laboratorio solo en equipos y aplicaciones propios o con autorización escrita
> (ver `framework/protocolos/reglas-de-compromiso.md`).

**Requisito:** Juice Shop corriendo en Kali (`bash /media/sf_fortis/scripts/kali/juice-shop.sh`).

## Ejecución automática
```bash
bash /media/sf_fortis/scripts/kali/lab08.sh
```

## Qué hace el script

### 1. Control: proxy con registro y límite de tasa
Crea una red Docker `fortis-net` y un contenedor `nginx:stable-alpine` publicado solo en `127.0.0.1:8080`, que reenvía a
Juice Shop. La configuración (`evidencias/nginx.conf`):

| Directiva | Para qué |
|---|---|
| `log_format fortis '$remote_addr\|$time_iso8601\|$request\|$status\|…\|$http_user_agent\|…'` | Registro de acceso con IP, hora, solicitud, código y agente |
| `limit_req_zone … rate=10r/s` + `limit_req … burst=20` | Máximo 10 solicitudes por segundo por IP, con ráfaga de 20 |
| `limit_req_status 429` | Responde *Too Many Requests* al exceder el límite |

### 2. CP-008-01 · Línea base
Cinco solicitudes con un agente de navegador común, una por segundo.

### 3. CP-008-02 · Re-test de la clonación
Repite la clonación de FC-LAB-003 con el mismo agente `FORTIS-LAB03`, ahora a través del proxy (máximo 2 minutos).

### 4. Reglas de detección sobre `access.log`
| Regla | Lógica | Técnica que cubre |
|---|---|---|
| R1 | El agente contiene `httrack`, `curl`, `wget`, `python`, `nikto`, `sqlmap` o `FORTIS` | Herramientas automatizadas (ATT&CK T1595, T1594) |
| R2 | Más de 60 solicitudes en un minuto desde la misma IP | Rastreo o fuerza bruta aunque el agente se falsifique |
| R3 | Conteo de respuestas 429 | Evidencia de que el límite de tasa actuó |

### 5. Evidencias
`nginx.conf`, `entorno-proxy.txt`, `linea-base.txt`, `clonacion.txt`, `access.log`, `alertas.txt` y `lab08.sha256`.

## Análisis manual (opcional)
```bash
cd /media/sf_fortis/laboratorios/lab-08-deteccion/evidencias
awk -F'|' '{print $4}' access.log | sort | uniq -c          # códigos de respuesta
awk -F'|' '{print substr($2,12,8), $4, $3}' access.log | head  # línea de tiempo
```

## Cierre
```bash
docker rm -f fortis-proxy
```
Completa [resultados.md](resultados.md) y actualiza el estado de H-003-03 y M-003-03 en los anexos B y D.
