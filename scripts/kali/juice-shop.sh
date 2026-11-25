#!/usr/bin/env bash
# Inicia OWASP Juice Shop solo en la interfaz local de Kali (127.0.0.1:3000) para los laboratorios 003, 007 y 013
source "$(dirname "$0")/comun.sh"
E="$REPO/laboratorios/lab-13-juice-shop/evidencias"; mkdir -p "$E"
DOCKER="docker"; id -nG | grep -qw docker || DOCKER="sudo docker"

if $DOCKER ps --format '{{.Names}}' | grep -qx juice-shop; then
  ok "Juice Shop ya está corriendo"
else
  titulo "Descargando e iniciando Juice Shop"
  $DOCKER pull bkimminich/juice-shop
  $DOCKER run -d --rm --name juice-shop -p 127.0.0.1:3000:3000 bkimminich/juice-shop >/dev/null
  for i in $(seq 1 60); do curl -s -o /dev/null http://127.0.0.1:3000 && break; sleep 2; done
fi

{
  echo "Fecha (UTC): $(date -u '+%Y-%m-%d %H:%M:%S')"
  echo "Imagen: $($DOCKER inspect --format '{{.Config.Image}} {{.Image}}' juice-shop)"
  echo "Versión: $(curl -s http://127.0.0.1:3000/rest/admin/application-version)"
  echo "Escucha:"; ss -tlnp 2>/dev/null | grep ':3000' || sudo ss -tlnp | grep ':3000'
} | tee "$E/EV-JS-00-02-entorno.txt"
grep -q "127.0.0.1:3000" "$E/EV-JS-00-02-entorno.txt" && ok "Solo escucha en 127.0.0.1 (no expuesto a la red)" || aviso "Revisa la dirección de escucha"
echo
echo "Abre Firefox en Kali: http://127.0.0.1:3000"
echo "Para detenerlo:  $DOCKER stop juice-shop"
echo "Para ver sus registros (detección):  $DOCKER logs -f juice-shop"
