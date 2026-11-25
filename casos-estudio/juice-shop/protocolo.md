# Caso piloto: OWASP Juice Shop (FC-LAB-013)

**Entorno:** OWASP Juice Shop 20.4.0, ejecutado exclusivamente en 127.0.0.1:3000, en equipo propio y sin datos reales.
Integridad del paquete verificada con el MD5 publicado por OWASP; SHA-256 registrado en el anexo C (EV-JS-00-01).

**Reglas de compromiso:** solo la instancia local; excluidos servicios de terceros, la red institucional y cualquier
sistema no listado. Evidencias con SHA-256 al momento de la captura; la instancia se restaura al cerrar cada ciclo.

## Fases

| Fase | Actividades | Actor principal | Producto |
|---|---|---|---|
| 01 Preparación | Plan, alcance, reglas, verificación de integridad | Coordinador de evaluación | Plan FC-LAB-013 aprobado |
| 02 Prevención | Inventario, cabeceras, configuración; línea base | Analista defensivo | Diagnóstico inicial |
| 03 Identificación | Casos CP-JS-01 a 06 y monitoreo de registros | Analista ofensivo / defensivo | Hallazgos documentados |
| 04 Análisis | Correlación, clasificación OWASP/ATT&CK, S = P × I | Coordinador Purple Team | Anexo B |
| 05 Mitigación | Controles compensatorios y correcciones | Responsable del sistema | Anexo D |
| 06 Verificación | Re-test y cobertura de detección | Evaluador | Informe de efectividad |

## Casos de prueba

| ID | Categoría OWASP Top 10:2021 | Objetivo de verificación | Dominio | Resultado |
|---|---|---|---|---|
| CP-JS-01 | A05 Configuración incorrecta | Cabeceras HTTP, mensajes de error y recursos expuestos | D03 | Pendiente |
| CP-JS-02 | A01 Control de acceso deficiente | Acceso a recursos o funciones de otro rol | D03/D04 | Pendiente |
| CP-JS-03 | A03 Inyección | Validación de entradas en autenticación y búsqueda | D03 | Pendiente |
| CP-JS-04 | A07 Identificación y autenticación | Política de contraseñas, bloqueo y recuperación | D03 | Pendiente |
| CP-JS-05 | A02 Fallas criptográficas / API | Credenciales y tokens en la API REST | D04 | Pendiente |
| CP-JS-06 | A09 Registro y monitoreo | Registro y detectabilidad de los eventos anteriores | D07 | Pendiente |

## Criterios de aceptación
(a) cada fase cierra con su producto aprobado; (b) 100 % de los hallazgos con evidencia SHA-256 y severidad calculada;
(c) todo hallazgo Alto o Crítico con acción en el plan de mitigación; (d) re-test documentado para cada caso;
(e) cobertura de detección = casos detectados / casos ejecutados.
