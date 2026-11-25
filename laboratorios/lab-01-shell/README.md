# FC-LAB-001 · Comandos Shell y Kali Linux

| Campo | Descripción / dato requerido |
|---|---|
| Identificador | FC-LAB-001 |
| Nombre y versión | Comandos Shell y Kali Linux · v1.0 · noviembre de 2026 |
| Objetivo | Preparar y documentar un entorno de trabajo reproducible en Kali Linux y dominar los comandos de shell que usan los demás laboratorios. |
| Dominio y fase | D01 Entornos y sistemas · fase 01 Preparación |
| Roles | Ejecutor: analista ofensivo · Revisor: coordinador de evaluación |
| Entorno y autorización | Máquina virtual Kali Linux propia (VirtualBox o VMware) con red NAT o solo-anfitrión. Autorización escrita requerida antes de ejecutar. |
| Entradas | Imagen oficial de Kali Linux verificada con su SHA-256 publicado; carpeta de trabajo sintética. |
| Procedimiento | Ver [procedimiento.md](procedimiento.md) |
| Evidencias | `evidencias/`, registradas en el anexo C con SHA-256 |
| Criterio de aceptación | El entorno se reconstruye desde cero siguiendo el procedimiento y la salida de verificación coincide en dos ejecuciones. |
| Análisis defensivo | Principio de mínimo privilegio (uso de sudo en lugar de root), actualización de paquetes y registro de comandos (bitácora). |
| Resultado | Ver [resultados.md](resultados.md) |

Enfoque: Transversal

## Casos de prueba

| ID caso | Objetivo | Resultado esperado |
|---|---|---|
| CP-001-01 | Verificar la integridad de la imagen de Kali | Hash calculado = hash publicado |
| CP-001-02 | Documentar el entorno (versión, red, usuario) | Ficha de entorno completa |
| CP-001-03 | Ejecutar los comandos base y guardar la bitácora | Bitácora con hash registrada |
