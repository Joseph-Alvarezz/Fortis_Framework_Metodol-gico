#!/usr/bin/env bash
# Prepara Kali para los laboratorios FORTIS: instala herramientas y verifica la carpeta compartida
source "$(dirname "$0")/comun.sh"

titulo "Herramientas"
PAQ="dnsutils httrack steghide libimage-exiftool-perl curl docker.io"
FALTAN=""
for p in $PAQ; do dpkg -s "$p" >/dev/null 2>&1 || FALTAN="$FALTAN $p"; done
if [ -n "$FALTAN" ]; then
  aviso "Instalando:$FALTAN (pedirá tu contraseña de Kali)"
  sudo apt-get update -qq && sudo apt-get install -y $FALTAN
else
  ok "Todo instalado"
fi
for c in dig nslookup httrack steghide exiftool sha256sum docker; do
  command -v "$c" >/dev/null && ok "$c" || aviso "$c no disponible"
done

titulo "Docker (para Juice Shop en los laboratorios 003 y 007)"
sudo systemctl enable --now docker >/dev/null 2>&1 && ok "Docker activo" || aviso "No pude iniciar Docker"
id -nG | grep -qw docker || { sudo usermod -aG docker "$USER"; aviso "Te agregué al grupo docker: cierra sesión y vuelve a entrar para usarlo sin sudo"; }

titulo "Repositorio"
ok "Repositorio en $REPO"
touch "$LOGDIR/.prueba-escritura" && rm "$LOGDIR/.prueba-escritura" && ok "Puedo escribir en la carpeta compartida"

echo
echo "Listo. Ahora ejecuta, en orden:"
echo "  bash $REPO/scripts/kali/lab01.sh"
echo "  bash $REPO/scripts/kali/lab02.sh"
echo "  bash $REPO/scripts/kali/lab04.sh"
echo "  bash $REPO/scripts/kali/juice-shop.sh   # inicia Juice Shop en 127.0.0.1:3000"
echo "  bash $REPO/scripts/kali/lab03.sh"
echo "  bash $REPO/scripts/kali/lab08.sh   # detección (requiere Juice Shop)"
