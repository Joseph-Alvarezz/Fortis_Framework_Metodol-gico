# FC-LAB-004 · Esteganografía con Steghide (partes 1–3)

| Campo | Descripción / dato requerido |
|---|---|
| Identificador | FC-LAB-004 |
| Nombre y versión | Esteganografía con Steghide (partes 1–3) · v1.0 · noviembre de 2026 |
| Objetivo | Comprender cómo se oculta información en archivos multimedia, cómo se detecta y cómo se preserva la evidencia sin alterarla. |
| Dominio y fase | D06 Forense digital · fase 03 Identificación / 04 Análisis |
| Roles | Equipo A: oculta · Equipo B: analiza · Custodio: preserva y verifica hashes |
| Entorno y autorización | Kali Linux propio; imágenes JPG/BMP y audio WAV creados o descargados con licencia libre. Autorización escrita requerida antes de ejecutar. |
| Entradas | Archivo portador, mensaje de texto sintético y contraseña acordada (no reutilizada). |
| Procedimiento | Ver [procedimiento.md](procedimiento.md) |
| Evidencias | `evidencias/`, registradas en el anexo C con SHA-256 |
| Criterio de aceptación | El equipo B detecta qué archivos fueron modificados por comparación de hashes y recupera el mensaje; los originales conservan su hash. |
| Análisis defensivo | Control de integridad de archivos (hashes, FIM), análisis de metadatos y políticas de transferencia de archivos. |
| Resultado | Ver [resultados.md](resultados.md) |

Enfoque: Forense y colaborativo

## Casos de prueba

| ID caso | Objetivo | Resultado esperado |
|---|---|---|
| CP-004-01 | Parte 1: ocultar un mensaje en un portador | Archivo estego generado |
| CP-004-02 | Parte 2: detectar el archivo alterado y extraer el mensaje | Mensaje recuperado |
| CP-004-03 | Parte 3: preservar y verificar la evidencia | Cadena de custodia completa |
