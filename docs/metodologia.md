# Metodología

## Fases
| Fase | Producto | Responsable principal |
|---|---|---|
| [Preparación](../framework/fases/01-preparacion.md) | Plan de evaluación aprobado | Coordinador de evaluación |
| [Prevención](../framework/fases/02-prevencion.md) | Diagnóstico inicial (línea base) | Analista defensivo |
| [Identificación](../framework/fases/03-identificacion.md) | Hallazgos documentados con evidencia | Analista ofensivo / Analista defensivo |
| [Análisis](../framework/fases/04-analisis.md) | Matriz de riesgos (anexo B) | Coordinador Purple Team |
| [Mitigación](../framework/fases/05-mitigacion.md) | Plan de tratamiento ejecutado (anexo D) | Responsable del sistema |
| [Verificación](../framework/fases/06-verificacion.md) | Informe de efectividad | Evaluador / Coordinador de evaluación |

Cada fase cierra con entregables revisados, evidencia identificable y aprobación del coordinador de evaluación.

## Actores y matriz RACI
| Actor | Responsabilidad principal |
|---|---|
| Responsable del sistema | Aprueba alcance, autoriza accesos y aprueba el plan de tratamiento |
| Coordinador de evaluación | Elabora el plan y las reglas de compromiso; aprueba el cierre |
| Coordinador Purple Team | Correlaciona ataque y detección; valida y compara resultados |
| Analista ofensivo | Ejecuta pruebas autorizadas y re-test |
| Analista defensivo | Línea base, monitoreo, implementación de controles |
| Custodio de evidencias | Registro, hash SHA-256 y cadena de custodia |
| Evaluador | Valida criterios, métricas, rúbrica y severidad |

R = ejecuta · A = aprueba / rinde cuentas (uno por fase) · C = consultado · I = informado.

## Dominios
| Código | Dominio | Propósito |
|---|---|---|
| D01 | Entornos y sistemas | Preparación de herramientas, comandos y permisos. |
| D02 | Reconocimiento y OSINT | Exposición pública y relaciones de infraestructura. |
| D03 | Seguridad web | Análisis de aplicaciones y recursos expuestos. |
| D04 | Comunicaciones y APIs | Solicitudes, autenticación y controles de acceso. |
| D05 | Factor humano | Ingeniería social y seguridad organizacional. |
| D06 | Forense digital | Inspección y preservación de evidencias. |
| D07 | Detección y respuesta | Alertas, registros y controles defensivos. |
| D08 | Seguridad de IA | Riesgos de prompt injection en LLM. |

## Indicadores
| Indicador | Fórmula |
|---|---|
| Cobertura de pruebas | casos ejecutados / casos planificados × 100 |
| Hallazgos por severidad | conteo por nivel (bajo, medio, alto, crítico) |
| Correcciones verificadas | hallazgos corregidos y verificados / hallazgos tratados × 100 |
| Tasa de detección | eventos detectados / eventos observables × 100 |
| Tiempo de respuesta | tiempo entre evento y respuesta |

Rúbrica de severidad: ver [framework/matrices/rubrica-severidad.md](../framework/matrices/rubrica-severidad.md).
