#!/usr/bin/env bash
# Funciones comunes de los scripts de laboratorio FORTIS en Kali
set -u
REPO="${FORTIS_REPO:-/media/sf_fortis}"
if [ ! -d "$REPO/laboratorios" ]; then
  echo "No encuentro el repositorio en $REPO."
  echo "Comprueba la carpeta compartida (ls /media) o define FORTIS_REPO=/ruta/al/repo"
  exit 1
fi
LOGDIR="$REPO/resultados/kali"
mkdir -p "$LOGDIR"

titulo() { printf '\n\033[1;34m== %s ==\033[0m\n' "$*"; }
ok()     { printf '\033[1;32m[OK]\033[0m %s\n' "$*"; }
aviso()  { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }

# Ejecuta un comando, lo muestra con su prompt y guarda comando + salida
run() {
  printf '$ %s\n' "$*"
  bash -c "$*" 2>&1
  printf '\n'
}

# Calcula los SHA-256 de todos los archivos de evidencias del laboratorio
hashes() {
  local dir="$1" nombre="$2"
  ( cd "$dir" && find . -maxdepth 1 -type f ! -name '*.sha256' -printf '%f\n' | sort | xargs -r sha256sum > "$nombre.sha256" )
  ok "Hashes en $dir/$nombre.sha256"
}
