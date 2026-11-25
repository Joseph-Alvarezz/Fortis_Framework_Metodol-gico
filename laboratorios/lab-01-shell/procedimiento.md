# Procedimiento · FC-LAB-001 Comandos Shell y Kali Linux

> **Uso autorizado.** Ejecuta este laboratorio solo en equipos, dominios, archivos o aplicaciones propios o con autorización escrita (ver `framework/protocolos/reglas-de-compromiso.md`).

**Objetivo:** Preparar y documentar un entorno de trabajo reproducible en Kali Linux y dominar los comandos de shell que usan los demás laboratorios.

**Entorno:** Máquina virtual Kali Linux propia (VirtualBox o VMware) con red NAT o solo-anfitrión.

## 1. Verificar la imagen (CP-001-01)
Descarga la imagen desde https://www.kali.org/get-kali/ y compara su SHA-256 con el publicado en la misma página:

```powershell
Get-FileHash .\kali-linux-*.iso -Algorithm SHA256
```

## 2. Crear la máquina virtual
- 2 CPU, 4 GB de RAM, 40 GB de disco.
- Red **NAT** o **solo-anfitrión**: el laboratorio no necesita exponerse a la red local.
- Crea un usuario no root y actualiza el sistema:

```bash
sudo apt update && sudo apt full-upgrade -y
```

## 3. Documentar el entorno (CP-001-02)
```bash
mkdir -p ~/fortis/lab01 && cd ~/fortis/lab01
{ date -u; uname -a; cat /etc/os-release; whoami; id; ip -br addr; } > entorno.txt
```

## 4. Comandos base y bitácora (CP-001-03)
Inicia la grabación de la sesión y practica los comandos de cada grupo:

```bash
script -q bitacora-lab01.txt
```

| Grupo | Comandos |
|---|---|
| Navegación y archivos | `pwd`, `ls -la`, `cd`, `mkdir -p`, `cp`, `mv`, `rm -i`, `find . -name "*.txt"` |
| Lectura y búsqueda | `cat`, `less`, `head`, `tail -f`, `grep -rn`, `wc -l` |
| Permisos | `chmod 640`, `chown`, `umask`, `ls -l` (interpretar `rwx`) |
| Procesos | `ps aux`, `top`, `kill`, `jobs`, `systemctl status` |
| Red (solo lectura) | `ip a`, `ip route`, `ss -tulpn`, `ping -c 4 127.0.0.1`, `cat /etc/resolv.conf` |
| Integridad | `sha256sum archivo`, `sha256sum -c lista.sha256` |
| Paquetes | `apt search`, `apt show`, `dpkg -l | grep nombre` |

Cierra la grabación con `exit` y calcula el hash:

```bash
sha256sum bitacora-lab01.txt entorno.txt > lab01.sha256
```

## 5. Copiar las evidencias al repositorio
Copia `entorno.txt`, `bitacora-lab01.txt` y `lab01.sha256` a `evidencias/` y regístralas en el anexo C.

## Registro de evidencias
Registra cada evidencia con:

```bash
python scripts/registrar_evidencia.py laboratorios/lab-01-shell/evidencias/<archivo> --caso <ID caso> --desc "<descripción>" --por "<rol>"
```

## Cierre
Completa [resultados.md](resultados.md), el anexo A (casos) y, si hubo hallazgos, los anexos B y D.
