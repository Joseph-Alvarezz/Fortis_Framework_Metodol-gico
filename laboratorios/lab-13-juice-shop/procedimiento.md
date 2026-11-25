# Procedimiento · FC-LAB-013

## 1. Preparar el entorno (fase 01)
Con Docker Desktop abierto, publicar la aplicación **solo en la interfaz local**:

```bash
docker run --rm -p 127.0.0.1:3000:3000 bkimminich/juice-shop
```

Comprobar que escucha solo en 127.0.0.1:

```powershell
netstat -ano | findstr :3000
```

Registrar la versión e identificador de la imagen como evidencia EV-JS-00-02.

## 2. Línea base (fase 02)
Documentar la configuración inicial y los indicadores antes de las pruebas.

## 3. Ejecutar los casos (fase 03)
Ejecutar CP-JS-01 a CP-JS-06 según [casos-estudio/juice-shop/protocolo.md](../../casos-estudio/juice-shop/protocolo.md),
apoyándose en la guía oficial *Pwning OWASP Juice Shop* (https://pwning.owasp-juice.shop) y en el Score Board de la
aplicación. Cada captura se registra con:

```bash
python scripts/registrar_evidencia.py laboratorios/lab-13-juice-shop/evidencias/EV-JS-01-01.png --caso CP-JS-01 --desc "Cabeceras HTTP de la página principal" --por "Analista ofensivo"
```

## 4. Analizar, mitigar y verificar (fases 04–06)
Completar los anexos B y D, calcular severidad con `scripts/severidad.py` y documentar el re-test en `resultados.md`.

## 5. Cierre
Detener el contenedor (Ctrl + C). Al usar `--rm` no quedan datos persistentes.
