#!/usr/bin/env bash
# FC-LAB-004 · Esteganografía con Steghide (partes 1-3), con portadores y mensaje sintéticos
source "$(dirname "$0")/comun.sh"
E="$REPO/laboratorios/lab-04-esteganografia/evidencias"; mkdir -p "$E"
W="$HOME/fortis/lab04"; rm -rf "$W"; mkdir -p "$W"/{originales,entregados}; cd "$W"

titulo "Preparación · portadores sintéticos"
python3 - <<'EOF'
# Genera tres imágenes BMP de 320x240 con degradados distintos (sin datos reales)
import struct
def bmp(path, f):
    w, h = 320, 240; row = (w * 3 + 3) & ~3
    data = bytearray()
    for y in range(h):
        line = bytearray()
        for x in range(w):
            r, g, b = f(x, y); line += bytes((b, g, r))
        data += line + b'\0' * (row - len(line))
    hdr = b'BM' + struct.pack('<IHHI', 54 + len(data), 0, 0, 54)
    dib = struct.pack('<IiiHHIIiiII', 40, w, h, 1, 24, 0, len(data), 2835, 2835, 0, 0)
    open(path, 'wb').write(hdr + dib + data)
bmp('originales/paisaje.bmp', lambda x, y: (x * 255 // 320, y * 255 // 240, 128))
bmp('originales/logo.bmp',    lambda x, y: ((x ^ y) & 255, 90, (x + y) % 256))
bmp('originales/fondo.bmp',   lambda x, y: (200, (x * y) % 256, y * 255 // 240))
EOF
sha256sum originales/* | tee originales.sha256
cp originales.sha256 "$E/originales.sha256"

titulo "Parte 1 · Ocultar (equipo A)"
echo "Mensaje sintético FORTIS LAB04 · $(date -u '+%Y-%m-%d %H:%M') UTC" > secreto.txt
PASS="$(openssl rand -hex 6)"
echo "$PASS" > clave-ejercicio.txt
cp originales/*.bmp entregados/
steghide embed -q -f -cf entregados/logo.bmp -ef secreto.txt -p "$PASS"
ok "Mensaje oculto en uno de los tres archivos (clave del ejercicio: $PASS)"
{ echo "Portador: logo.bmp"; echo "Mensaje: $(cat secreto.txt)"; echo "Clave del ejercicio: $PASS"; } > "$E/parte1-ocultar.txt"

titulo "Parte 2 · Detectar y extraer (equipo B)"
{
  echo "## Comparación de hashes contra el registro original"
  sha256sum entregados/* | sed 's#entregados/#originales/#' > entregados.sha256
  diff <(sort -k2 originales.sha256) <(sort -k2 entregados.sha256) && echo "Sin cambios" || true
  echo
  SOSP=$(diff <(sort -k2 originales.sha256) <(sort -k2 entregados.sha256) | awk '/^>/{print $3}' | xargs -n1 basename)
  echo "Archivo sospechoso: $SOSP"
  echo; echo "## Tamaños"; ls -l originales/ entregados/
  echo; echo "## Metadatos del sospechoso"; exiftool -s -FileSize -ImageSize -BitDepth "entregados/$SOSP"
  echo; echo "## steghide info"; steghide info -p "$PASS" "entregados/$SOSP" 2>&1
  echo; echo "## Extracción"
  steghide extract -q -f -sf "entregados/$SOSP" -p "$PASS" -xf recuperado.txt && cat recuperado.txt
  diff -q secreto.txt recuperado.txt && echo "RESULTADO: mensaje recuperado íntegro"
  echo; echo "## Prueba con clave incorrecta"
  steghide extract -q -f -sf "entregados/$SOSP" -p "clave-equivocada" -xf /dev/null 2>&1 || true
} | tee "$E/parte2-deteccion.txt"

titulo "Parte 3 · Preservar (custodio)"
cp entregados/logo.bmp "$E/logo-estego.bmp"
cp recuperado.txt "$E/mensaje-recuperado.txt"
{
  echo "Evidencia: logo-estego.bmp (copia de trabajo; el original queda en $W/entregados)"
  echo "Hash al registrar: $(sha256sum "$E/logo-estego.bmp" | cut -d' ' -f1)"
  echo "Hash del portador limpio: $(grep logo.bmp originales.sha256 | cut -d' ' -f1)"
  echo "Conclusión: los hashes difieren, lo que prueba la alteración aunque la imagen se vea igual."
} | tee "$E/parte3-custodia.txt"

hashes "$E" lab04
titulo "FC-LAB-004 terminado"
echo "Dime «listo lab04» en el chat."
