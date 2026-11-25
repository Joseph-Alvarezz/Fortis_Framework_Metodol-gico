#!/usr/bin/env bash
# FC-LAB-001 · Comandos Shell y Kali Linux
source "$(dirname "$0")/comun.sh"
E="$REPO/laboratorios/lab-01-shell/evidencias"; mkdir -p "$E"
W="$HOME/fortis/lab01"; mkdir -p "$W"

titulo "CP-001-02 · Documentar el entorno"
{
  echo "Fecha (UTC): $(date -u '+%Y-%m-%d %H:%M:%S')"
  echo "Equipo: $(hostname)"; echo "Usuario: $(whoami)"; id
  echo; uname -a; echo; cat /etc/os-release
  echo; echo "Red:"; ip -br addr
  echo; echo "Ruta por defecto:"; ip route | grep default
  echo; echo "CPU: $(nproc) · Memoria: $(free -h | awk '/Mem:/{print $2}') · Disco /: $(df -h / | awk 'NR==2{print $2" ("$5" usado)"}')"
} | tee "$E/entorno.txt"

titulo "CP-001-03 · Comandos base"
cd "$W"
{
  echo "# Bitácora FC-LAB-001 · $(date -u '+%Y-%m-%d %H:%M:%S') UTC · $(whoami)@$(hostname)"
  echo; echo "## Navegación y archivos"
  run "pwd"
  run "mkdir -p demo/{docs,logs} && touch demo/docs/{informe,notas}.txt demo/logs/app.log && ls -laR demo"
  run "cp demo/docs/informe.txt demo/docs/informe.bak && mv demo/docs/notas.txt demo/docs/notas.md && ls demo/docs"
  run "find demo -name '*.txt'"
  echo "## Lectura y búsqueda"
  run "printf 'INFO inicio\nERROR fallo de conexión\nINFO reintento\nERROR tiempo agotado\n' > demo/logs/app.log"
  run "head -n 2 demo/logs/app.log"
  run "grep -n ERROR demo/logs/app.log"
  run "grep -c ERROR demo/logs/app.log"
  run "wc -l demo/logs/app.log"
  echo "## Permisos"
  run "umask"
  run "chmod 640 demo/docs/informe.txt && ls -l demo/docs/informe.txt"
  run "chmod 700 demo/logs && ls -ld demo/logs"
  echo "## Procesos y servicios"
  run "ps aux --sort=-%mem | head -n 6"
  run "systemctl is-active ssh || true"
  echo "## Red (solo lectura)"
  run "ip -br addr"
  run "ip route"
  run "ss -tulpn 2>/dev/null | head -n 10"
  run "cat /etc/resolv.conf"
  run "ping -c 2 127.0.0.1"
  echo "## Integridad"
  run "sha256sum demo/docs/informe.txt demo/logs/app.log > demo/lista.sha256 && cat demo/lista.sha256"
  run "sha256sum -c demo/lista.sha256"
  run "echo 'alterado' >> demo/logs/app.log; sha256sum -c demo/lista.sha256 || echo 'Integridad rota: el archivo cambió'"
  echo "## Paquetes"
  run "apt-cache policy coreutils | head -n 3"
  run "dpkg -l | grep -E '^ii +(nmap|steghide|httrack) ' || true"
} | tee "$E/bitacora-lab01.txt"

hashes "$E" lab01
titulo "FC-LAB-001 terminado"
echo "Evidencias en laboratorios/lab-01-shell/evidencias/. Dime «listo lab01» en el chat."
