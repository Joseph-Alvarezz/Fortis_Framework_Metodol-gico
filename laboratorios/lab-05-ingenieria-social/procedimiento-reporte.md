# Procedimiento de verificación y reporte de ingeniería social (propuesta CP-005-03)

**Alcance:** estudiantes, docentes y personal de la organización de referencia. **Versión:** 1.0 · noviembre de 2026.

## 1. Antes de actuar: tres preguntas
1. **¿Me piden algo valioso?** Contraseña, código, dinero, datos bancarios, acceso físico o instalar algo.
2. **¿Me presionan?** Plazos cortos, amenazas, premios o secreto.
3. **¿El remitente es exactamente quien dice ser?** Revisa el dominio letra por letra y el destino real de los enlaces.

Si alguna respuesta es «sí» o «no estoy seguro», **no respondas, no hagas clic y verifica**.

## 2. Verificar por un segundo canal
- Contacta a la persona o entidad **por un medio que tú elijas** (número de la página oficial, en persona), nunca por el
  número, enlace o correo que viene en el mensaje.
- Para el banco: aplicación oficial o la línea impresa en la tarjeta.
- Para una persona en la puerta: llama tú al responsable que menciona antes de abrir.

## 3. Nunca
- Compartir códigos de verificación (MFA/OTP), aunque quien llame diga ser del banco o de TI.
- Pagar con tarjetas de regalo o transferencias pedidas por chat.
- Abrir adjuntos `.html`, `.zip` o con macros que no esperabas.
- Dejar entrar a nadie a zonas restringidas con tu credencial.

## 4. Reportar
| Situación | A quién | Cómo |
|---|---|---|
| Correo sospechoso | Mesa de servicios TI | Botón «Reportar phishing» o reenviar como adjunto |
| Llamada o SMS que suplanta al banco | Banco (línea oficial) y Mesa de servicios | Número, hora y lo que pidieron |
| Ya hiciste clic o diste datos | Mesa de servicios **de inmediato** | Cambiar contraseña y cerrar sesiones |
| Intento de acceso físico | Vigilancia / coordinador | Descripción, hora y lugar |

Reportar un falso positivo no tiene costo: es preferible a no reportar.

## 5. Medición
| Indicador | Fórmula | Meta |
|---|---|---|
| Precisión de clasificación (este laboratorio) | aciertos / mensajes × 100 | ≥ 80 % |
| Tasa de reporte (simulación FC-LAB-012) | reportes / mensajes simulados × 100 | ≥ 60 % |
| Tasa de clic (simulación FC-LAB-012) | clics / mensajes simulados × 100 | ≤ 10 % |
