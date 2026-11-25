#!/usr/bin/env bash
# FC-LAB-002 · DNS Footprinting con nslookup y dig
# Dominio: zonetransfer.me, publicado por DigiNinja para practicar reconocimiento DNS y transferencia de zona.
source "$(dirname "$0")/comun.sh"
E="$REPO/laboratorios/lab-02-dns/evidencias"; mkdir -p "$E"
DOM="${1:-zonetransfer.me}"
RES="${RES:-1.1.1.1}"
echo "Dominio: $DOM · Resolvedor: $RES · $(date -u '+%Y-%m-%d %H:%M:%S') UTC" | tee "$E/contexto.txt"

titulo "CP-002-01 · Registros con dig"
for vuelta in 1 2; do
  for t in A AAAA MX NS TXT SOA CAA; do
    echo "== $t"; dig +noall +answer "$DOM" "$t" @"$RES" | sort
  done > "$E/registros-ejecucion$vuelta.txt"
done
cat "$E/registros-ejecucion1.txt"
if diff -q "$E/registros-ejecucion1.txt" "$E/registros-ejecucion2.txt" >/dev/null; then
  ok "Dos ejecuciones idénticas (criterio de reproducibilidad)" | tee -a "$E/contexto.txt"
else
  aviso "Las dos ejecuciones difieren (revisa TTL o balanceo)" | tee -a "$E/contexto.txt"
fi

titulo "CP-002-01 · Registros con nslookup"
{ for t in A MX NS TXT SOA; do echo "== $t"; nslookup -type=$t "$DOM" "$RES" | sed -n '/Non-authoritative\|answer:/,$p'; done; } | tee "$E/nslookup.txt"

titulo "CP-002-01 · Resolución inversa"
for ip in $(dig +short "$DOM" A @"$RES"); do echo "$ip -> $(dig +short -x "$ip" @"$RES")"; done | tee "$E/inversa.txt"

titulo "CP-002-02 · Transferencia de zona (AXFR)"
: > "$E/axfr.txt"
for ns in $(dig +short NS "$DOM" @"$RES"); do
  echo "== Servidor $ns" | tee -a "$E/axfr.txt"
  dig AXFR "$DOM" @"$ns" +time=5 +tries=1 | tee -a "$E/axfr.txt" | tail -n 4
done
N=$(grep -cE "^[^;].*\s(IN)\s" "$E/axfr.txt" || true)
if grep -qiE "Transfer failed|REFUSED|connection timed out" "$E/axfr.txt" && [ "$N" -eq 0 ]; then
  ok "AXFR denegada: control efectivo" | tee -a "$E/contexto.txt"
else
  aviso "AXFR PERMITIDA: se obtuvieron $N registros de la zona completa (hallazgo)" | tee -a "$E/contexto.txt"
fi

titulo "CP-002-03 · Registros que revelan información"
grep -E "\s(TXT|HINFO|RP|LOC|SRV|CNAME)\s" "$E/axfr.txt" | sort -u | tee "$E/exposicion.txt"
echo "Tipos encontrados en la zona:" | tee -a "$E/exposicion.txt"
grep -E "^[^;].*\sIN\s" "$E/axfr.txt" | awk '{print $4}' | sort | uniq -c | sort -rn | tee -a "$E/exposicion.txt"

hashes "$E" lab02
titulo "FC-LAB-002 terminado"
echo "Dime «listo lab02» en el chat."
