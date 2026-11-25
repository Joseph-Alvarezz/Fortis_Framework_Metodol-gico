# Procedimiento · FC-LAB-006 Maltego: instalación y aplicación

> **Uso autorizado.** Ejecuta este laboratorio solo en equipos, dominios, archivos o aplicaciones propios o con autorización escrita (ver `framework/protocolos/reglas-de-compromiso.md`).

**Objetivo:** Construir un mapa de relaciones de infraestructura pública (dominio, DNS, IP, correos publicados) de una organización autorizada.

**Entorno:** Maltego CE (Community Edition) con cuenta gratuita, sobre Kali Linux o Windows.

## 1. Instalación (CP-006-01)
- En Kali: `sudo apt install maltego -y`. En Windows: instalador desde https://www.maltego.com/downloads/.
- Al iniciar, elige **Maltego CE (Free)**, crea la cuenta y acepta los transforms estándar.

## 2. Construir el grafo (CP-006-02)
1. *New Graph* → arrastra una entidad **Domain** y escribe el dominio autorizado.
2. Ejecuta transforms de forma gradual y anota cada uno en la bitácora:
   - *To DNS Name – NS / MX*
   - *To IP Address [DNS]*
   - *To Netblock* y *To AS Number*
   - *To Website* y *To Email addresses [from domain]* (solo correos publicados)
3. Usa el diseño *Organic* o *Hierarchical* para leer las relaciones.
4. Exporta: *Export → Graph as image (PNG)* y *Export → Tabular report (CSV)*.

## 3. Clasificar (CP-006-03)
| Entidad | Fuente | ¿Debe ser pública? | Riesgo | Recomendación |
|---|---|---|---|---|

Ejemplos de exposición: subdominios de pruebas, correos personales en lugar de genéricos, proveedor de correo o
alojamiento identificable. Referencia: ATT&CK T1590 / T1589 (recolección de información de la víctima).

## 4. Comparar con FC-LAB-002
Contrasta el grafo con el inventario DNS del laboratorio 002: las diferencias indican fuentes adicionales (OSINT) que
el equipo defensivo debe conocer.

## 5. Evidencias
Registra el PNG y el CSV exportados en el anexo C. No subas al repositorio correos personales: anonimízalos.

## Registro de evidencias
Registra cada evidencia con:

```bash
python scripts/registrar_evidencia.py laboratorios/lab-06-maltego/evidencias/<archivo> --caso <ID caso> --desc "<descripción>" --por "<rol>"
```

## Cierre
Completa [resultados.md](resultados.md), el anexo A (casos) y, si hubo hallazgos, los anexos B y D.
