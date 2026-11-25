#!/usr/bin/env bash
# FC-LAB-003 · Clonación controlada con HTTrack sobre Juice Shop local
source "$(dirname "$0")/comun.sh"
E="$REPO/laboratorios/lab-03-httrack/evidencias"; mkdir -p "$E"
W="$HOME/fortis/lab03"; rm -rf "$W"; mkdir -p "$W"; cd "$W"
URL="http://127.0.0.1:3000/"
DOCKER="docker"; id -nG | grep -qw docker || DOCKER="sudo docker"
curl -s -o /dev/null "$URL" || { aviso "Juice Shop no responde. Ejecuta primero scripts/kali/juice-shop.sh"; exit 1; }

INICIO="$(date -u '+%Y-%m-%dT%H:%M:%S')"
titulo "CP-003-01 · Clonación con límites (profundidad 3, 2 conexiones, 50 KB/s)"
# Límites: profundidad 3, 2 conexiones, 500 KB/s y 4 minutos como máximo; muestra el progreso en vivo
OPC="-r3 -c2 -%c2 -A500000 -E240 -F FORTIS-LAB03"
echo "Clonando (máximo 4 minutos)…"
httrack "$URL" -O ./copia $OPC -%v -q 2>&1 | grep --line-buffered -oE "[^ ]*127\.0\.0\.1:3000[^ ]*" | sed -u 's#^#  descargado: #' | head -n 200
{
  echo "Inicio (UTC): $INICIO · Fin (UTC): $(date -u '+%Y-%m-%dT%H:%M:%S')"
  echo "Comando: httrack $URL -O ./copia $OPC"
  echo "Archivos descargados: $(find copia -type f | wc -l) · Tamaño: $(du -sh copia | cut -f1)"
  echo; echo "Estructura:"; find copia -maxdepth 3 -type d | sed 's#^copia/##' | sort
} | tee "$E/clonacion.txt"

titulo "CP-003-02 · Búsqueda de información expuesta en la copia"
{
  echo "## Comentarios HTML"; grep -rhoE "<!--.{0,120}-->" copia --include='*.htm*' --exclude-dir=hts-cache | grep -viE "httrack|prologue|epilogue" | sort -u | head -n 30
  echo; echo "## Palabras sensibles (primeras coincidencias)"
  grep -rnoiE ".{0,40}(password|apikey|api_key|secret|token|todo|fixme).{0,40}" copia --exclude-dir=hts-cache --exclude='hts-*' 2>/dev/null | cut -c1-160 | head -n 40
  echo; echo "## Rutas de API referenciadas en el código del cliente"
  grep -rhoE "(/rest|/api)/[A-Za-z0-9_/.-]+" copia 2>/dev/null | sort | uniq -c | sort -rn | head -n 40
  echo; echo "## Archivos con extensiones sensibles"
  find copia -path copia/hts-cache -prune -o -type f -iregex '.*\.\(bak\|old\|zip\|sql\|log\|env\|md\|kdbx\|pyc\)' -print | sed 's#^copia/##'
  echo; echo "## robots.txt"; curl -s "${URL}robots.txt"
} | tee "$E/exposicion.txt"

titulo "CP-003-03 · ¿Lo detectó el servidor?"
{
  echo "Registros del servidor desde $INICIO:"
  $DOCKER logs --since "$INICIO" juice-shop 2>&1 | tail -n 20
  echo
  echo "Solicitudes con el agente FORTIS-LAB03 visibles en los registros: $($DOCKER logs --since "$INICIO" juice-shop 2>&1 | grep -c FORTIS-LAB03)"
  echo "Nota: Juice Shop no registra cada solicitud HTTP por defecto; si el conteo es 0, la clonación no fue detectable"
  echo "solo con los registros de la aplicación (hallazgo A09: registro y monitoreo insuficientes)."
} | tee "$E/deteccion.txt"

hashes "$E" lab03
titulo "FC-LAB-003 terminado"
echo "La copia completa queda en $W (no se sube al repositorio). Dime «listo lab03» en el chat."
