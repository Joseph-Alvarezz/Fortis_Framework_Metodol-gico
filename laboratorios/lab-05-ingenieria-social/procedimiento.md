# Procedimiento · FC-LAB-005 Ingeniería social: principios

> **Uso autorizado.** Ejecuta este laboratorio solo en equipos, dominios, archivos o aplicaciones propios o con autorización escrita (ver `framework/protocolos/reglas-de-compromiso.md`).

**Objetivo:** Reconocer los principios de persuasión que explota la ingeniería social e identificar sus indicadores en mensajes reales y sintéticos.

**Entorno:** Aula o sesión virtual. No se envían mensajes a personas reales: se trabaja con ejemplos sintéticos o publicados por campañas de concienciación.

## 1. Principios de persuasión (Cialdini) y su uso en ataques
| Principio | Cómo se explota | Ejemplo |
|---|---|---|
| Autoridad | Suplantar a un jefe, banco o entidad | «Soy del área de TI, necesito tu código» |
| Urgencia / escasez | Presionar para no pensar | «Tu cuenta se bloquea en 1 hora» |
| Reciprocidad | Ofrecer algo para pedir algo | «Te regalo un bono, solo confirma tus datos» |
| Prueba social | «Todos ya lo hicieron» | «Tus compañeros ya actualizaron su clave» |
| Simpatía | Crear confianza o afinidad | Perfil falso con intereses comunes |
| Compromiso / coherencia | Pedir pequeños pasos | Encuesta inocente que termina pidiendo credenciales |

Técnicas asociadas: phishing, vishing, smishing, pretexting, baiting, tailgating.

## 2. Clasificar mensajes (CP-005-01)
Para cada mensaje sintético completa:

| Mensaje | ¿Legítimo? | Principio usado | Canal | Justificación |
|---|---|---|---|---|

## 3. Indicadores técnicos (CP-005-02)
- Dominio del remitente distinto al oficial o con caracteres parecidos (`bancoo.com`, `rn` por `m`).
- Enlace cuyo destino real (pasando el cursor) no coincide con el texto.
- Solicitud de credenciales, códigos o pagos por un canal no habitual.
- Errores de redacción, saludo genérico, adjuntos inesperados (`.zip`, `.html`, macros).
- En correo: revisar en las cabeceras los resultados SPF, DKIM y DMARC.

## 4. Controles (CP-005-03)
Redacta un procedimiento de una página: cómo verificar por un segundo canal, a quién reportar, qué no hacer nunca
(compartir códigos MFA) y cómo se medirá la concienciación (por ejemplo, tasa de reporte en la simulación FC-LAB-012).

## Consideración ética
Este laboratorio no incluye engañar a personas. Cualquier simulación real requiere autorización institucional
(ver FC-LAB-012).

## Registro de evidencias
Registra cada evidencia con:

```bash
python scripts/registrar_evidencia.py laboratorios/lab-05-ingenieria-social/evidencias/<archivo> --caso <ID caso> --desc "<descripción>" --por "<rol>"
```

## Cierre
Completa [resultados.md](resultados.md), el anexo A (casos) y, si hubo hallazgos, los anexos B y D.
