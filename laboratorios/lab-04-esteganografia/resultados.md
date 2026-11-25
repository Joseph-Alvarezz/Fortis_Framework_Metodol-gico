# Resultados · FC-LAB-004

**Ejecución:** 2026-11-25 18:39 UTC · Kali 2026.2 · steghide 0.5.1 · script `scripts/kali/lab04.sh`.
Portadores y mensaje sintéticos: tres imágenes BMP de 320 × 240 generadas por el script. Integridad de los archivos
comprobada con `lab04.sha256` (todos `OK`).

## Resumen

| Caso | Resultado observado | Evidencia (ID) | Hallazgo | Severidad | Estado |
|---|---|---|---|---|---|
| CP-004-01 | Mensaje de 56 bytes oculto en `logo.bmp` (capacidad 9.4 KB), cifrado AES-128 (rijndael-128, CBC) y comprimido | EV-004-01-01, 02 | — | — | Cumplido |
| CP-004-02 | El archivo alterado se identificó **solo** por su hash; el mensaje se recuperó íntegro con la clave y no con una clave incorrecta | EV-004-02-01 a 03 | H-004-01 | 6 · Medio | Cumplido |
| CP-004-03 | Evidencia preservada: hash del archivo estego registrado y distinto del portador limpio | EV-004-03-01 a 03 | — | — | Cumplido |

## Parte 1 · Ocultar (CP-004-01)

| Dato | Valor |
|---|---|
| Portadores | `paisaje.bmp`, `logo.bmp`, `fondo.bmp` (230 454 bytes cada uno) |
| Portador usado | `logo.bmp` |
| Archivo oculto | `secreto.txt`, 56 bytes |
| Protección | rijndael-128 (AES) en modo CBC, comprimido |
| Clave del ejercicio | Generada al azar por el script (`parte1-ocultar.txt`); solo sirve para este ejercicio |

## Parte 2 · Detectar y extraer (CP-004-02)

| Técnica de detección | ¿Detectó la alteración? |
|---|---|
| Inspección visual | No: la imagen se ve igual |
| Tamaño del archivo | **No**: original y estego miden exactamente 230 454 bytes |
| Metadatos (`exiftool`) | No: mismo tamaño, resolución 320 × 240 y 24 bits |
| Comparación de SHA-256 | **Sí**: `52321e9a…f0` (original) ≠ `8fd58cf1…7a` (estego) |

```text
steghide info → embedded file "secreto.txt": size 56.0 Byte, encrypted rijndael-128 cbc, compressed yes
Extracción → "Mensaje sintético FORTIS LAB04 · 2026-11-25 18:39 UTC" — mensaje recuperado íntegro
Clave incorrecta → steghide: could not extract any data with that passphrase!
```

Steghide reemplaza bits menos significativos de los píxeles, por lo que el archivo conserva su tamaño y su aspecto.
Solo un control de integridad con un registro previo de hashes delata el cambio.

## Parte 3 · Preservar (CP-004-03)

| Archivo | SHA-256 |
|---|---|
| `logo.bmp` limpio | `52321e9af1baedf5da3896fbff58fb6f13f63c080a6691bed8b107c9189324f0` |
| `logo-estego.bmp` (evidencia) | `8fd58cf136072a002e6eb9dc10897e4a4f726fce867a3c3928eaa16bbe9f9d7a` |

El hash de la evidencia se recalculó en Windows al registrarla en el anexo C y coincide con el calculado en Kali: la
transferencia por la carpeta compartida no la alteró.

## Hallazgos

| ID | Descripción | Referencia | P | I | S | Recomendación |
|---|---|---|---|---|---|---|
| H-004-01 | Un archivo con datos ocultos y cifrados no se distingue por tamaño, aspecto ni metadatos; solo lo revela la comparación con un hash previo | MITRE ATT&CK T1027.003 (esteganografía) · T1048 (exfiltración) | 2 | 3 | 6 · Medio | Monitoreo de integridad de archivos (FIM) con línea base de hashes, control de los archivos que salen de la organización y análisis estadístico en investigaciones forenses |

## Preguntas de discusión

1. **¿Por qué el hash detecta la alteración aunque la imagen se vea igual?** Porque SHA-256 cambia por completo si
   cambia un solo bit del archivo, y steghide modifica miles de bits aunque sean invisibles.
2. **¿Qué control reduciría la exfiltración por esteganografía?** La comparación con una línea base de hashes (FIM) para
   archivos conocidos, y para archivos nuevos el control de salida de datos y el análisis estadístico (por ejemplo,
   `stegseek` o pruebas chi-cuadrado) durante investigaciones.
