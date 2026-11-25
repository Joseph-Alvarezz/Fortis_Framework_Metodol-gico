# FC-LAB-006 · Maltego: instalación y aplicación

| Campo | Descripción / dato requerido |
|---|---|
| Identificador | FC-LAB-006 |
| Nombre y versión | Maltego: instalación y aplicación · v1.0 · noviembre de 2026 |
| Objetivo | Construir un mapa de relaciones de infraestructura pública (dominio, DNS, IP, correos publicados) de una organización autorizada. |
| Dominio y fase | D02 Reconocimiento y OSINT · fase 03 Identificación |
| Roles | Ejecutor: analista ofensivo · Revisor: coordinador de evaluación |
| Entorno y autorización | Maltego CE (Community Edition) con cuenta gratuita, sobre Kali Linux o Windows. Autorización escrita requerida antes de ejecutar. |
| Entradas | Dominio propio o autorizado por escrito. |
| Procedimiento | Ver [procedimiento.md](procedimiento.md) |
| Evidencias | `evidencias/`, registradas en el anexo C con SHA-256 |
| Criterio de aceptación | Grafo exportado con las entidades encontradas y cada una clasificada por nivel de exposición. |
| Análisis defensivo | Minimizar la información pública (WHOIS con privacidad, correos genéricos, subdominios innecesarios) y revisar periódicamente la huella digital. |
| Resultado | Ver [resultados.md](resultados.md) |

Enfoque: OSINT

## Casos de prueba

| ID caso | Objetivo | Resultado esperado |
|---|---|---|
| CP-006-01 | Instalar y configurar Maltego CE | Herramienta operativa |
| CP-006-02 | Construir el grafo de infraestructura del dominio | Grafo exportado |
| CP-006-03 | Clasificar la exposición encontrada | Hallazgos en anexo B |
