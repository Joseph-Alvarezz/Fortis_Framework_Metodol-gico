# Resultados · FC-LAB-005

**Ejecución:** 2026-11-25 · un participante · conjunto de 10 mensajes sintéticos ([mensajes.md](mensajes.md)) por cinco
canales: correo (6), SMS (1), llamada (1), chat (1) y presencial (1); 3 legítimos y 7 fraudulentos.

## Resumen

| Caso | Resultado observado | Evidencia (ID) | Hallazgo | Severidad | Estado |
|---|---|---|---|---|---|
| CP-005-01 | Clasificación L/F: **10/10 (100 %)**, sin falsos positivos ni falsos negativos | EV-005-01-01 | — | — | Cumplido |
| CP-005-02 | El participante entregó solo la clasificación, sin principio ni indicadores; la justificación se documentó en la clave del evaluador | EV-005-02-01 | H-005-01 | 2 · Bajo | Cumplido parcialmente |
| CP-005-03 | Procedimiento de verificación y reporte redactado ([procedimiento-reporte.md](procedimiento-reporte.md)) | EV-005-03-01 | — | — | Cumplido |

## Clasificación

| # | Canal | Respuesta | Clave | Principios usados por el mensaje |
|---|---|---|---|---|
| 1 | Correo | F | F ✓ | Autoridad + urgencia |
| 2 | Correo | L | L ✓ | — |
| 3 | SMS | F | F ✓ | Urgencia + autoridad |
| 4 | Llamada | F | F ✓ | Autoridad + urgencia |
| 5 | Chat | F | F ✓ | Autoridad + simpatía + urgencia |
| 6 | Correo | L | L ✓ | — |
| 7 | Correo | F | F ✓ | Reciprocidad + prueba social + escasez |
| 8 | Presencial | F | F ✓ | Autoridad + simpatía (pretexting / tailgating) |
| 9 | Correo | L | L ✓ | — |
| 10 | Correo | F | F ✓ | Reciprocidad + compromiso |

**Precisión:** 100 % (criterio de aceptación ≥ 80 %).
**Principio más frecuente en los fraudes:** autoridad (6 de 7), seguido de urgencia (4 de 7).

## Hallazgo

| ID | Descripción | P | I | S | Recomendación |
|---|---|---|---|---|---|
| H-005-01 | La clasificación fue correcta pero sin justificación: no queda evidencia de que el participante reconozca los indicadores, lo que limita medir si identificará variantes nuevas | 2 | 1 | 2 · Bajo | En el próximo ciclo exigir el formato completo (principio, canal, indicadores) y usar mensajes nuevos |

## Conclusión

El participante distingue correctamente mensajes legítimos y fraudulentos en los cinco canales. Para cerrar el
aprendizaje conviene repasar la [clave de respuestas](clave-respuestas.md), en especial los indicadores técnicos (dominios
parecidos como `uat-edu.co` y `rnicrosoft`, remitentes `@gmail.com`, adjuntos `.html`) y la regla de que ninguna
entidad legítima pide códigos de verificación. El procedimiento de reporte servirá como línea base para medir la tasa
de reporte en la simulación autorizada FC-LAB-012.
