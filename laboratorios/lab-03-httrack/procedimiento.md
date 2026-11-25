# Procedimiento · FC-LAB-003 Clonación controlada con HTTrack

> **Uso autorizado.** Ejecuta este laboratorio solo en equipos, dominios, archivos o aplicaciones propios o con autorización escrita (ver `framework/protocolos/reglas-de-compromiso.md`).

**Objetivo:** Obtener una copia local de un sitio autorizado para identificar recursos expuestos (comentarios, rutas, archivos) sin interactuar repetidamente con el servidor.

**Entorno:** Sitio propio, sitio de entrenamiento o la instancia local de OWASP Juice Shop (http://127.0.0.1:3000).

## 1. Instalación
```bash
sudo apt install httrack -y
mkdir -p ~/fortis/lab03 && cd ~/fortis/lab03
```

## 2. Clonar con límites (CP-003-01)
Ejemplo contra la instancia local de Juice Shop (o tu sitio autorizado):

```bash
httrack "http://127.0.0.1:3000/" -O ./copia -r3 -%c2 -A50000 -c2 -F "FORTIS-LAB03" -%v
```

| Opción | Significado |
|---|---|
| `-r3` | profundidad máxima 3 |
| `-%c2` / `-c2` | máximo 2 conexiones por segundo / simultáneas |
| `-A50000` | límite de 50 KB/s |
| `-F` | agente de usuario identificable (facilita la detección por el equipo defensivo) |

## 3. Analizar la copia (CP-003-02)
```bash
grep -rniE "<!--|todo|password|apikey|token|admin" ./copia | tee hallazgos-texto.txt
find ./copia -iregex ".*\.\(bak\|old\|zip\|sql\|log\|env\|md\)" | tee archivos-sensibles.txt
cat ./copia/*/robots.txt 2>/dev/null
```

Clasifica cada resultado en el anexo B (OWASP A05 Configuración incorrecta, CWE-200 exposición de información).

## 4. Detección (CP-003-03)
El analista defensivo revisa el registro del servidor y busca el agente `FORTIS-LAB03`. Anota si la clonación fue
detectable y en cuánto tiempo (indicador «tasa de detección»).

## 5. Evidencias
```bash
sha256sum hallazgos-texto.txt archivos-sensibles.txt > lab03.sha256
```
No subas la copia completa del sitio al repositorio: solo los listados anonimizados.

## Registro de evidencias
Registra cada evidencia con:

```bash
python scripts/registrar_evidencia.py laboratorios/lab-03-httrack/evidencias/<archivo> --caso <ID caso> --desc "<descripción>" --por "<rol>"
```

## Cierre
Completa [resultados.md](resultados.md), el anexo A (casos) y, si hubo hallazgos, los anexos B y D.
