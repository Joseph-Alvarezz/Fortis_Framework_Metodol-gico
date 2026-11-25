# Procedimiento · FC-LAB-004 Esteganografía con Steghide (partes 1–3)

> **Uso autorizado.** Ejecuta este laboratorio solo en equipos, dominios, archivos o aplicaciones propios o con autorización escrita (ver `framework/protocolos/reglas-de-compromiso.md`).

**Objetivo:** Comprender cómo se oculta información en archivos multimedia, cómo se detecta y cómo se preserva la evidencia sin alterarla.

**Entorno:** Kali Linux propio; imágenes JPG/BMP y audio WAV creados o descargados con licencia libre.

## Preparación
```bash
sudo apt install steghide exiftool -y
mkdir -p ~/fortis/lab04/{originales,trabajo} && cd ~/fortis/lab04
cp /ruta/foto.jpg originales/
sha256sum originales/* > originales.sha256
```

## Parte 1 · Ocultar (CP-004-01, equipo A)
```bash
echo "Mensaje sintético FORTIS LAB04" > secreto.txt
cp originales/foto.jpg trabajo/foto.jpg
steghide embed -cf trabajo/foto.jpg -ef secreto.txt -p "<contraseña-acordada>"
steghide info trabajo/foto.jpg
```
Steghide admite JPEG, BMP, WAV y AU. Entrega al equipo B varios archivos, solo uno de ellos alterado.

## Parte 2 · Detectar y extraer (CP-004-02, equipo B)
1. Compara hashes contra el registro original: el archivo cuyo hash cambió es sospechoso.
   ```bash
   sha256sum trabajo/* ; cat originales.sha256
   ```
2. Revisa metadatos y tamaño:
   ```bash
   exiftool trabajo/foto.jpg ; ls -l originales/ trabajo/
   ```
3. Extrae con la contraseña proporcionada en el ejercicio:
   ```bash
   steghide extract -sf trabajo/foto.jpg -p "<contraseña-acordada>" -xf recuperado.txt
   diff secreto.txt recuperado.txt && echo "Mensaje íntegro"
   ```

## Parte 3 · Preservar (CP-004-03, custodio)
1. Registra el archivo estego en el anexo C **antes** de analizarlo, con `scripts/registrar_evidencia.py`.
2. Trabaja siempre sobre una copia.
3. Al cerrar, verifica que el hash no cambió:
   ```bash
   python scripts/registrar_evidencia.py laboratorios/lab-04-esteganografia/evidencias/foto-estego.jpg --verificar
   ```

## Discusión
- ¿Por qué el hash detecta la alteración aunque la imagen se vea igual?
- ¿Qué control organizacional reduciría la exfiltración por esteganografía?

## Registro de evidencias
Registra cada evidencia con:

```bash
python scripts/registrar_evidencia.py laboratorios/lab-04-esteganografia/evidencias/<archivo> --caso <ID caso> --desc "<descripción>" --por "<rol>"
```

## Cierre
Completa [resultados.md](resultados.md), el anexo A (casos) y, si hubo hallazgos, los anexos B y D.
