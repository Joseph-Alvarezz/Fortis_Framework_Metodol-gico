# Resultados · FC-LAB-008

**Ejecución:** 2026-11-25 19:06:25–19:08:33 UTC · Kali 2026.2 · proxy `nginx:stable-alpine`
(`sha256:0f08911480c0…`) en `127.0.0.1:8080` delante de Juice Shop 20.4.0 · script `scripts/kali/lab08.sh`.
Integridad de los archivos generados comprobada con `lab08.sha256` (todos `OK`).

## Resumen

| Caso | Resultado observado | Evidencia (ID) | Hallazgo | Severidad | Estado |
|---|---|---|---|---|---|
| CP-008-01 | 5 solicitudes de navegación normal registradas (todas 200) y **0 alertas**: sin falsos positivos | EV-008-01-01 a 03 | — | — | Cumplido |
| CP-008-02 | Clonación completa (231 archivos) **detectada por R1 y R2**: 228 solicitudes con agente `FORTIS-LAB03` y 2 minutos sobre el umbral (114 y 62 solicitudes) | EV-008-02-01 a 04 | — | — | Cumplido |
| CP-008-03 | **0 respuestas 429**: el límite de 10 solicitudes/s no se activó porque la clonación nunca superó 2 solicitudes/s | EV-008-03-01 | H-008-01 | 3 · Bajo | No cumple |

## Control implementado

| Elemento | Configuración |
|---|---|
| Registro | `log_format fortis` con IP, hora ISO 8601, solicitud, código, bytes, agente y tiempo de respuesta |
| Límite de tasa | `rate=10r/s`, `burst=20`, `nodelay`, código 429 |
| Exposición | Solo `127.0.0.1:8080` (verificado con `ss`) |

## Registro analizado

| Origen | Solicitudes | Ventana |
|---|---|---|
| Navegación normal (Firefox) | 5 | 19:06:25–19:06:30 |
| Comprobación de disponibilidad del script (`curl/8.20.0`) | 1 | 19:06:25 |
| Clonación HTTrack (`FORTIS-LAB03`) | 228 | 19:06:32–19:08:32 |
| **Total** | **234** (todas con código 200) | |

La solicitud de `curl` la genera el propio script al esperar que el proxy responda; R1 la marca correctamente como
herramienta automatizada, aunque no forma parte del ataque.

## Reglas de detección

| Regla | Resultado | Valoración |
|---|---|---|
| R1 · agente de herramienta | 229 coincidencias (228 `FORTIS-LAB03` + 1 `curl`) | Detecta, pero depende de un dato que el atacante controla: basta cambiar el agente para evadirla |
| R2 · > 60 solicitudes/min por IP | 2 alertas: 114 (19:07) y 62 (19:08) solicitudes de 172.18.0.1 | Detecta aunque el agente se falsifique; es la regla más robusta |
| R3 · respuestas 429 | 0 | El límite no frenó la clonación (ver H-008-01) |

**Tasa de detección de la clonación: 100 %** (2 de 2 reglas de detección alertaron). Falsos positivos sobre la
navegación normal: 0 de 5.

## Re-test de FC-LAB-003

| | FC-LAB-003 (sin control) | FC-LAB-008 (con proxy) |
|---|---|---|
| Solicitudes de la clonación visibles en registros | 0 | 228 |
| Alertas | 0 | R1 y R2 |
| Tasa de detección | 0 % | 100 % |

El hallazgo **H-003-03** («la clonación masiva no deja rastro») queda **mitigado y verificado** por la acción **M-003-03**.
La clonación además descargó la copia completa (231 archivos frente a 148 del lab03, que se interrumpió).

## Hallazgo

| ID | Descripción | Referencia | P | I | S | Recomendación |
|---|---|---|---|---|---|---|
| H-008-01 | El límite de 10 solicitudes/s no frena un rastreo lento: la clonación (máximo 2 solicitudes/s, 228 en 2 minutos) pasó completa sin ningún 429 | OWASP A04:2021 · CWE-770 | 3 | 1 | 3 · Bajo | Añadir un límite por minuto (p. ej. 60 r/min por IP) o bloquear automáticamente las IP que disparan R2; usar la detección para responder, no solo para registrar |

## Conclusión

El registro de acceso convierte un ataque invisible en uno detectable: R2 lo identifica por volumen sin depender del
agente, y la línea base confirma que la navegación normal no genera ruido. El control preventivo (límite de tasa)
quedó mal calibrado para rastreos lentos; ese ajuste es la siguiente iteración del ciclo.
