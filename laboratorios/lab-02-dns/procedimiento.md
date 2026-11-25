# Procedimiento · FC-LAB-002 DNS Footprinting con nslookup y dig

> **Uso autorizado.** Ejecuta este laboratorio solo en equipos, dominios, archivos o aplicaciones propios o con autorización escrita (ver `framework/protocolos/reglas-de-compromiso.md`).

**Objetivo:** Inventariar la información DNS pública de un dominio autorizado y verificar que la transferencia de zona está restringida.

**Entorno:** Dominio propio o autorizado por escrito; para practicar la transferencia de zona se puede usar zonetransfer.me, dominio público creado con ese fin.

## 1. Definir variables
```bash
DOM=tu-dominio-autorizado.com
RES=1.1.1.1
mkdir -p ~/fortis/lab02 && cd ~/fortis/lab02
```

## 2. Enumerar registros (CP-002-01)
Con `nslookup`:

```bash
nslookup -type=A $DOM $RES
nslookup -type=MX $DOM $RES
nslookup -type=NS $DOM $RES
```

Con `dig`, guardando la salida:

```bash
for t in A AAAA MX NS TXT SOA CAA; do
  echo "== $t"; dig +noall +answer $DOM $t @$RES
done | tee registros.txt
```

Resolución inversa de cada IP obtenida:

```bash
dig +short -x <IP>
```

## 3. Transferencia de zona (CP-002-02)
Obtén los servidores autoritativos y pide la zona a cada uno. En un dominio bien configurado la respuesta debe ser
`Transfer failed` o `REFUSED`:

```bash
for ns in $(dig +short NS $DOM); do echo "== $ns"; dig AXFR $DOM @$ns; done | tee axfr.txt
```

Para ver cómo luce una transferencia permitida (configuración insegura), repite el comando con `zonetransfer.me`, dominio
público mantenido para practicar este caso.

## 4. Analizar la exposición (CP-002-03)
Revisa `registros.txt` y anota en el anexo B todo registro que revele servicios internos, proveedores, versiones o
nombres de hosts innecesarios. Referencia: MITRE ATT&CK T1590.002 (información DNS de la víctima).

## 5. Evidencias
```bash
sha256sum registros.txt axfr.txt > lab02.sha256
```

## Registro de evidencias
Registra cada evidencia con:

```bash
python scripts/registrar_evidencia.py laboratorios/lab-02-dns/evidencias/<archivo> --caso <ID caso> --desc "<descripción>" --por "<rol>"
```

## Cierre
Completa [resultados.md](resultados.md), el anexo A (casos) y, si hubo hallazgos, los anexos B y D.
