#!/usr/bin/env bash
# FC-LAB-008 · Detección y análisis de registros
# Pone un proxy nginx con registro de acceso y límite de tasa delante de Juice Shop (mitigación M-003-03),
# repite la clonación de FC-LAB-003 a través del proxy y aplica reglas de detección sobre el registro.
source "$(dirname "$0")/comun.sh"
E="$REPO/laboratorios/lab-08-deteccion/evidencias"; mkdir -p "$E"
W="$HOME/fortis/lab08"; rm -rf "$W"; mkdir -p "$W/logs"; cd "$W"
DOCKER="docker"; id -nG | grep -qw docker || DOCKER="sudo docker"
PROXY="http://127.0.0.1:8080/"

$DOCKER ps --format '{{.Names}}' | grep -qx juice-shop || { aviso "Juice Shop no está corriendo. Ejecuta primero scripts/kali/juice-shop.sh"; exit 1; }

titulo "Control · Proxy nginx con registro de acceso y límite de tasa"
cat > nginx.conf <<'EOF'
log_format fortis '$remote_addr|$time_iso8601|$request|$status|$body_bytes_sent|$http_user_agent|$request_time';
limit_req_zone $binary_remote_addr zone=fortis:10m rate=10r/s;
server {
  listen 80;
  access_log /var/log/nginx/fortis.log fortis;
  location / {
    limit_req zone=fortis burst=20 nodelay;
    limit_req_status 429;
    proxy_pass http://juice-shop:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $remote_addr;
  }
}
EOF
$DOCKER network inspect fortis-net >/dev/null 2>&1 || $DOCKER network create fortis-net >/dev/null
$DOCKER network connect fortis-net juice-shop 2>/dev/null || true
$DOCKER rm -f fortis-proxy >/dev/null 2>&1 || true
$DOCKER run -d --name fortis-proxy --network fortis-net -p 127.0.0.1:8080:80 \
  -v "$W/nginx.conf:/etc/nginx/conf.d/default.conf:ro" -v "$W/logs:/var/log/nginx" nginx:stable-alpine >/dev/null
for i in $(seq 1 30); do curl -s -o /dev/null "$PROXY" && break; sleep 1; done
cp nginx.conf "$E/nginx.conf"
{
  echo "Proxy: $($DOCKER inspect --format '{{.Config.Image}} {{.Image}}' fortis-proxy)"
  echo "Escucha:"; ss -tln | grep -E ':8080\b'
} | tee "$E/entorno-proxy.txt"

titulo "CP-008-01 · Línea base: navegación normal"
INI_BASE="$(date -u '+%Y-%m-%dT%H:%M:%S')"
UA_NORMAL="Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"
for p in "" "rest/products/search?q=" "rest/languages" "api/Quantitys" "rest/admin/application-version"; do
  curl -s -o /dev/null -w "%{http_code} /$p\n" -A "$UA_NORMAL" "$PROXY$p"; sleep 1
done | tee "$E/linea-base.txt"

titulo "CP-008-02 · Re-test de FC-LAB-003: clonación a través del proxy"
INI_ATQ="$(date -u '+%Y-%m-%dT%H:%M:%S')"
echo "Clonando por el proxy (máximo 2 minutos)…"
httrack "$PROXY" -O ./copia -r3 -c2 -%c2 -A500000 -E120 -F "FORTIS-LAB03" -q >/dev/null 2>&1
FIN_ATQ="$(date -u '+%Y-%m-%dT%H:%M:%S')"
echo "Clonación: $INI_ATQ → $FIN_ATQ · archivos: $(find copia -type f ! -path '*hts-cache*' | wc -l)" | tee "$E/clonacion.txt"
sleep 1
cp logs/fortis.log "$E/access.log"
LOG="$E/access.log"

titulo "CP-008-02 · Reglas de detección"
{
  echo "Registro analizado: access.log ($(wc -l < "$LOG") solicitudes)"
  echo
  echo "## Solicitudes por agente de usuario"
  awk -F'|' '{print $6}' "$LOG" | sort | uniq -c | sort -rn
  echo
  echo "## Regla R1 · Agente de herramienta automatizada (httrack, curl, wget, python, nikto, sqlmap, FORTIS)"
  R1=$(awk -F'|' 'tolower($6) ~ /httrack|fortis|curl|wget|python|nikto|sqlmap/' "$LOG" | wc -l)
  awk -F'|' 'tolower($6) ~ /httrack|fortis|curl|wget|python|nikto|sqlmap/ {print $6}' "$LOG" | sort | uniq -c
  echo "Coincidencias R1: $R1"
  echo
  echo "## Regla R2 · Más de 60 solicitudes por minuto desde una misma IP"
  awk -F'|' '{print $1" "substr($2,1,16)}' "$LOG" | sort | uniq -c | awk '$1>60 {print "ALERTA R2: "$1" solicitudes de "$2" en el minuto "$3}' | tee r2.tmp
  echo "Minutos que disparan R2: $(wc -l < r2.tmp)"
  echo
  echo "## Regla R3 · Respuestas 429 (límite de tasa aplicado)"
  R3=$(awk -F'|' '$4==429' "$LOG" | wc -l)
  echo "Respuestas 429: $R3"
  awk -F'|' '{print $4}' "$LOG" | sort | uniq -c | sort -rn | sed 's/^/  código /'
  echo
  echo "## Línea base (navegación normal) · ¿genera falsos positivos?"
  FP=$(awk -F'|' -v ua="$UA_NORMAL" '$6==ua && tolower($6) ~ /httrack|fortis|curl|wget|python|nikto|sqlmap/' "$LOG" | wc -l)
  echo "Solicitudes normales: $(awk -F'|' -v ua="$UA_NORMAL" '$6==ua' "$LOG" | wc -l) · marcadas por R1: $FP"
  echo
  echo "## Resultado"
  [ "$R1" -gt 0 ] && echo "DETECTADO por R1 (agente)" || echo "No detectado por R1"
  [ -s r2.tmp ] && echo "DETECTADO por R2 (volumen)" || echo "No detectado por R2"
  [ "$R3" -gt 0 ] && echo "MITIGADO parcialmente: $R3 solicitudes rechazadas por límite de tasa" || echo "El límite de tasa no se activó"
} | tee "$E/alertas.txt"
rm -f r2.tmp

hashes "$E" lab08
titulo "FC-LAB-008 terminado"
echo "El proxy sigue activo en 127.0.0.1:8080. Para detenerlo: $DOCKER rm -f fortis-proxy"
echo "Dime «listo lab08» en el chat."
