# Registro de cambios

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y [versionado semántico](https://semver.org/lang/es/).

## [0.4.0] — 2026-11-25
### Añadido
- Ciclo piloto ejecutado en Kali Linux 2026.2: FC-LAB-001 a 005 y FC-LAB-008 con resultados, 42 evidencias versionadas
  con SHA-256 y 10 hallazgos (1 crítico, 1 alto, 5 medios, 3 bajos).
- FC-LAB-008: detección con proxy nginx, reglas R1–R3 y re-test de FC-LAB-003 (detección 0 % → 100 %).
- Procedimientos y fichas completas de FC-LAB-001 a 007; scripts de ejecución en `scripts/kali/`.
- Sección 12.2 del documento con resultados por laboratorio e indicadores; anexos A–D con datos reales y figuras C.1–C.3.
- Guion de exposición (`docs/guion-exposicion.md`).

### Cambiado
- `registrar_evidencia.py` escribe finales de línea LF; `lab02.sh` ignora el TTL al comparar; `lab03.sh` limita a
  4 minutos, muestra progreso y descarta archivos propios de HTTrack.
- Documento del framework actualizado a la versión 0.4 (`docs/FORTIS_Framework_Metodologico_v0.4.docx`).

### Pendiente
- FC-LAB-006 (Maltego), FC-LAB-007 (Burp Suite) y casos CP-JS-01 a 06 del piloto Juice Shop.

## [0.3.0] — 2026-11-25
### Añadido
- Caso de estudio piloto FC-LAB-013 sobre OWASP Juice Shop (sección 12.1).
- Laboratorios propuestos FC-LAB-008 a FC-LAB-012 para los dominios D04–D08.
- Referencias en formato APA 7 (sección 16.1).
- Scripts de registro de evidencias y cálculo de severidad.

## [0.2.0] — 2026-11-22
### Añadido
- Denominación FORTIS, diagrama de arquitectura en cinco capas y diagrama UML de actividades por actor.
- Matriz de correspondencia con referentes (4.1), matriz RACI (8.1) y rúbrica de severidad (13.1).
- Anexos A–E.

## [0.1.0]
- Borrador inicial del framework.
